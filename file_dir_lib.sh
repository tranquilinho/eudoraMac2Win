#!/bin/sh
# Use functions from the library "file_dir_lib_sh.awk" directly from the shell
# This script is needed because of "#!" and "awk -f" complexities
# Syntax:
# file_dir_lib.sh function name parameters

SCRIPT_PATH=`pwd`
FUNCTION_NAME=$1
shift
echo $FUNCTION_NAME | awk -f $SCRIPT_PATH/file_dir_lib.awk -f $SCRIPT_PATH/file_dir_lib_sh.awk -- "$1" "$2"
exit $?
