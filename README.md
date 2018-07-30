## iptables Spamhaus DROP List pull-and-load script (for Cron) ##
A shell script that grabs the latest Spamhaus DROP List and adds it to iptables.

In our experience, this has successfully killed the last and hardest 35% of spam received by our mailserver.

Additional blocklists can easily be added by popping their download URLs into the script (see the `URLS=` line).

By default we're loading both the `drop` and `edrop` lists - which means you should pull-and-load frequently: https://www.spamhaus.org/drop/

## Usage ##
Copy pull-and-load script to a suitable location.

(We use `/etc/cron.daily/spamhaus-drop`.  Make sure it's executable by root.)

## Troubleshooting ##
If you need to remove all the Spamhaus rules, run the following:
<pre>
sudo iptables -F Spamhaus
</pre>

## Todo
Whitelists and validation.  We shouldn't implicitly trust a third party's block list!
