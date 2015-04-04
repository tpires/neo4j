#!/bin/bash

DEFAULT_IFS="$IFS"
SALT_LEN=32

# either read from stdin or use the argument
if [ -z "$1" ]; then
  read INPUT
else
  INPUT="$1"
fi

if [ -z "$INPUT" ]; then
 echo "correct format <uname:pass>"
 exit
fi

IFS=':'
read -a UNAME_PASS <<< "$INPUT"

UNAME="${UNAME_PASS[0]}"
PASS="${UNAME_PASS[1]}"

# representing the password in hex format like \xAB\x0C etc
# HEX_PASS=$(echo -n $PASS | xxd -p | awk '{print toupper($1);}' | sed -r 's/(.{2})/\\x\1/g')
HEX_PASS=$(echo -n $PASS | hexdump -v -e '"\\\x" 1/1 "%02X"')
# echo $HEX_PASS


# create the salt and store it in hex format
SALT=$(cat /dev/urandom | tr -dc 'a-f0-9' | fold -w $SALT_LEN | head -n 1)
# SALT="28FD26AD92D6D2D8820E969F3F3732B4"
HEX_SALT=$(echo -n $SALT | sed -r 's/(.{2})/\\x\1/g')


# calculate the sha256 sum of the salt and password value
# need to split the output because the output ends with a hyphen
IFS=' '
read -a PASSWORD_HASH_ARRAY <<< $(printf $HEX_SALT$HEX_PASS | sha256sum)
PASSWORD_HASH="${PASSWORD_HASH_ARRAY[0]}"

# echo "$UNAME;$PASS;$SALT"
# echo "$PASSWORD_HASH"

# and print out the auth string
COMBINED=$(echo -n "$PASSWORD_HASH,$SALT" | awk '{print toupper($1);}')
echo "$UNAME:SHA-256,$COMBINED:"

IFS="$DEFAULT_IFS"
