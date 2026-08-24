# Notes Describing the Provisioning Schema

This describes the resolution model actually implemented in
`scriptbox/scripts/resolve_order.rb` - `resolve_included` (inclusion) and
`topological_order` (ordering). It replaced an earlier, informal draft of
this same document (see "Why not tag co-occurrence" below for the one place
the original draft's own worked example turned out to describe an unsafe
mechanism) and an earlier multi-pass pipeline (`select_by_tags` + `resolve!`
+ `select_sections`, each re-deriving fragments of the others) that produced
several real bugs before being replaced.

## The manifest shape

```yaml
system_type:
  global:
    packages: []
    lessons:
      packages: []
      gen_scripts:
        packages: []
        python3:
          packages: []
      shell_scripts:
        packages: []
      win_scripts:
        packages: []
      compiled_lang:
        packages: []
    scriptbox:
      packages: []
    cibox:
      packages: []
    pkgbox:
      packages: []
    testbox:
      packages: []
    buildbox:
      packages: []
scripts: []
files: []
appends: []
add_apt_repos: []
```

`flatten()` walks this tree in document order and produces one flat array of
"steps" - a step is a package entry, or a `script:`/`file:`/`append:` key
attached to one (see `ATTACHABLE_KEYS`), carrying its own dotted `path:`
(e.g. `"global.lessons.gen_scripts.python3"`).

There are exactly three relationships between steps, computed and applied
together by `resolve_included`/`topological_order` rather than as separate
sequential passes:

1. **Hierarchy** - structural, no manifest annotation needed.
2. **Tag-activation** - from `tags:`, decides which of several alternatives
   for the same thing get included.
3. **needs:/meets:** - real, directed dependency, independent of tags or
   hierarchy.

## 1. Hierarchy

An ancestor path's own packages run before any descendant's. `flatten()`'s
pre-order walk already guarantees this for free - an ancestor's natural
array index is always lower than any of its descendants' - so ordering
needs no special handling for it at all (see `topological_order`'s own
comment). Inclusion is the part that needs an explicit step:
`expand_hierarchy` pulls every tag-eligible step declared at a strict-prefix
ancestor path back into the included set, unconditionally, regardless of
whether a SECTION selector or tag selection would otherwise have narrowed it
out. This is a real behavior, not just a document-order coincidence - a step
sitting at `global.lessons.gen_scripts` runs before *everything* under
`global.lessons.gen_scripts.*`, with no `needs:`/`meets:` link required
at all.

For example, `global.lessons.gen_scripts.python3.packages` runs after every
strict-prefix ancestor's own packages, unconditionally:

```
global.packages
global.lessons.packages
global.lessons.gen_scripts.packages
global.lessons.gen_scripts.python3.packages
```

If an item needs a package as a prerequisite, that's a *different*
relationship (see needs:/meets: below), found anywhere in the tree, not just
an ancestor. `groovy` needs `java`, which lives under a sibling branch
(`compiled_lang`, not an ancestor of `gen_scripts`):

```
global.packages
global.lessons.packages
global.lessons.compiled_lang.packages
global.lessons.compiled_lang.java.packages   # provides "java"
global.lessons.gen_scripts.packages
global.lessons.gen_scripts.groovy.packages   # needs: java
```

Combining two such needs:/meets: pulls (groovy needing java, posix needing
perl) is exactly what `topological_order`'s DFS produces - each provider's
whole unit pulled up to sit just before its earliest consumer, hierarchy
among the rest unaffected:

```
global.packages
global.lessons.packages
global.lessons.compiled_lang.packages
global.lessons.compiled_lang.java.packages
global.lessons.gen_scripts.packages
global.lessons.gen_scripts.perl.packages
global.lessons.gen_scripts.groovy.packages
global.lessons.shell_scripts.packages
global.lessons.shell_scripts.posix.packages
```

## 2. Tag-activation

Package list items can have `tags:`. Tags let a manifest express more than
one legitimate way to install the same thing (e.g. python3 via `pyenv` or
`asdf`) without installing every alternative at once (see `tag_eligible?`'s
own "issue #16" comment). An untagged step is always included, regardless of
selection - it's a baseline, not one of the alternatives. A tagged step is
included if `--select` names one of its own tags, or if it carries the
literal tag `default` and nothing else in its *own* `path:` group was
selected (`compute_default_wins`/`compute_enabled_tags` - see below on why
this is scoped per group, not global).

