[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export LEARNOBJ=updateprofile
export PS1="\e[1;36m\h \u: \W \$ \e[0m"

export PATH=$PATH:/Users/astarte/temp/commandos-1.2/bin
export PATH=$PATH:~/bin/apache-maven-3.5.0/bin
export PATH=${PATH}:/usr/local/mysql/bin

export TWILIO_ACCOUNT_SID=ACb89280bfd4795f0637fb74ba88c7bbec
export TWILIO_AUTH_TOKEN=7e1a322409a814eb419231fd2b15c2d0
export TWILIO_PHONE=+447403938490
export TWILIO_DESTINATION_PHONE=+447377078978
export SESSION_SECRET=ynDsoX5detIrUWZDE9zb3nxOuJ4=

JAVA_HOME=/Library/Java/Home
export JAVA_HOME;

pman() {
    man -t ${@} | open -f -a /Applications/Preview.app/
}
