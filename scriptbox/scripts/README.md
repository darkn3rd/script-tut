# Scripts Notes

These are some notes on using these scripts.

## generate_install_script.rb

This script generates an install script: GNU Bash (`.sh`) for POSIX environments and powershell (`.ps1`) for Windows.  The scripts will vary depending on the options selected. 

### Ubuntu 22.04

These are some combinations you would try below:

* **A. Baseline (no flags)** — system ruby/python only, `groovy` via sdkman default:
  ```bash
  ./generate_install_script.rb config/ubuntu2204.yml \
    "lessons.gen_scripts.{ruby,python2,python3,groovy}"
  ```
* **B. Traditional bundle** — `rbenv` + `pyenv` (covers python2 too, same tag) + `sdkman groovy`, explicit:
  ```bash
  ./generate_install_script.rb config/ubuntu2204.yml \
    "lessons.gen_scripts.{ruby,python2,python3,groovy}" \
    --select rbenv,pyenv,sdkman_groovy
  ```
* **C. Full asdf** — verified this pulls in the asdf bootstrap + all three plugins/installs:
  ```bash
  ./generate_install_script.rb config/ubuntu2204.yml \
    "lessons.gen_scripts.{ruby,python2,python3,groovy}" \
    --select asdf,asdf_ruby,asdf_python,asdf_groovy
  ```
* **D. Mixed per-language **— `rbenv` for ruby, `asdf` for python, `sdkman` for groovy:
  ```bash
  ./generate_install_script.rb config/ubuntu2204.yml \
    "lessons.gen_scripts.{ruby,python2,python3,groovy}" \
    --select rbenv,asdf_python,sdkman_groovy
  ```
* E. **Exclude/omission sanity check** — `asdf` minus groovy, so groovy has no active path at all (confirms --exclude vetoes and the omission comment fires cleanly instead of emitting a broken command):
  ```bash
  ./generate_install_script.rb config/ubuntu2204.yml \
    "lessons.gen_scripts.{ruby,python2,python3,groovy}" \
    --select asdf,asdf_ruby,asdf_python,asdf_groovy \
    --exclude asdf_groovy
  ```

When you are read to test one of these combinations:

```bash
REPO=$(realpath ../..)
pushd $REPO/configbox/bubblegum/hosts/virtualbox/ubuntu22
vagrant up --no-provision # launch vm
vagrant provision         # test script
popd
```




