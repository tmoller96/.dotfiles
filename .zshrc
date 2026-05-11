# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search sudo copyfile you-should-use zsh-bat mise npm aliases)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

export PATH="$HOME/.local/bin:$PATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="code ~/.zshrc"
alias zshreload="source ~/.zshrc"
alias explorer="explorer.exe"
alias cdfe="cd ~/dev/atoz/frontend"
alias cdbe="cd ~/dev/atoz/backend"
alias atoz="cd ~/dev/atoz && lazygit"
alias swt="setup_worktree"
alias rwt="remove_worktree"
alias db="code -n --profile SQL"


# # Strip Windows paths from WSL PATH
# # Keep only allowed Windows paths
# export PATH="$(echo "$PATH" | tr ':' '\n' | grep -vE '^/mnt/c/(?!Windows/System32/OpenSSH/|Users/thmo.itm/AppData/Local/Programs/Microsoft VS Code/bin)' | paste -sd: -)"
# export PATH="$PATH:/mnt/c/Users/$(cmd.exe /c 'echo %USERNAME%' | tr -d '\r')/AppData/Local/Programs/Microsoft VS Code/bin"


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(mise activate zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# git branch select functionality
gbsel() {
    local branch
    branch=$(git branch --all | grep -v HEAD | sed 's/^..//' | fzf) && git checkout "$(echo "$branch" | sed 's#remotes/origin/##')"
}

# setup worktree functionality
setup_worktree() {
  if [ -z "$1" ]; then
    echo "Usage: setup_worktree <branch-name>"
    return 1
  fi

  local branch="$1"
  local worktree_dir="/home/thomasmoeller/dev/atoz-$branch"
  local frontend_dir="$worktree_dir/frontend"

  if [ -d "$worktree_dir" ]; then
    echo "Error: Worktree directory '$worktree_dir' already exists."
    return 1
  fi

  echo "Fetching latest changes from origin..."
  git fetch origin

  echo "Creating git worktree at $worktree_dir from $branch..."
  git worktree add "$worktree_dir" "$branch" || return 1

  echo "Setting up worktree environment..."
  cd "$worktree_dir" || return
  mise trust
  mise run install

  cd "$frontend_dir" || return

  echo "Opening in VS Code..."
  code --profile Angular .
}

remove_worktree() {
  if [ -z "$1" ]; then
    echo "Usage: remove_worktree <branch-name>"
    return 1
  fi

  local branch="$1"
  local worktree_dir="/home/thomasmoeller/dev/atoz-$branch"

  if [ ! -d "$worktree_dir" ]; then
    echo "Error: Worktree directory '$worktree_dir' does not exist."
    return 1
  fi

  echo "Removing git worktree at $worktree_dir..."
  sudo git worktree remove "$worktree_dir" --force || return 1

  echo "Pruning worktrees..."
  git worktree prune

  echo "Worktree for branch '$branch' has been removed."
}


# Load Angular CLI autocompletion.
if command -v ng >/dev/null 2>&1; then
    source <(ng completion script)
fi

export PATH="$PATH:/opt/mssql-tools18/bin"

