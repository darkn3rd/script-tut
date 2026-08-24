# Notes Describing the Provisioning Schema 
What is a good model (such as datastructure) for this:

I am defining a manifest schema for installing packages on a given operating system.

This is my structure that I have developed

The structure is this:

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
      chocolatey:
        packages: []
      debian:
        packages: []
    testbox:
      packages: []
    buildbox:
      packages: []
scripts: []
files: []
appends: []
add_apt_repos: []
common.helpers: []
debian.helpers: []
```

Under system_type, there's an implicit hierarchy, so that items will be executed in this order.

```
global.packages
global.lessons.packages
global.lessons.gen_scripts.packages
global.lessons.gen_scripts.python3.packages
```

In each leaf, item items in packages are executed in order 

If an item needs a package as a prerequisite, it can find in any tree the package, and install it.  So for example, groovy requires java.

There will be 

```
global.lessons.gen_scripts.groovy.packages
```

But because it needs java, and there's a leaf that says meets java, this will run before, but as they have implicit hierarchy, this would be the full order for groovy.

```
global.packages
global.lessons.packages
global.lessons.compiled_lang.packages
global.lessons.compiled_lang.java.packages
global.lessons.gen_scripts.packages
global.lessons.gen_scripts.groovy.packages
```

Let's also say I was installing posix, which requires perl, then this would be the order for posix. 

```
global.packages
global.lessons.packages
global.lessons.gen_scripts.packages
global.lessons.gen_scripts.perl.packages
global.lessons.shell_scripts.packages
global.lessons.shell_scripts.posix.packages
```

Combining the two, groovy + posix, we'd have 


```
global.packages
global.lessons.packages
global.lessons.compiled_lang.packages
global.lessons.compiled_lang.java.packages
global.lessons.gen_scripts.packages
global.lessons.gen_scripts.groovy.packages
global.lessons.gen_scripts.perl.packages
global.lessons.shell_scripts.packages
global.lessons.shell_scripts.posix.packages
```


Package list items can have tags.  Tags allow there to be 2+ paths to install an item that different from a default (or not included is there is no item in packages list, or no item with an explicit default tag).

So python3 for can have a tag of `pyenv` or `asdf`.  Both can install python.

As an examples

```
# asdf tag
global.packages[3] # script: ubuntu22_asdf_install
global.lessons.gen_scripts.packages[2] # asdf_plugin: python

# asdf_python tag
global.lessons.gen_scripts.packages[2] # asdf_plugin: python
global.lessons.gen_scripts.python3.packages[2] # asdf: python 3.14.7


# pyenv tag
global.lessons.gen_scripts.packages[1] # script: ubuntu22_pyenv_install
global.lessons.gen_scripts.python3.packages[1] # pyenv: 3.14.7
```

If the tag is set for `pyenv`, then all items with `pyenv` as well as untagged (which are `default`) are installed

```
global.packages
global.lessons.packages
global.lessons.gen_scripts.packages           # an item has pyenv tag
global.lessons.gen_scripts.python3.packages   # an item has pyenv tag
```

if the tag is set for `asdf_python`, then all items with that tag as well as untagged are installed. Because one of the intermediary has two tags, `asdf` and `asdf_python`, any ancestors with `asdf` will be installed. 

So these get installed 

``` 
global.packages                      # an item has asdf tag
global.lessons.packages
global.lessons.gen_scripts.packages  # an item has [asdf_python,asdf] tags
global.lessons.gen_scripts.python3   # an item has asdf_python tag
```

The global.lessons.gen_scripts.packages[2] acts as a bridge, as it is a leaf that implments the `asdf_python`, but it is a child with `asdf` and a parent with `asdf`.  Even though `asdf` was not specified, because it is an `asdf` child, it would need to have its parent in the list of things to run.

The challenge will happen if there's a needs/meets, so different leafs in two branches.  

The user selects `sdkman_groovy` adn `sdkman_java`.  

In this example, the user wants to use SDKMan! for installing Java and Groovy, so selects tags `sdkman_groovy` adn `sdkman_java`.

Groovy (`global.lessons.gen_scripts.groovy.packages`) will have the tag `sdk_groovy`, but also has a `needs: java`.  The java and it's hierarchy will have to be installed, so it will install packages in global.lessons.compiled_lang.java.packages, including ones with the tag `sdk_java`.  It's hierarhy would come before, so it will walk up the tree and install any default, and anything with `sdk_java`, which includes sdkman.  For groovy, everything in its tree will be before, so everything in its hierarchy should including, including ones with the tag `sdk_groovy`. 

So in this scenario, the order would be to install all default packages, and packages with tags of either `sdkman_java` and `sdkman_groovy`.  Java gets moved up before groovy.

```
global.packages
global.lessons.packages                     # script: ubuntu_sdkman_install with tags [sdkman_java,sdkman_groovy]
global.lessons.compiled_lang.packages
global.lessons.compiled_lang.java.packages  # items with `sdkman_java` and meets: java
global.lessons.gen_scripts.packages
global.lessons.gen_scripts.groovy.packages  # items with `sdkman_groovy` and needs java
```