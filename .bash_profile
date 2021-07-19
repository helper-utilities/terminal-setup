# source ~/._zshprofile
# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

# Add Visual Studio Code (code)

export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:${PATH}"

# Add MongoDB
export PATH="$PATH:/usr/local/mongodb/bin"

# Add MPI for parallel
export PATH="$HOME/opt/usr/local/bin:$PATH"
export TMPDIR="/tmp"


if [ -s ~/.bashrc ]; then
    source ~/.bashrc;
fi
