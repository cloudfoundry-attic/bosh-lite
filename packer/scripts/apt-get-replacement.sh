#!/bin/bash

set -ex

mv /usr/bin/apt-get{,-orig}

cat > /usr/bin/apt-get <<BASH
#!/bin/bash
exec /var/vcap/bosh/bin/unshare -f -p -m /usr/bin/apt-get-orig "\$@"
BASH

chmod 755 /usr/bin/apt-get
chown root:root /usr/bin/apt-get

chmod +x /var/vcap/bosh/bin/unshare
