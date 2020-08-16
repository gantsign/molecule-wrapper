__moleculew_commands() {
    local -a commands=(
        'check:Use the provisioner to perform a Dry-Run...'
        'converge:Use the provisioner to configure instances...'
        'create:Use the provisioner to start the instances.'
        'dependency:Manage the roles dependencies.'
        'destroy:Use the provisioner to destroy the instances.'
        'idempotence:Use the provisioner to configure the...'
        'init:Initialize a new role or scenario.'
        'lint:Lint the role.'
        'list:Lists status of instances.'
        'login:Log in to one instance.'
        'matrix:List matrix of steps used to test instances.'
        'prepare:Use the provisioner to prepare the instances...'
        'side-effect:Use the provisioner to perform side-effects...'
        'syntax:Use the provisioner to syntax check the role.'
        'test:Test (lint, destroy, dependency, syntax,...'
        'verify:Run automated tests against instances.'
    )

    if [[ -f ./moleculew ]]; then
        commands+=(
            'wrapper-clean:remove all the wrapper virtual environments.'
            'wrapper-freeze:freeze the dependency versions.'
            'wrapper-install:install Molecule.'
            'wrapper-unfreeze:un-freeze the dependency versions.'
            'wrapper-update:update Molecule Wrapper to the latest version.'
            'wrapper-upgrade-versions:upgrade dependency versions and freeze them.'
            'wrapper-version:display the current version of the wrapper script.'
            'wrapper-versions:display the current dependency versions being used.'
            'wrapper-virtualenv:display the location of the Virtualenv environment.'
        )
    fi

    _describe -t moleculew-commands "moleculew command" commands
}

__moleculew_init_commands() {
    local init_cmds=(
        'role:Initialize a new role for use with Molecule.'
        'scenario:Initialize a new scenario for use with...'
        'template:Initialize a new role from a Cookiecutter...'
    )

    _describe -t init_cmds "init cmd" init_cmds
}

__moleculew_init_subcommand() {
    local dep_name_arg driver_name_arg provisioner_name_arg role_name_arg verifier_name
    integer ret=1

    dep_name_arg='--dependency-name[Name of dependency to initialize. (galaxy)]:dependency:()'
    driver_name_arg=({-d,--driver-name}'[Name of driver to initialize. (docker)]:driver:(azure delegated docker ec2 gce lxc lxd openstack vagrant)')
    provisioner_name_arg='--provisioner-name[Name of provisioner to initialize. (ansible)]:provisioner:()'
    role_name_arg=({-r,--role-name}'[Name of the role to create. \[required\]]:role:()')
    verifier_name='--verifier-name[Name of verifier to initialize. (testinfra)]:verifier:(goss inspec testinfra)'

    case "$words[1]" in

        (role)
            _arguments \
                $dep_name_arg \
                $driver_name_arg \
                '--lint-name[Name of lint to initialize. (yamllint)]:lint:()' \
                $provisioner_name_arg \
                $role_name_arg \
                $verifier_name \
                $help_arg && ret=0
            ;;

        (scenario)
            _arguments \
                $dep_name_arg \
                $driver_name_arg \
                '--lint-name[Name of lint to initialize. (ansible-lint)]:lint:()' \
                $provisioner_name_arg \
                $role_name_arg \
                {-s,--scenario-name}'[Name of the scenario to create. (default) \[required\]]:role name:()' \
                $verifier_name \
                $help_arg && ret=0
            ;;

        (template)
            _arguments \
                '--url[URL to the Cookiecutter templates repository. \[required\]]:url:()' \
                '--no-input[Do not prompt for parameters and only use cookiecutter.json for content.]' \
                {-r,--role-name}'Name of the role to create.' \
                $help_arg && ret=0
            ;;

        (*)
            _message 'Unknown init sub command' && ret=1
            ;;
    esac

    return ret
}

__moleculew_scenario_options() {
    if [[ -f ./moleculew ]]; then
        compadd -V scenario -- $(./moleculew wrapper-options-scenario)
    fi
}

