#! /bin/bash

# author: bartlomiej.podolak@gmail.com
# https://github.com/otokan/ansible-grep

# usage: $0 <grep_regex> <dir>
# greps files in directory recourively; looks into ansible-vault files


VAULT_REGEX='\$ANSIBLE_VAULT;'
PASSWORD_FILE='~/ansible-vault-pass'

regex="$1"
dir="$2"

find "$dir" -type f | while read file; do
    #if grep -m 1 -q "$VAULT_REGEX" "$file"; then
    if head -n 1 "$file" | grep -m 1 -q "$VAULT_REGEX"; then
        #ansible-vault  --vault-password-file="$PASSWORD_FILE" view "$file" | grep "$regex" | sed 's#^#'"$file"':#'
        #ansible-vault  --vault-password-file="$PASSWORD_FILE" view "$file" | grep "$regex" | perl -ne 'print "'"$file"': $_";'
        ansible-vault  --vault-password-file="$PASSWORD_FILE" view "$file" | grep "$regex" | while read l; do echo "$file: $l"; done
    else
        grep -H "$regex" "$file"
    fi
done
