# Molecule Wrapper

[![Lint](https://github.com/gantsign/molecule-wrapper/actions/workflows/ci.yml/badge.svg)](https://github.com/gantsign/molecule-wrapper/actions/workflows/ci.yml)

A wrapper script (in the spirit of the
[Grade Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html))
to make installing/running
[Molecule](https://molecule.readthedocs.io/en/latest/configuration.html) easier.

Note: this script currently only works on Linux.

## Installation

In the root of your Ansible role run the following to install the wrapper:

```bash
wget 'https://raw.githubusercontent.com/gantsign/molecule-wrapper/master/moleculew' -O moleculew \
    && chmod 'u+x' moleculew
```

### Tab completion and alias for Zsh

To enable tab-completion support and add an alias so you can run the wrapper
using `molecule` follow [these instructions](zsh/README.md).

## Caution

Molecule has a lot of dependencies, some of which you'll need root privileges to
install.

When you run the molecule wrapper for the first time it will attempt to install
the following:

* [Python build dependencies](https://github.com/pyenv/pyenv/wiki/common-build-problems)
* [Python](https://www.python.org/)
* [Docker](https://www.docker.com) (if not already installed)
* [Git](https://git-scm.com)
* [curl](https://curl.haxx.se)
* [jq](https://stedolan.github.io/jq/)
* [pyenv](https://github.com/pyenv/pyenv) (if not already installed)
* [virtualenv](https://virtualenv.pypa.io/en/stable)
* [Ansible](https://www.ansible.com) (inside the virtual environment)
* [Molecule](https://molecule.readthedocs.io) (inside the virtual environment)

If you don't have root privileges see
[using system dependencies](#using-system-dependencies).

## Usage

You can run any Molecule command directly using the wrapper e.g.:

```
./moleculew test
```

By default Molecule Wrapper runs using the latest versions of Python,
Ansible, Molecule, YamlLint, Ansible Lint, Flake8 and Testinfra.

You can also specify particular versions by passing command line arguments or
setting environment variables:

```
Additional options:
  --ansible VERSION          Use the specified version of Ansible
  --molecule VERSION         Use the specified version of Molecule
  --python VERSION           Use the specified version of Python
  --yamllint VERSION         Use the specified version of YamlLint
  --ansible-lint VERSION     Use the specified version of Ansible Lint
  --flake8 VERSION           Use the specified version of Flake8
  --testinfra VERSION        Use the specified version of Testinfra
  --use-system-dependencies  Use system dependencies

Environment variables:
  MOLECULEW_ANSIBLE       Use the specified version of Ansible
  MOLECULEW_MOLECULE      Use the specified version of Molecule
  MOLECULEW_PYTHON        Use the specified version of Python
  MOLECULEW_YAMLLINT      Use the specified version of YamlLint
  MOLECULEW_ANSIBLE_LINT  Use the specified version of Ansible Lint
  MOLECULEW_FLAKE8        Use the specified version of Flake8
  MOLECULEW_TESTINFA      Use the specified version of Testinfra
  MOLECULEW_USE_SYSTEM    Use system dependencies (true/false)
```

The version may be a valid version number, `latest` to use the latest
available version, or `default` to use the frozen version (if set) or otherwise
use the latest version (i.e. the same effect as not specifying the option).

The above command line arguments take preference over environment variables.

e.g.

```
./moleculew --python 3.6.6 test
```

### Freezing versions

You can freeze the dependency versions by running the following command:

```
./moleculew wrapper-freeze
```

You can also specify versions when freezing the dependencies:

```
./moleculew --python 3.6.6 wrapper-freeze
```

Note: any version you specify as a command line argument when running Molecule
will override the frozen version of that dependency.

### Using system dependencies

If you don't have root privileges but you already have the necessary
dependencies installed you can uses those dependencies by specifying
`--use-system-dependencies`:

e.g.

```
./moleculew --use-system-dependencies test
```

Required dependencies:
* [Python build dependencies](https://github.com/pyenv/pyenv/wiki/common-build-problems) (to build Molecule and its dependencies)
* [Python](https://www.python.org/) including [pip](https://pypi.org/project/pip/)
* [Docker](https://www.docker.com)
* [Git](https://git-scm.com)
* [curl](https://curl.haxx.se)
* [jq](https://stedolan.github.io/jq/)

The remaining dependencies don't require root privileges and will be installed
if necessary.

This can also be useful for CI builds where you want to save time by using
existing binaries.

## Command line reference

### wrapper-versions

Displays the current dependency versions being used:

```
Options:
  --ansible VERSION          Use the specified version of Ansible
  --molecule VERSION         Use the specified version of Molecule
  --python VERSION           Use the specified version of Python
  --yamllint VERSION         Use the specified version of YamlLint
  --ansible-lint VERSION     Use the specified version of Ansible Lint
  --flake8 VERSION           Use the specified version of Flake8
  --testinfra VERSION        Use the specified version of Testinfra
  --use-system-dependencies  Use the system version of Python

Environment variables:
  MOLECULEW_ANSIBLE       Use the specified version of Ansible
  MOLECULEW_MOLECULE      Use the specified version of Molecule
  MOLECULEW_PYTHON        Use the specified version of Python
  MOLECULEW_YAMLLINT      Use the specified version of YamlLint
  MOLECULEW_ANSIBLE_LINT  Use the specified version of Ansible Lint
  MOLECULEW_FLAKE8        Use the specified version of Flake8
  MOLECULEW_TESTINFA      Use the specified version of Testinfra
  MOLECULEW_USE_SYSTEM    Use system dependencies (true/false)
```

The version may be a valid version number, `latest` to use the latest
available version, or `default` to use the frozen version (if set) or otherwise
display the latest version (i.e. the same effect as not specifying the option).

The above command line arguments take preference over environment variables.

e.g.

```bash
./moleculew wrapper-versions
```

### wrapper-freeze

Freezes the dependency versions being used:

```
Options:
  --ansible VERSION          Use the specified version of Ansible
  --molecule VERSION         Use the specified version of Molecule
  --python VERSION           Use the specified version of Python
  --yamllint VERSION         Use the specified version of YamlLint
  --ansible-lint VERSION     Use the specified version of Ansible Lint
  --flake8 VERSION           Use the specified version of Flake8
  --testinfra VERSION        Use the specified version of Testinfra
  --use-system-dependencies  Use the system version of Python

Environment variables:
  MOLECULEW_ANSIBLE       Use the specified version of Ansible
  MOLECULEW_MOLECULE      Use the specified version of Molecule
  MOLECULEW_PYTHON        Use the specified version of Python
  MOLECULEW_YAMLLINT      Use the specified version of YamlLint
  MOLECULEW_ANSIBLE_LINT  Use the specified version of Ansible Lint
  MOLECULEW_FLAKE8        Use the specified version of Flake8
  MOLECULEW_TESTINFA      Use the specified version of Testinfra
  MOLECULEW_USE_SYSTEM    Use system dependencies (true/false)
```

The version may be a valid version number, `latest` to freeze to the latest
available version, or `default` to keep the frozen version (if set) or otherwise
freeze at the current latest version (i.e. the same effect as not specifying
the option).

The above command line arguments take preference over environment variables.

e.g.

```bash
./moleculew wrapper-freeze
```

To upgrade one (or more) of the versions specify the options as follows:

```bash
./moleculew --ansible latest --molecule 2.16.0 wrapper-freeze
```

### wrapper-unfreeze

Un-freezes the dependency versions:

e.g.

```bash
./moleculew wrapper-unfreeze
```

### wrapper-upgrade-versions

Upgrades any frozen dependency versions to the latest version and freezes all
dependency versions:

e.g.

```bash
./moleculew wrapper-upgrade-versions
```

### wrapper-clean

Removes all the virtual environments created by Molecule Wrapper. The virtual
environments can use up quite a bit of storage over time so you should run this
periodically e.g. every few months.

e.g.

```bash
./moleculew wrapper-clean
```

### wrapper-version

Displays the current version of the wrapper script.

e.g.

```bash
./moleculew wrapper-version
```

### wrapper-upgrade

Upgrades the Molecule Wrapper to the latest version.

e.g.

```bash
./moleculew wrapper-upgrade
```

### wrapper-install

Installs Molecule (if necessary). You don't need to use this because the other
commands will run the install if they need to. This is included for CI
environments where you might want to separate the console output for the install
from the Molecule output.

```
Options:
  --ansible VERSION          Use the specified version of Ansible
  --molecule VERSION         Use the specified version of Molecule
  --python VERSION           Use the specified version of Python
  --yamllint VERSION         Use the specified version of YamlLint
  --ansible-lint VERSION     Use the specified version of Ansible Lint
  --flake8 VERSION           Use the specified version of Flake8
  --testinfra VERSION        Use the specified version of Testinfra
  --use-system-dependencies  Use the system version of Python

Environment variables:
  MOLECULEW_ANSIBLE       Use the specified version of Ansible
  MOLECULEW_MOLECULE      Use the specified version of Molecule
  MOLECULEW_PYTHON        Use the specified version of Python
  MOLECULEW_YAMLLINT      Use the specified version of YamlLint
  MOLECULEW_ANSIBLE_LINT  Use the specified version of Ansible Lint
  MOLECULEW_FLAKE8        Use the specified version of Flake8
  MOLECULEW_TESTINFA      Use the specified version of Testinfra
  MOLECULEW_USE_SYSTEM    Use system dependencies (true/false)
```

The version may be a valid version number, `latest` to freeze to the latest
available version, or `default` to keep the frozen version (if set) or otherwise
freeze at the current latest version (i.e. the same effect as not specifying
the option).

The above command line arguments take preference over environment variables.

e.g.

```bash
./moleculew wrapper-install
```

### wrapper-virtualenv

Displays the location of the Virtualenv environment.

```
Options:
  --ansible VERSION          Use the specified version of Ansible
  --molecule VERSION         Use the specified version of Molecule
  --python VERSION           Use the specified version of Python
  --yamllint VERSION         Use the specified version of YamlLint
  --ansible-lint VERSION     Use the specified version of Ansible Lint
  --flake8 VERSION           Use the specified version of Flake8
  --testinfra VERSION        Use the specified version of Testinfra
  --use-system-dependencies  Use the system version of Python

Environment variables:
  MOLECULEW_ANSIBLE       Use the specified version of Ansible
  MOLECULEW_MOLECULE      Use the specified version of Molecule
  MOLECULEW_PYTHON        Use the specified version of Python
  MOLECULEW_YAMLLINT      Use the specified version of YamlLint
  MOLECULEW_ANSIBLE_LINT  Use the specified version of Ansible Lint
  MOLECULEW_FLAKE8        Use the specified version of Flake8
  MOLECULEW_TESTINFA      Use the specified version of Testinfra
  MOLECULEW_USE_SYSTEM    Use system dependencies (true/false)
```

The version may be a valid version number, `latest` to freeze to the latest
available version, or `default` to keep the frozen version (if set) or otherwise
freeze at the current latest version (i.e. the same effect as not specifying
the option).

The above command line arguments take preference over environment variables.

e.g.

```bash
./moleculew wrapper-virtualenv
```

## License

This software is licensed under the terms in the file named "LICENSE" in the
root directory of this project. This project has dependencies that are under
different licenses.

## Author Information

John Freeman

GantSign Ltd.
Company No. 06109112 (registered in England)
