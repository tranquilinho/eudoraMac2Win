#!/bin/sh
# NAME
#   eudora_mailbox_mac2win.sh
#
# DESCRIPTION
#
# Converts a single mailbox from Eudora for Macintosh to Eudora for Windows
#
# SYNTAX
#   eudora_mailbox_mac2win.sh MAC_MAILBOX MAC_ATTACHMENTS_FOLDER WIN_ATTACHMENTS_FOLDER
#   MAC_MAILBOX
#   MAC_ATTACHMENTS_FOLDER -> path to the local copy of the attachments (MAC
#   format)
#   WIN_ATTACHMENTS_FOLDER -> the full path to the directory where the attachments
#   will be stored in the PC
# 
# EXAMPLES
#   eudora_mac2win.sh "test/Eudora Folder" "h:\\Users\\joe\\Eudora\\Attachments Folder\\"
#
# NOTES
# 1) The new mailbox has the same name as the original, with the ".mbx"
# extension. The original mailbox is preserved with the original file name.
#
# REQUIRES
# tr, awk and process_Eudora_attach_Mac.awk script
#
# AUTHOR
#   Jesus Cuenca
#
# VERSION
#   1.0
# 
# HISTORY
#   1.0 - Initial release


MAILBOX="$1"
MAILBOXES_DIR=.
SCRIPTS_DIR=`pwd`
MAC_ATTACHMENTS_FOLDER="$2"
WIN_ATTACHMENTS_FOLDER="$3"

# Do a simple check on the parameters
if [ $# -ne 3 ]
then
	echo Wrong number of parameters $# -- see help
	exit 1
elif [ ! -f "$MAILBOX" ]
then
	echo Mailbox $MAILBOX not found
	exit 1
elif [ ! -d "$MAC_ATTACHMENTS_FOLDER" ]
then
	echo Macintosh attachments folder $MAC_ATTACHMENTS_FOLDER not found
	exit 1
fi

# Check script dependences
if [ ! -f $SCRIPTS_DIR/process_Eudora_attach_Mac.sh ]
then
	Required script 'process_Eudora_attach_Mac.sh' not found
fi

# Convert from MAC text format (CR) to UNIX text format (LF)
# At the same time, replace the MAC ASCII spanish chars with their equivalents.
# Pending: translation for Upper case chars
#
# Check if it has been already converted
if [ -f "$MAILBOX.unix" ]
then
	echo The mailbox \'$MAILBOX\' is available in UNIX format as \'$MAILBOX.unix\'
else
	tr '\r\207\216\222\227\234\226À' '\náéíóúñ¿' < "$MAILBOX" > "$MAILBOX.unix"
fi

# Process the attachment references in the mailbox
$SCRIPTS_DIR/process_Eudora_attach_Mac.sh "$MAILBOX.unix" "$MAC_ATTACHMENTS_FOLDER" "$WIN_ATTACHMENTS_FOLDER" > "$MAILBOX.tmp"

# Convert from UNIX text to DOS text (CRLF)
# Name the mailbox with Eudora Windows extension (mbx) and respecting DOS
# filenames conventions
dos_mbx_name=`$SCRIPTS_DIR/file_dir_lib.sh DOS_compliant_filename "$MAILBOX" "/ "`
# tr translates one character with another (not with another two)
#tr '\n' '\r\n' < "$MAILBOX.tmp" > "$dos_mbx_name.mbx"
# Note: the sed pattern contains a control code (which may not be visible): s/$/^M/g
sed 's/$//g' < "$MAILBOX.tmp" > "$dos_mbx_name.mbx"


# Clean temp files
rm -f "$MAILBOX.unix"
rm -f "$MAILBOX.tmp"

# Compress the original mailbox
gzip "$MAILBOX"

