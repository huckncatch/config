
        #################################################
        #################################################
        #                                               #
        #        $ZDOT/zshrc_local.d/aliases.mine.zsh   #
        #                                               #
        #################################################
        #################################################


if [[ -o interactive ]]; then

    if [[ -x $SWPREFIX/bin/ls ||   $(uname) != Darwin  && $(uname) != FreeBSD  ]]; then
        alias ls='command ls -FsC --color=auto --si'
    fi

    alias od='opendiff'

    alias mv='nocorrect command mv -i'
    alias cp='nocorrect command cp -i'
    alias man='nocorrect man'

    alias jobs='builtin jobs -l'
    alias j='jobs'
    alias d='dirs'
    alias h=history
    alias grep=egrep
    alias em='emacs'
    alias c=clear

    # ls aliases
    alias lg="grep 'alias l' $ZDOT/zshrc_local.d/aliases.mine.zsh"  # show all list aliases
    alias ll='ls -l'                    # long listing (no dot files)
    alias la='ls -la'                   # long listing (full)
    alias lt='ls -lt'                   # long listing sorted by date
    alias ltr='ls -ltr'                 # long listing sorted by date (reversed)
    # List only directories and symbolic links that point to directories
    alias lsd='ls -ld *(-/DN)'          # list directories only
    alias lsda='ls -l *(-/DN)'           # list directories and their contents
    # List only files beginning with "."
    #alias lsa='ls -ld .*'               # list dot files only
    alias l.='ls -ld .*'                # list dot files only

    alias md='mkdir -p'
    alias rd=rmdir

    alias gfind='find . -type f -follow -print0 | xargs -0 grep -n'

    alias eg='set | grep -i'
    alias ag='alias | grep -i'
    alias cg='compctl | grep -i'
    alias hg='history 1- | grep -i'

    # Global aliases -- These do not have to be
    # at the beginning of the command line.
    alias -g M='|more'
    alias -g H='|head'
    alias -g T='|tail'
    alias -g L='|less'
    alias -g G='|grep'

    alias yt='youtube-dl --cookies ./cookies.txt --recode-video mp4 '

    ##
    # uncomment for debugging
    #echo ""; echo "Local aliases for zsh are now set"

fi

