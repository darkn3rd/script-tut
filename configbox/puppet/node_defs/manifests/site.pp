# Hand-written fallback only - every real node classification lives in
#  a GENERATED manifests/nodes/<platform>.pp file instead (see ../
#  environment.conf's own manifest= glob and scriptbox/scripts/
#  generate_puppet.rb --classifier site), each with its own literal
#  `node '<platform>' { class { 'lessons': ... } ... }` block. This is
#  the "site manifest" classifier's whole tradeoff made visible: data
#  and code live in the same generated file, one node block per
#  platform, matched by certname - nothing here needs editing when
#  that data changes, but nothing here is classifier-agnostic either
#  the way ../hiera/manifests/site.pp's plain `include lessons` is.
node default {
  fail('no node definition matched this certname - see manifests/nodes/*.pp')
}
