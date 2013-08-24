#!/bin/sh
#
# NAME
#   eudora_mac2win.sh
#
# DESCRIPTION
#   Migrate e-mail from Eudora Macintosh to Eudora Windows. 
#
#   See README for a detailed description of the migration proccess
#
# SYNTAX
#   eudora_mac2win.sh eudora_mac_folder win_attachments_folder
#   eudora_mac_folder -> the path to the local copy of the original mail folder
#   win_attachments_folder -> the full path to the directory where the attachments
#   will be stored in the PC
# 
# EXAMPLES
#   eudora_mac2win.sh "test/Eudora Folder" "h:\\Users\\joe\\Eudora\\Attachments Folder\\"
#
# NOTES
#
# AUTHOR
#   Jesus Cuenca
#
# VERSION
#   1.1
# 
# HISTORY
#   1.1 - Minor improvements
#   1.0 - Initial release

WIN_ATTACHMENTS_FOLDER="$2"
MAC_MAIL_FOLDER="$1/Mail Folder"
MAC_ATTACH_FOLDER="$1/Attachments Folder"
SCRIPT_FOLDER=`pwd`
FOLDER_EXTENSION=".FOL"
EMPTY_MAILBOX_LOG="empty_mailboxes.log"


# Do a simple check on the parameters
if [ $# -ne 2 ]
then
	echo Syntax: $0 MAC_MAIL_ROOT FUTURE_WIN_ATTACHMENTS_DIR
	echo See README.md for details
	exit 1
elif [ ! -d "$1" ]
then
	echo Eudora folder $2 not found
	exit 1
fi

# Initialize EMPTY_MAILBOX_LOG
echo Empty mailboxes: >> $EMPTY_MAILBOX_LOG
echo ---------------- >> $EMPTY_MAILBOX_LOG

# Create "Attachments folder" subdirs if neccessary
if [ ! -d "$MAC_ATTACH_FOLDER/0-9" ]
then
	mkdir "$MAC_ATTACH_FOLDER/0-9"
	mkdir "$MAC_ATTACH_FOLDER/A-C"
	mkdir "$MAC_ATTACH_FOLDER/D-F"
	mkdir "$MAC_ATTACH_FOLDER/G-J"
	mkdir "$MAC_ATTACH_FOLDER/K-O"
	mkdir "$MAC_ATTACH_FOLDER/P-T"
	mkdir "$MAC_ATTACH_FOLDER/U-Z"
	mkdir "$MAC_ATTACH_FOLDER/OTHERS"
fi

	
# Rename folders, respecting DOS file name conventions
find "$MAC_MAIL_FOLDER" -depth -type d -print | while read cur_dir
do
	# Exclude the root folder
	if [ ! "$cur_dir" = "$MAC_MAIL_FOLDER" ]
	then
		dos_dir_name=`$SCRIPT_FOLDER/file_dir_lib.sh DOS_compliant_filename "$cur_dir" "/ "`$FOLDER_EXTENSION
		# Check that the directory has not been renamed
		echo "$cur_dir" | grep .FOL
		if [ $? -eq 1 ]
		then
			echo $cur_dir \-\> $dos_dir_name
			mv "$cur_dir" "$dos_dir_name"
		fi
	fi
done

# Rename and process mailboxes (all files excluding .TOC files)
find "$MAC_MAIL_FOLDER" -type f -print | grep -v ".toc" | while read cur_mbx
do
#	dos_mbx_name=`$SCRIPT_FOLDER/file_dir_lib.sh DOS_compliant_filename "$cur_mbx" "/ "`
	# Only process Mac mailboxes
	file "$cur_mbx" | grep -e "CR line\|CR, LF\|CR, NEL\|: data" > /dev/null
	TEST_MAC=$?
	tr '\r' '\n' < "$cur_mbx" | head | grep -e "From: \|Received: " > /dev/null
	TEST_MAC=`expr $? + $TEST_MAC` 

		echo
	if [ $TEST_MAC = "0" ]
	then
		echo Processing $cur_mbx ...
		#\($dos_mbx_name\) ...
		$SCRIPT_FOLDER/eudora_mailbox_mac2win.sh "$cur_mbx" "$MAC_ATTACH_FOLDER" "$WIN_ATTACHMENTS_FOLDER"
	else
		file "$cur_mbx" | grep ": empty" > /dev/null
		if [ $? = "0" ]
		then
			echo $cur_mbx >> $EMPTY_MAILBOX_LOG
		else 
			echo File $cur_mbx is not a Macintosh mailbox
		fi
	fi
done

echo Finished - see migration logs \(.log extension\) in $MAC_MAIL_FOLDER
