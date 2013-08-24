#!/bin/sh
#
# NAME
#   rename_mac2win.sh
#
# DESCRIPTION
#   Rename files from Mac convention to win convention
#
# SYNTAX
#   rename_mac2win.sh MAC_FILES_DIR
# 
# EXAMPLES
#   rename_mac2win.sh /user/joe/My_Mac/My_Documents
#
# NOTES
#   To do:
#   Remove "Icon" ".DS_Store" and "._*" files
#   Add file extension depending upon the real file type
#
# AUTHOR
#   Jesus Cuenca
#
# VERSION
#   1.0
# 
# HISTORY
#   1.0 - Initial release

SCRIPTS_DIR=`pwd`

find "$1" -depth -print | while read f
do

	# Name the mailbox with Eudora Windows extension (mbx) and respecting DOS
	# filenames conventions
	dos_name=`$SCRIPTS_DIR/file_dir_lib.sh DOS_compliant_filename "$f" "/ "`
	if [ "$f" != "$dos_name" ]
	then
		mv "$f" "$dos_name"
	fi
done
