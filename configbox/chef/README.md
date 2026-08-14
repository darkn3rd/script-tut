# Chef

## Standalone Chef: Solo, Zero, and Knife

Chef Solo and Chef Zero both run Chef cookbooks without a centralized Chef Infra Server. The key difference is how they provide Chef’s server-side features.

* **Chef Solo** executes cookbooks directly from local files.
* **Chef Zero** provides a lightweight local Chef Server API.
* **Knife Solo** and **Knife Zero** add SSH-based workflows for managing remote nodes; they are not execution engines themselves.

### Chef Solo: the legacy execution model

The original Chef Solo engine runs cookbooks directly from files on the target node. It uses configuration such as `solo.rb` to locate cookbooks, roles, and data bags.

Its main limitation is the absence of a Chef Server API and search index:

* Cookbooks must already exist on the target, either in a local directory or downloaded archive.
* Known data bag items can be loaded from local JSON files.
* Server-backed searches such as `search(:node, "role:web")` are unavailable.
* Centralized cookbook distribution, authentication, and infrastructure-wide node discovery are unavailable.

These restrictions can affect cookbooks that expect data from a **Chef Server**. They do not mean that every community cookbook will fail; only those that depend on unavailable server behavior.

Modern versions of the `chef-solo` command use Chef local mode internally. The original behavior is now referred to as legacy mode, so **Chef Solo** should be qualified when discussing current releases.

#### Knife Solo

Knife Solo was a third-party workstation plugin that automated the legacy remote workflow:

1. Connect to a node over SSH.
2. Install Chef if necessary.
3. Copy cookbooks and configuration to the node.
4. Run `chef-solo` remotely.

It reduced deployment friction but did not add a Chef Server API or infrastructure-wide search. The project is deprecated.

### Chef Zero: local mode

Chef Zero is a lightweight Chef Infra Server implementation used by Chef Infra Client’s local mode:

```sh
chef-client --local-mode
# Short form
chef-client -z
```

It runs locally for the duration of the operation and reads Chef objects from a local `chef-repo`. Because Chef Infra Client communicates with a server-compatible API, local mode supports more of the standard Chef workflow than legacy Solo:

* Chef-style search over locally available nodes, roles, environments, and data bags
* Standard repository layouts
* Local node-object persistence
* `knife` commands in local mode
* Easier movement between local development and a centralized Chef Server

Local mode is not identical to running a full production Chef Infra Server. Its search results and infrastructure awareness are limited to objects available in the local repository, and it does not provide centralized authentication, authorization, distribution, or shared state.

#### Knife Zero
Knife Zero extends Chef local mode to remote nodes over SSH. Its primary commands bootstrap new nodes and converge existing ones while using the workstation’s local Chef repository as the source of truth.

Unlike Knife Solo, it can use Chef search to select nodes and can persist selected node attributes as JSON in the repository. This makes it useful for small or transitional environments that need Chef Server-like behavior without operating a centralized server.

Knife Zero’s own documentation notes that it is not strictly a direct replacement for Knife Solo; the two tools use different workflows and data models.

### Comparison 

| Capability | Legacy Chef Solo | Chef Zero / Local Mode | Knife Solo | Knife Zero |
|---|---|---|---|---|
| **Primary role** | Local execution engine | Lightweight local Chef Server | Remote Solo workflow | Remote local-mode workflow |
| **Typical command** | `chef-solo --legacy-mode` | `chef-client -z` | `knife solo cook HOST` | `knife zero converge QUERY` |
| **Chef Server-compatible API** | No | Yes, locally | No | Yes, from the workstation |
| **Search support** | No native search | Searches local repository data | No native search | Searches locally managed data |
| **Data bags** | Local JSON and encrypted items; direct lookup but no native search | Repository-backed JSON and encrypted items; direct lookup plus search of indexable data | Copies or stages local data-bag files on the node | Makes repository data bags available through local mode |
| **Roles** | Loaded directly from local role files | Repository-backed objects available through the local Chef API | Copies or stages role files on the node | Makes repository roles available through local mode |
| **Environments** | Loaded directly from local environment files | Repository-backed objects available through the local Chef API | Copies or stages environment files on the node | Makes repository environments available through local mode |
### Practical guidance

For new standalone Chef workflows, use `chef-client -z` rather than designing around legacy **Chef Solo**. 

Use Knife Zero when you need an SSH-based, repository-backed workflow for managing remote nodes without a centralized Chef Infra Server.

For an existing Knife Solo installation, treat migration as a workflow change rather than a simple command-for-command replacement.

# Further Reading and References

* Progress Chef Documenation
  * [chef-solo](https://docs.chef.io/client/18/features/chef_solo/)
    * [solo.rb](https://docs.chef.io/client/19/features/chef_solo/config_rb_solo/)
  * [Chef Infra Client (executable)](https://docs.chef.io/client/18/reference/ctl_chef_client/)
  * [About Data Bags](https://docs.chef.io/client/19/policy/data_bags/)
  * [About Policy](https://docs.chef.io/client/19/policy/)
  * [About Environments](https://docs.chef.io/client/19/policy/environments/)
  * [About Roles](https://docs.chef.io/client/19/policy/roles/)
* [Knife Zero](https://knife-zero.github.io/)