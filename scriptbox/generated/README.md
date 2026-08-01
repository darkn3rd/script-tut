# generated/

Output of `scripts/gen_installer.rb` (and `scripts/generate_install_sh.rb` in
single-file mode) lands here - one `<platform>_install.sh` per platform, built
from `config/*.yml`.

Everything in this folder except this README is gitignored and gets
regenerated on demand:

```bash
ruby ../scripts/gen_installer.rb --platform macos
```

Don't hand-edit the generated scripts; edit `config/*.yml` and regenerate.
