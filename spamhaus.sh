#!/bin/bash

## Intially forked from cowgill, extended and improved for our mailserver needs.
## Credit: https://github.com/cowgill/spamhaus/blob/master/spamhaus.sh

# based off the following two scripts
# http://www.theunsupported.com/2012/07/block-malicious-ip-addresses/
# http://www.cyberciti.biz/tips/block-spamming-scanning-with-iptables.html

# path to iptables
IPTABLES="/sbin/iptables"

# list of known spammers
URLS="www.spamhaus.org/drop/drop.lasso www.spamhaus.org/drop/edrop.lasso"

# save local copy here
FILE="/tmp/drop.lasso"

# iptables custom chain
CHAIN="Spamhaus"

# check to see if the chain already exists
$IPTABLES -L "$CHAIN" -n

# check to see if the chain already exists
if [ $? -eq 0 ]; then
    # flush the old rules
    $IPTABLES -F "$CHAIN"

    echo "Flushed old rules. Applying updated Spamhaus list...."
else
    # create a new chain set
    $IPTABLES -N "$CHAIN"

    # tie chain to input rules so it runs
    $IPTABLES -A INPUT -j "$CHAIN"

    # don't allow this traffic through
    $IPTABLES -A FORWARD -j "$CHAIN"

    echo "Chain not detected. Creating new chain and adding Spamhaus list...."
fi;

for URL in $URLS; do
    # get a copy of the spam list
    echo "Fetching $URL ..."
    wget -qc "$URL" -O "$FILE"
    tail "$FILE"

    # iterate through all known spamming hosts
    for IP in $( cat "$FILE" | egrep -v '^;' | cut -d' ' -f1 ); do
        # add the ip address log rule to the chain
        $IPTABLES -A "$CHAIN" -p 0 -s "$IP" -j LOG --log-prefix "[SPAMHAUS BLOCK]" -m limit --limit 3/min --limit-burst 10

        # add the ip address to the chain
        $IPTABLES -A "$CHAIN" -p 0 -s "$IP" -j DROP

        echo "$IP"
    done

    # remove the spam list
    unlink "$FILE"
done

echo "Done!"
