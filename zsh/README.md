# Zsh Support

Add tab completion for Molecule Wrapper and alias `./moleculew` so you can
run it using `molecule`.

# Installing with [Antigen](https://github.com/zsh-users/antigen)

```bash
antigen bundle gantsign/molecule-wrapper zsh
```

# Installing with [Ansible Role](https://galaxy.ansible.com/gantsign/antigen)

Add the following to your Ansible playbook:

```yaml
- role: gantsign.antigen
  users:
    - username: example_username
      antigen_bundles:
        - name: moleculew
          url: gantsign/molecule-wrapper
          location: zsh
```

Note: replace `example_username` with the username to install this plugin for.
