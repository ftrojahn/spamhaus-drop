## iptables Spamhaus DROP List pull-and-load script (for Cron)
A shell script that grabs the latest Spamhaus DROP List and adds it to iptables.

In our experience, this has successfully killed the last and hardest 35% of spam received by our mailserver.

Additional blocklists can easily be added by popping their download URLs into the script.

By default we're loading both the `drop` and `edrop` lists - which means you should pull-and-load frequently: https://www.spamhaus.org/drop/

## Usage
Install the `spamhaus-drop` script somewhere sensible (i.e. `/usr/local/sbin`).  Make sure you've read the script, and are happy with what it does.

Then install a `cronjob` to run the script periodically (spamhaus do ask that you don't download the lists more than once a day).

For example, create an executable script named `/etc/cron.daily/spamhaus-drop`:

```
#!/bin/sh
/usr/local/sbin/spamhaus-drop -u
```

### Important warning
This script **by design** downloads lists of IP ranges from a 3rd party source (spamhaus) and adds `DROP` instructions to your iptables firewall.

Just stop and think for a moment - the consequences of this may be dire.  Be certain you trust the sources and be certain you're downloading them securely (i.e. over HTTPS, at a minimum).

## Optional arguments

You may wish to apply some "value overrides" to the script, or delete the iptables chain it installs, or separate downloading the latest blocklist from applying them (perhaps to perform your own sanity checks, or to add additional records):

```
  -u                   Download blocklists and update iptables
  -c=CHAIN_NAME        Override default iptables chain name
  -l=URL_LIST          Override default block list URLs [careful!]
  -f=CACHE_FILE_PATH   Override default cache file path
  -m=LOCAL_FILE_PATH   Use my own local additional block list file
  -s                   Skip failed blocklist downloads, continuing instead of aborting
  -z                   Update the blocklist from the local cache, don't download new entries
  -d                   Delete the iptables chain (removing all blocklists)
  -o                   Only download the blocklists, don't update iptables
  -t                   Disable logging of blocklist hits in iptables
  -h                   Display this help message
```

## Todo
Whitelists and validation.  We shouldn't implicitly trust a third party's block list!  Private IP addresses etc should be whitelisted by default, but are not.
