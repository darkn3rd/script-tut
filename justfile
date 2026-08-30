# Human-facing entry points for resolved provisioning plans. The generated
# files remain disposable compiler output under scriptbox/generated/.

[unix]
set shell := ["bash", "-uc"]

[windows]
set shell := ["powershell.exe", "-NoLogo", "-Command"]

generate-ubuntu *args:
    ruby scriptbox/scripts/generate_justfile.rb scriptbox/config/ubuntu2204.yml --output scriptbox/generated/ubuntu2204.just {{args}}

install-ubuntu:
    just --justfile scriptbox/generated/ubuntu2204.just install

generate-macos *args:
    ruby scriptbox/scripts/generate_justfile.rb scriptbox/config/macos.yml --output scriptbox/generated/macos.just {{args}}

install-macos:
    just --justfile scriptbox/generated/macos.just install

generate-windows *args:
    ruby scriptbox/scripts/generate_justfile.rb scriptbox/config/windows.yml --output scriptbox/generated/windows.just {{args}}

install-windows:
    just --justfile scriptbox/generated/windows.just install

generate-msys2 *args:
    ruby scriptbox/scripts/generate_justfile.rb scriptbox/config/msys2.yml --output scriptbox/generated/msys2.just {{args}}

install-msys2:
    just --justfile scriptbox/generated/msys2.just install

generate-cygwin *args:
    ruby scriptbox/scripts/generate_justfile.rb scriptbox/config/cygwin.yml --output scriptbox/generated/cygwin.just {{args}}

install-cygwin:
    just --justfile scriptbox/generated/cygwin.just install
