test -x /usr/bin/salt-ssh && exit 0

# The official bootstrap script's own package selection is really
#  "which channel" (stable/git/...), not "which one binary" - it pulls
#  in salt-common/salt-minion along the way as a side effect of setting
#  up the real SaltStack apt repository, which is also what this step
#  actually needs: a place apt can find salt-ssh itself. The unused
#  minion package sitting there afterward is a harmless side effect,
#  not something this tree ever starts or points at anything.
curl -sL https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh -o /tmp/bootstrap-salt.sh
sh /tmp/bootstrap-salt.sh -X stable
apt-get install -y salt-ssh

# A keypair this guest uses to reach itself over SSH - salt-ssh has no
#  agent to talk to here, only a plain sshd on the same box it's
#  targeting (see ../roster/roster.yaml's own header comment).
install -d -m 700 -o vagrant -g vagrant /home/vagrant/.ssh

if [ ! -f /home/vagrant/.ssh/salt_ssh_id ]; then
  sudo -u vagrant ssh-keygen -t ed25519 -N '' -f /home/vagrant/.ssh/salt_ssh_id
fi

PUBKEY="$(cat /home/vagrant/.ssh/salt_ssh_id.pub)"
touch /home/vagrant/.ssh/authorized_keys
grep -qxF "$PUBKEY" /home/vagrant/.ssh/authorized_keys || echo "$PUBKEY" >> /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
