#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Environment variables
export XDG_CONFIG_HOME="$HOME/.config"
export GPG_TTY=$(tty)
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export FZF_DEFAULT_OPTS="--bind ctrl-a:select-all;ctrl-d:deselect-all;ctrl-t:toggle-all"
export LC_ALL="en_GB.UTF-8"
export EDITOR=nvim

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# Disable the bs that disables all input
stty -ixon

# Aliases
alias ls='ls --color=auto'
# TODO: bootstrap nvim
alias vim='nvim'

# Colored manpages
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

# Set custom dark theme for tty terminals
if [ "$TERM" = "linux" ]; then
    printf '\033]P01a1813'; # black
    printf '\033]P1991f1f'; # red
    printf '\033]P25c991f'; # green
    printf '\033]P3997b1f'; # yellow
    printf '\033]P41f3e99'; # blue
    printf '\033]P5991f70'; # magenta
    printf '\033]P61f9999'; # cyan
    printf '\033]P7ccbc95'; # white
    printf '\033]P8333026'; # brighter black
    printf '\033]P9E62E2E'; # brighter red
    printf '\033]PA8AE62E'; # brighter green
    printf '\033]PBE6B82E'; # brighter yellow
    printf '\033]PC2E5CE6'; # brighter blue
    printf '\033]PDE62EA9'; # brighter magenta
    printf '\033]PE2EE6E6'; # brighter cyan
    printf '\033]PFE6D7AB'; # brighter white
    clear;
fi;

# Get git branch name in current directory
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# TODO: Bootstrap powerline
# Setup PS1 with powerline
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. $HOME/projects/powerline/powerline/bindings/bash/powerline.sh

# Load pyenv and pyenv-virtualenv
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
else
    # Install if not installed
    echo "Installing pyenv and pyenv-virtualenv"
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    git clone https://github.com/pyenv/pyenv-virtualenv.git $PYENV_ROOT/plugins/pyenv-virtualenv
    echo "Installation done, restarting shell..."
    exec "$SHELL"
fi

# Display managers are for losers
if [[ ! ${DISPLAY} && ${XDG_VTNR} == 1 ]]; then
	exec startx
fi
