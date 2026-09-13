# Setting PATH for Python 3.14
# The original version is saved in .zprofile.pysave
if [ -d "/Library/Frameworks/Python.framework/Versions/3.14/bin" ]; then
  export PATH="/Library/Frameworks/Python.framework/Versions/3.14/bin:$PATH"
fi

# pyenv's own bin has to go on PATH before probing for the binary, otherwise a
# machine where pyenv lives only under ~/.pyenv would skip the whole block.
export PYENV_ROOT="$HOME/.pyenv"
[ -d "$PYENV_ROOT/bin" ] && export PATH="$PYENV_ROOT/bin:$PATH"

# Guarded so a machine without pyenv does not error on every login shell.
# `pyenv init -` has subsumed `pyenv init --path` since pyenv 2.x; running
# both cost ~110ms per login shell for nothing.
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
