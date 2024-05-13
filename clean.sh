#!/bin/sh
nitro-cli terminate-enclave --all
FILE=nitro-enclave.eif
if [ -f "$FILE" ]; then
    rm $FILE
fi
