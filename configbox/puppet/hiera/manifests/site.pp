# Hand-written - the hiera classifier's whole point is that this file
#  never changes when the manifest/generated data changes. `include`,
#  not `class { 'lessons': ... }` - only a plain `include`-style
#  declaration uses Puppet's automatic class-parameter hiera lookup;
#  a resource-like class{} declaration would skip it for any parameter
#  passed explicitly, which is exactly the coupling this classifier
#  exists to avoid. Every parameter (platform/common_steps/steps/user/
#  area gates) comes from ../hiera.yaml's own hierarchy instead - see
#  ../data/common.yaml (hand-written knobs) and ../data/lessons/
#  ubuntu22.yaml (generated).
node default {
  include lessons
}
