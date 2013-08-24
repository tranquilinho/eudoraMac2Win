#!/bin/sh
# Run the awk script process_Eudora_attach_Mac.sh
# This script is needed because of "#!" and "awk -f" complexities
# Syntax:
# See process_Eudora_attach_Mac.awk

SCRIPT_PATH=`pwd`
awk -f $SCRIPT_PATH/file_dir_lib.awk -f $SCRIPT_PATH/process_Eudora_attach_Mac.awk "$1" "$2" "$3"
exit $?
