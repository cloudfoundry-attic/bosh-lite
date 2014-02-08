Running bosh-lite and cloudfoundry using a custom dns and offline
=================================================================

by Vinicius Carvalho

1 Install dnsmasq:

A simple dns proxy for mac, its really easy to install if you have homebrew on your system

`brew install dnsmaq`

`sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons`

Modify the file to add an entry for your custom DNS, for example:

`address=/.vincloud.com/10.244.0.34`

Will add an wildcard domain pointing to my HA-PROXY machine in cloudfoundry

Next step, edit `cf-releases/cf-release.yml`, replace any occurrence of xxx.xxx.xxx.xxx.xip.io with your own custom domain, you may end up with something like this:

```
    resource_directory_key: vincloud.com-cc-resources
    srv_api_uri: https://api.vincloud.com
```

```
+------------------------------------+---------+---------------+-------------+
| Job/index                          | State   | Resource Pool | IPs         |
+------------------------------------+---------+---------------+-------------+
| api_z1/0                           | running | large_z1      | 10.244.1.10 |
| ha_proxy_z1/0                      | running | router_z1     | 10.244.0.34 |
| hm_z1/0                            | running | medium_z1     | 10.244.1.14 |
| loggregator_trafficcontroller_z1/0 | running | small_z1      | 10.244.0.10 |
| loggregator_trafficcontroller_z2/0 | running | small_z2      | 10.244.2.10 |
| loggregator_z1/0                   | running | large_z1      | 10.244.0.14 |
| loggregator_z2/0                   | running | large_z2      | 10.244.2.14 |
| login_z1/0                         | running | medium_z1     | 10.244.1.6  |
| nats_z1/0                          | running | medium_z1     | 10.244.0.6  |
| postgres_z1/0                      | running | large_z1      | 10.244.0.30 |
| router_z1/0                        | running | router_z1     | 10.244.0.22 |
| runner_z1/0                        | running | runner_z1     | 10.244.0.26 |
| taskmaster_z1/0                    | running | runner_z1     | 10.244.1.18 |
| uaa_z1/0                           | running | large_z1      | 10.244.1.2  |
+------------------------------------+---------+---------------+-------------+
```

Go to your network preferences and add `127.0.0.1` as your first DNS server.

you can now use `cf target http://api.<YOURDOMAIN>` instead of the xip.io version.

Running offline

You may not have network connectivity sometimes. I had a hard time getting OSX to use the nameserver once my network was down, thanks to [this serverfault post](http://serverfault.com/questions/22419/set-dns-server-on-os-x-even-when-without-internet-connection/164215#164215)

Set all your network interface dns servers to 127.0.0.1:

```
   networksetup -setdnsservers Ethernet 127.0.0.1
   networksetup -setdnsservers Wi-Fi 127.0.0.1
    ...
```

Create a file `/etc/resolver/whatever`:
   nameserver 127.0.0.1
    domain .

Now this should work offline.