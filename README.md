# Molecule Wrapper

[![Build Status](https://travis-ci.com/gantsign/molecule-wrapper.svg?branch=master)](https://travis-ci.com/gantsign/molecule-wrapper)

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
* `which`
* [pyenv](https://github.com/pyenv/pyenv) (if not already installed)
* [virtualenv](https://virtualenv.pypa.io/en/stable)
* [Ansible](https://www.ansible.com) (inside the virtual environment)
* [Python Docker library](https://pypi.org/project/docker/) (inside the virtual environment)
* [Molecule](https://molecule.readthedocs.io) (inside the virtual environment)

If you don't have root privileges see
[using system dependencies](#using-system-dependencies).

## Usage

You can run any Molecule command directly using the wrapper e.g.:

```
./moleculew test
```

By default Molecule Wrapper runs using the latest versions of Python 2.x,
Ansible, the Python Docker library and Molecule.

You can also specify particular versions of Python, Ansible, the Python Docker
library and Molecule by passing command line arguments:

```
Additional options:
  --ansible VERSION          Use the specified version of Ansible
  --docker-lib VERSION       Use the specified version of the Python Docker
                             library
  --molecule VERSION         Use the specified version of Molecule
  --python VERSION           Use the specified version of Python
  --use-system-dependencies  Use system dependencies
```

The `VERSION` may be a valid version number, `latest` to use the latest
available version, or `default` to use the frozen version (if set) or otherwise
use the latest version (i.e. the same effect as not specifying the option).

For the Python `VERSION` the values `latest` or `latest2` will be the latest
version of Python 2.x use `latest3` for the latest version of Python 3.x.

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
* `which`

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
  --docker-lib VERSION       Use the specified version of the Python Docker
                             library
  --molecule VERSION         Use the specified version of Molecule
  --python VERSION           Use the specified version of Python
  --use-system-dependencies  Use the system version of Python
```

The `VERSION` may be a valid version number, `latest` to use the latest
available version, or `default` to use the frozen version (if set) or otherwise
display the latest version (i.e. the same effect as not specifying the option).

For the Python `VERSION` the values `latest` or `latest2` will be the latest
version of Python 2.x use `latest3` for the latest version of Python 3.x.

e.g.

```bash
./moleculew wrapper-versions
```

### wrapper-freeze

Freezes the dependency versions being used:

```
Options:
  --ansible VERSION          Use the specified version of Ansible
  --docker-lib VERSION       Use the specified version of the Python Docker
                             library
  --molecule VERSION         Use the specified version of Molecule
  --python VERSION           Use the specified version of Python
  --use-system-dependencies  Use the system version of Python
```

The `VERSION` may be a valid version number, `latest` to freeze to the latest
available version, or `default` to keep the frozen version (if set) or otherwise
freeze at the current latest version (i.e. the same effect as not specifying
the option).

For the Python `VERSION` the values `latest` or `latest2` will freeze to the
current latest version of Python 2.x use `latest3` to freeze to the current
latest version of Python 3.x.

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

### wrapper-update

Updates the Molecule Wrapper to the latest version.

e.g.

```bash
./moleculew wrapper-update
```

## License

This software is licensed under the terms in the file named "LICENSE" in the
root directory of this project. This project has dependencies that are under
different licenses.

## Author Information

John Freeman

GantSign Ltd.
Company No. 06109112 (registered in England)
