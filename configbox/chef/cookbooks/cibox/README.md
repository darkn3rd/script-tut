# cibox

Placeholder cookbook - `recipes/default.rb` has no tasks yet, and it isn't
in any run list under `../../systems/`. Reserved for provisioning CI
tooling (`nektos/act`, per the top-level [cibox/README.md](../../../../cibox/README.md)
area) for the Chef side.

The Ansible equivalent, `configbox/ansible/provision/roles/cibox`, already
implements this (installs `act` via the vendored `diodonfrost.act` Galaxy
role and verifies it runs) - use that as the reference when filling this
cookbook in.

## License

MPL-2.0
