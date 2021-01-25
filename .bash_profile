# source ~/._zshprofile
# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

# Add Visual Studio Code (code)

export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:${PATH}"

# Add MongoDB
export PATH="$PATH:/usr/local/mongodb/bin"

if [ -s ~/.bashrc ]; then
    source ~/.bashrc;
fi
