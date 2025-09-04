# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="fwalch"
#ZSH_THEME="zhann"
ZSH_THEME="minimal"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  oc
  aws
  mvn
)

# User configuration

zstyle ':omz:alpha:lib:git' async-prompt no
zstyle ':omz:update' mode auto

# export MANPATH="/usr/local/man:$MANPATH"

FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

### Actual dir where this file is (symlink followed) ###
ACTUAL_DIR=$HOME/dev/juliaaano/terminal

### Auto-complete on 'cd' ###
export CDPATH=$HOME

### ALIASES ###
source $ACTUAL_DIR/.aliases

### HISTORY ###
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS

### GREP Options s###
export GREP_OPTIONS=-i

### Good for tmux ###
#export EDITOR=vim

### GPG SSH ###
#export GPG_TTY=$(tty)
#export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#gpgconf --launch gpg-agent
#eval $($HOME/dev/juliaaano/scripts/gpg-agent-setup.sh)

### Ruby ###
eval "$(rbenv init - zsh)"
#export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

### Homebrew ###
#export HOMEBREW_GITHUB_API_TOKEN=$($ACTUAL_DIR/secrets/HOMEBREW_GITHUB_API_TOKEN.sh)

### jenv ###
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

### GOLANG ###
#export PATH="$GOPATH/bin:$PATH"
#export PATH=$PATH:/usr/local/go/bin

### KUBECTL KREW ###
export PATH="${PATH}:${HOME}/.krew/bin"

### AWS zsh plugin ###
function aws_prompt_info() {
  if [[ -z $AWS_REGION || -z $AWS_PROFILE ]];then return; fi
  echo "${AWS_PROFILE}|${AWS_REGION}"
}

### KUBE PS1 PROMPT ##
### https://github.com/jonmosco/kube-ps1 ###
source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1)'$PS1
export KUBE_PS1_BINARY=oc
export KUBE_PS1_NS_ENABLE=true
export KUBE_PS1_PREFIX=""
export KUBE_PS1_SUFFIX=" "
export KUBE_PS1_SYMBOL_ENABLE=false
export KUBE_PS1_NS_COLOR="cyan"
export KUBE_PS1_CTX_COLOR="yellow"
#function get_cluster_short { echo "$1" | cut -d "/" -f "2" | cut -d ":" -f "1" | cut -d "-" -f "4,5" }
function get_cluster_short {
  declare -a array=($(echo "$1" | tr "/" " "))
  array_length=${#array[@]}
  user=${array[${array_length}]}
  if [[ "$1" == *"crc"* ]]; then
    domain="crc"
  elif [[ "$1" == *"sandbox"* ]]; then
    domain=$(echo ${array[${array_length}-1]} | cut -d ":" -f 1 | cut -d "-" -f "5")
  elif [[ "$1" == *"redhatworkshops"* ]]; then
    domain=$(echo ${array[${array_length}-1]} | cut -d ":" -f 1 | cut -d "-" -f "3,5")
  elif [[ "$1" == *"rosa"* ]]; then
    domain=$(echo ${array[${array_length}-1]} | cut -d ":" -f 1 | cut -d "-" -f "2,3")
  else
    domain=$(echo ${array[${array_length}-1]} | cut -d ":" -f 1) 
  fi
  if [[ "${domain}" == "N" ]]; then
    echo "off"
  elif [ ${array_length} -gt 1 ]; then
    echo "${user}@${domain}"
  else
    echo "$1"
  fi
}
export KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

### https://github.com/junegunn/fzf ###
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

### PYENV ###
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

### Bitwarden CLI ###
#eval "$(NODE_OPTIONS='--no-deprecation' bw completion --shell zsh); compdef _bw bw;"
#alias bw='NODE_OPTIONS="--no-deprecation" bw'

### AGNOSTICD ###
export AGNOSTICD_HOME=${HOME}/redhat/redhat-cop/agnosticd

### GOOGLE / CLAUDE / GEMINI ###
export CLAUDE_CODE_USE_VERTEX=1
export CLOUD_ML_REGION=us-east5
export ANTHROPIC_VERTEX_PROJECT_ID=$(${ACTUAL_DIR}/secrets/GOOGLE_CLOUD_PROJECT.sh)
export ANTHROPIC_MODEL='claude-sonnet-4@20250514'
export ANTHROPIC_SMALL_FAST_MODEL='claude-sonnet-4@20250514'

export GEMINI_API_KEY=$(${ACTUAL_DIR}/secrets/GEMINI_API_KEY.sh)
export GEMINI_API_KEY=$(${ACTUAL_DIR}/secrets/GOOGLE_CLOUD_PROJECT.sh)

