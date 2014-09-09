## SSH into deployment jobs

Use `bosh ssh` to SSH into running jobs of a deployment.

### For local providers:

Run the following command:

```
bin/add-route
```

Now you can SSH into any VM with `bosh ssh`:

```
$ bosh ssh
1. ha_proxy_z1/0
2. nats_z1/0
3. etcd_z1/0
4. postgres_z1/0
5. uaa_z1/0
6. login_z1/0
7. api_z1/0
8. hm9000_z1/0
9. runner_z1/0
10. loggregator_z1/0
11. loggregator_trafficcontroller_z1/0
12. router_z1/0
13. acceptance_tests/0
14. acceptance_tests_diego/0
15. smoke_tests/0
Choose an instance:
```

Note: `bosh shh` automatically finds and uses the first key from your ssh keychain. If you do not have any RSA keys, you must create one. In a unix environment, this can be accomplished using `ssh-keygen`. You can then and add it to your keychain or you can pass the public key file to the command `bosh ssh --public_key /path/of/public/key`.

### For AWS provider:

SSH into any VM with `bosh ssh` providing `--gateway_identity_file, --gateway_host and --gateway_user`

```
$  bosh ssh --gateway_identity_file=~/.ssh/id_rsa_bosh  --gateway_host=AWS_IP --gateway_user=ubuntu
1. ha_proxy_z1/0
2. nats_z1/0
3. etcd_z1/0
4. postgres_z1/0
5. uaa_z1/0
6. login_z1/0
7. api_z1/0
8. hm9000_z1/0
9. runner_z1/0
10. loggregator_z1/0
11. loggregator_trafficcontroller_z1/0
12. router_z1/0
13. acceptance_tests/0
14. acceptance_tests_diego/0
15. smoke_tests/0
Choose an instance:
```
