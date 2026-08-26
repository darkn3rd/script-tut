# Assembles a self-contained masterfiles tree (the standard location a
# CFEngine policy hub serves policy from) out of this repo's own hub/
# and shared_policy/ trees, then bootstraps this same guest to itself as
# both hub and agent - no second machine involved, the same self-
# targeting trick this repo already uses elsewhere for an agentless tool
# that still expects a real control/target split.
mkdir -p /var/cfengine/masterfiles/shared_policy/lessons
mkdir -p /var/cfengine/masterfiles/module-vendor/apt

cp /var/script-tut/configbox/cfengine/hub/promises.cf /var/cfengine/masterfiles/promises.cf
cp /var/script-tut/configbox/cfengine/hub/def.json    /var/cfengine/masterfiles/def.json
cp /var/script-tut/configbox/cfengine/shared_policy/default_shim.cf     /var/cfengine/masterfiles/shared_policy/
cp /var/script-tut/configbox/cfengine/shared_policy/lessons/*.cf /var/cfengine/masterfiles/shared_policy/lessons/
cp /var/script-tut/configbox/cfengine/.module-vendor/apt/*.cf    /var/cfengine/masterfiles/module-vendor/apt/

# Confirm the actual systemd unit name(s) on first provision - packaging
# has varied between a single "cfengine3" unit and separate cf-serverd/
# cf-execd units across CFEngine releases.
systemctl enable --now cfengine3 2>/dev/null || systemctl enable --now cf-serverd cf-execd

test -f /var/cfengine/policy_server.dat || cf-agent --bootstrap 127.0.0.1

# Re-run every provision (not just the first bootstrap) so an updated
# def.json/policy actually gets picked up on the next `vagrant provision`,
# not just the very first one.
cf-agent -K
