test -x /usr/bin/salt-call && exit 0

curl -sL https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh -o /tmp/bootstrap-salt.sh
sh /tmp/bootstrap-salt.sh -X stable
