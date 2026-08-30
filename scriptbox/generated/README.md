# generated/

Output of `scripts/gen_installer.rb`, `scripts/generate_install_script.rb`, and
`scripts/generate_justfile.rb` lands here. Outputs include standalone install
scripts and resolved `<platform>.just` execution plans built from
`config/*.yml`.

Everything in this folder except this README is gitignored and gets
regenerated on demand:

```bash
ruby ../scripts/gen_installer.rb --platform macos
```

Don't hand-edit the generated scripts; edit `config/*.yml` and regenerate.