__moleculew_subcommand() {
    local scenario_arg help_arg driver_arg host_arg

    scenario_arg=("($I --all)"{-s,--scenario-name}'[Name of the scenario to target. (default)]:scenario_names:__moleculew_scenario_options')
    help_arg='(- :)--help[Display help and exit.]'
    driver_arg=("($I)"{-d,--driver-name}'[Name of driver to use. (docker)]:driver:(azure delegated docker ec2 gce lxc lxd openstack vagrant)')
    host_arg=("($I)"{-h,--host}'[Host to access.]:host:()')

    integer ret=1

    case "$words[1]" in
        (check|converge|dependency|idempotence|lint|matrix|syntax|verify)
            _arguments \
                $help_arg \
                $scenario_arg && ret=0
            ;;

        (create)
            _arguments \
                $driver_arg \
                $help_arg \
                $scenario_arg && ret=0
            ;;

        (destroy)
            _arguments \
                "($I -s --scenario-name)--all[Destroy all scenarios.]" \
                $driver_arg \
                $help_arg \
                $scenario_arg && ret=0
            ;;

        (init)
            _arguments -C \
                $help_arg \
                '(-): :->init-command' \
                '(-)*:: :->init-option-or-argument' && ret=0

            case $state in
                (init-command)
                    __moleculew_init_commands && ret=0
                    ;;
                (init-option-or-argument)
                    curcontext=${curcontext%:*:*}:moleculew-init-$words[2]:
                    __moleculew_init_subcommand && ret=0
                    ;;
            esac
            ;;

        (login)
            _arguments \
                $help_arg \
                $host_arg \
                $scenario_arg && ret=0
            ;;

        (list)
            _arguments \
                "($I)"{-f,--format}'[Change output format. (simple)]:format:(simple plain yaml)' \
                $help_arg \
                $scenario_arg && ret=0
            ;;

        (prepare)
            _arguments \
                "($I)--force[Enable force mode.]" \
                $driver_arg \
                $help_arg \
                $scenario_arg && ret=0
            ;;

        (test)
            _arguments \
                "($I -s --scenario-name)--all[Test all scenarios.]" \
                "($I)--destroy[The destroy strategy used at the conclusion of a Molecule run (always).]:destroy:(always never)" \
                $driver_arg \
                $help_arg \
                $scenario_arg && ret=0
            ;;

        (wrapper-freeze|wrapper-install|wrapper-upgrade|wrapper-versions|wrapper-virtualenv)
            _arguments $wrapper_args && ret=0
            ;;

        (*)
            _message 'Unknown sub command' && ret=1
            ;;
    esac

    return ret
}

__moleculew_ansible_options() {
    compadd -V version -- $(./moleculew wrapper-options-ansible)
}

__moleculew_docker_lib_options() {
    compadd -V version -- $(./moleculew wrapper-options-docker-lib)
}

__moleculew_molecule_options() {
    compadd -V version -- $(./moleculew wrapper-options-molecule)
}

__moleculew_python_options() {
    compadd -V version -- $(./moleculew wrapper-options-python)
}

__moleculew_yamllint_options() {
    compadd -V version -- $(./moleculew wrapper-options-yamllint)
}

__moleculew_ansible_lint_options() {
    compadd -V version -- $(./moleculew wrapper-options-ansible-lint)
}

__moleculew_flake8_options() {
    compadd -V version -- $(./moleculew wrapper-options-flake8)
}

__moleculew_testinfra_options() {
    compadd -V version -- $(./moleculew wrapper-options-testinfra)
}

_moleculew() {
    if [[ ! -f ./moleculew ]] && [[ ! $commands[molecule] ]]; then
        _message -r 'moleculew not found' && return 1
    fi

    local context state state_descr line
    typeset -A opt_args
    integer ret=1

    local I wrapper_args arguments

    I='--help --version'

    wrapper_args=(
        "($I)--ansible[The version of Ansible to use.]:ansible_versions:__moleculew_ansible_options"
        "($I)--docker-lib[The version of the Python Docker library to use.]:docker_lib_versions:__moleculew_docker_lib_options"
        "($I)--molecule[The version of Molecule to use.]:molecule_versions:__moleculew_molecule_options"
        "($I)--yamllint[The version of YamlLint to use.]:yamllint_versions:__moleculew_yamllint_options"
        "($I)--ansible-lint[The version of Ansible Lint to use.]:ansible_lint_versions:__moleculew_ansible_lint_options"
        "($I)--flake8[The version of Flake8 to use.]:flake8_versions:__moleculew_flake8_options"
        "($I)--testinfra[The version of Testinfra to use.]:testinfra_versions:__moleculew_testinfra_options"
        "($I --use-system-dependencies)--python[The version of Python to use.]:python_versions:__moleculew_python_options"
        "($I --python)--use-system-dependencies[Use system dependencies.]"
    )

    arguments=(
        "($I)"{-c,--base-config}'[Path to a base config. If provided Molecule will load this config first, and deep merge each scenarios molecule.yml on top. (/home/vagrant/.config/molecule/config.yml)]:base config:_files'
        "($I)--debug[Enable debug mode.]"
        "($I)"{-e,--env-file}'[The file to read variables from when rendering molecule.yml. (.env.yml)]:env file:_files'
        '(- :)--help[Display help for the Molecule Wrapper and exit.]'
        '(- :)--version[Show the version and exit.]'
        '(-): :->command'
        '(-)*:: :->option-or-argument'
    )

    if [[ -f ./moleculew ]]; then
        arguments+=($wrapper_args)
    fi

    _arguments -C $arguments && ret=0


    case $state in
        (command)
            __moleculew_commands && ret=0
        ;;
        (option-or-argument)
            curcontext=${curcontext%:*:*}:moleculew-$words[1]:
            __moleculew_subcommand && ret=0
        ;;
    esac

    return ret
}

_molecule_or_moleculew() {
    if [[ -f ./moleculew ]] ; then
        ./moleculew "$@"
    else
        moleculew "$@"
    fi
}

compdef _moleculew _molecule_or_moleculew

alias molecule=_molecule_or_moleculew
