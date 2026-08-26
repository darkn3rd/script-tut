test -x /usr/bin/salt-ssh && test -x /usr/bin/ruby && gem list -i tomlrb >/dev/null 2>&1 && exit 0

# Same salt-ssh + Python install as ../roster's own bootstrap (see its
#  own comment on the unused salt-minion package left behind) - plus
#  ruby, which this tree's own roster module needs on the PATH to
#  shell out to scriptbox/scripts/generate_salt.rb fresh on every run
#  (see ../dynamic/roster_modules/lessons_dynamic.py).
curl -sL https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh -o /tmp/bootstrap-salt.sh
sh /tmp/bootstrap-salt.sh -X stable
apt-get install -y salt-ssh ruby

# generate_salt.rb itself requires scriptbox/scripts/cmpaths.rb
#  unconditionally (see its own header comment), which needs this gem
#  present even on a run that never ends up calling cmpath() at all -
#  this roster module always passes its own explicit out_path (a temp
#  file), but the plain `require` at the top of the generator would
#  still fail before ever reaching that if the gem isn't here.
gem install tomlrb

# A keypair this guest uses to reach itself over SSH - salt-ssh has no
#  agent to talk to here, only a plain sshd on the same box it's
#  targeting (see ../dynamic/master's own header comment).
install -d -m 700 -o vagrant -g vagrant /home/vagrant/.ssh

if [ ! -f /home/vagrant/.ssh/salt_ssh_id ]; then
  sudo -u vagrant ssh-keygen -t ed25519 -N '' -f /home/vagrant/.ssh/salt_ssh_id
fi

PUBKEY="$(cat /home/vagrant/.ssh/salt_ssh_id.pub)"
touch /home/vagrant/.ssh/authorized_keys
grep -qxF "$PUBKEY" /home/vagrant/.ssh/authorized_keys || echo "$PUBKEY" >> /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