### Group-scoped `default`, not a global switch

`default` resolves independently per containing `packages:` array
(`step[:path]`), not manifest-wide. A real regression this fixed: `--select
rvm` (ruby's own group) was silently shutting off groovy's entirely
unrelated sdkman default, under an earlier design that gated every
`default` tag on whether *anything at all* was selected, globally, rather
than whether something in that *same* group competed with it.

### Why not tag co-occurrence ("the bridge")

An earlier draft of this document proposed a different mechanism for
letting an ancestor-level bootstrap step get pulled in purely through tag
membership: two tags co-occurring on the same step would be "connected" in
a symmetric graph, and activating one would propagate to everything
connected to it. Its own worked example was exactly the case that turned
out to be unsafe: SDKMAN's bootstrap step tagged `[sdkman_groovy,
sdkman_java]` (two independent language selectors on one step). Under a
co-occurrence graph, selecting `sdkman_groovy` alone would propagate through
that step to `sdkman_java` too - silently activating Java's SDKMAN path
even though only Groovy was ever asked for. Confirmed directly this isn't
hypothetical: this is precisely the shape the real manifest used to have.

The actual fix wasn't a smarter propagation rule - it was recognizing that
"the bootstrap must run before this language's install" is a needs:/meets:
relationship, not a tag relationship. The manifest now gives the SDKMAN
bootstrap `meets: sdkman`, `tags: [sdkman]` (dropping the per-language tags
entirely), and each language step that uses it declares `needs: sdkman`
explicitly - the same explicit-dependency mechanism `groovy`'s own `needs:
java` always used. `resolve_included`'s tag-activation stays exactly the
group-scoped `default` rule above; general tag co-occurrence propagation
was deliberately not built, since every real cross-branch "reach" this
document's original draft cited (asdf's own plugin-add steps, sdkman's
bootstrap) is now expressed as an explicit `needs:`/`meets:` edge instead,
with nothing left in the manifest that actually needs it.

## 3. needs:/meets:

A step's `needs:` (one name or a list) is satisfied by whichever other
step's `meets:` matches, by capability name (see `parse_need`/`parse_meets`
- an optional version floor like `needs: ruby >= 3.2` is checked separately,
after resolution, by `check_version_needs!`). This is real, directed
dependency, independent of both hierarchy and tags:

- **Inclusion**: if a step this run already wants `needs:` a capability no
  tag-eligible or hierarchy-included step yet provides, `resolve_included`
  pulls in the first-listed provider (`.find`, not `.select` - installing
  every step that happens to share a `meets:` value would double-install
  real alternatives, "issue #16" again) - along with that provider's own
  `unit_span` (its attached `script:`/`file:`/`append:` steps - a provider
  reached purely through `needs:` still needs its own shell-integration
  lines, not just its bare install command) and its own `natural_prefix`
  (local siblings implied by document order alone, with no `needs:`/`meets:`
  of their own). A step whose `needs:` still resolves to no provider at all
  once this settles is dropped (not emitted as a command guaranteed to
  fail), reported as an omission.
- **Ordering**: `topological_order` is a real topological sort (DFS-based)
  over these edges - a provider unit always ends up before every consumer
  of it, pulled up to sit just before its *earliest* consumer, with a real
  cycle raising a clear, named error instead of looping forever.

## Function reference

- `expand_hierarchy` - relationship 1.
- `tag_eligible?` / `compute_default_wins` / `compute_enabled_tags` -
  relationship 2.
- `resolve_included`'s own needs:/meets: pull-in loop, and
  `topological_order` - relationship 3, for inclusion and ordering
  respectively.
- `resolve_included(steps, select_tags, exclude_tags, selectors: [])` -
  the single inclusion entry point combining all three (an optional
  `selectors:` list of SECTION path prefixes also seeds the initial
  included set by path match, unifying what used to be a separate,
  duplicate pass).
- `relocate_cross_cutting` - a separate, later, code-generation-only
  concern (which providers become their own generated bash/PowerShell
  function, and where a call to one gets inserted) - not part of this
  resolution model; it consumes `topological_order`'s already-resolved
  output.
