#!/bin/bash
# Stark post install script
# Argument is lib installation dir used

COMMENT_LINE="# Stark environment variables (do not remove this line)"

# Determine profile file
PROFILE=~/.bash_profile
ZSHRC_PROFILE=~/.zshrc
if [ -f $ZSHRC_PROFILE ]; then
    PROFILE=$ZSHRC_PROFILE
fi

# Create profile file if it does not exist
if [ ! -f $PROFILE ]; then
    touch $PROFILE
fi

# Add variables to profile if not detected
grep -qxF "$COMMENT_LINE" $PROFILE || echo "\n$COMMENT_LINE\nexport STARK_RUNTIME=$1/libstark.a" >> $PROFILE

# Reload profile
source $PROFILE &> /dev/null