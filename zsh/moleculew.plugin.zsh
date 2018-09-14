_molecule_or_moleculew() {
    if [[ -f ./moleculew ]] ; then
        ./moleculew "$@"
    else
        moleculew "$@"
    fi
}

alias molecule=_molecule_or_moleculew

compdef _molecule_or_moleculew=moleculew
