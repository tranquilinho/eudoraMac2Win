# To run directly from the shell, use process_Eudora_attach_Mac.sh
#
# NAME
#   process_Eudora_attach_Mac.awk
#
# DESCRIPTION
#   Update attachment file names both in the Eudora mailbox and in the file system
#   New file names follow Windows FAT restrictions (reserved chars).
#   The fixed mailbox is written to standard output, so redirect it to the file
# that will be used in Eudora for Windows.
#   Attachments are grouped by their initials (to reduce directory file count)
#   Keeps a log of what's done for reference. The log is saved in the same folder
# where the mailbox resides (.log extension)
#
# SYNTAX
#   process_Eudora_attach_Mac.awk mailbox.unix attachment_folder_path
#
#   mailbox.unix -> Eudora mailbox with Unix text format (LF instead of CR)
#   attachment_folder_path -> the directory where the Eudora for Mac attachments are stored
# 
# EXAMPLES
#   process_Eudora_attach_Mac.sh Eudora\ Folder/Mail\ Folder/mailbox.unix Eudora\ Folder/Attachments\ Folder/ > mailbox.mbx
#
# NOTES
#   Requires the library "file_dir_lib.awk"
#
# AUTHOR
#   Jesus Cuenca
#
# VERSION
#   1.0
# 
# HISTORY
#   1.0 - Initial release


# Returns the group to which LETTER belongs
# For example, "e" belongs to the group "D-F"
function letter_group(LETTER){
	LETTER=toupper(LETTER)
	if (index("ABC",LETTER) > 0)
		return "A-C"
	else if (index("DEF",LETTER) > 0)
		return "D-F"
	else if (index("GHIJ",LETTER) > 0)
		return "G-J"
	else if (index("KLMNÑO",LETTER) > 0)
		return "K-O"	
	else if (index("PQRST",LETTER) > 0)
		return "P-T"	
	else if (index("UVWXYZ",LETTER) > 0)
		return "U-Z"				
	else if (index("0123456789",LETTER) > 0)
		return "0-9"	
	else
		return "OTHERS"					
}

# ***********************************************************

# Process parameters passed to the script
# IMPORTANT: if the parameters syntax is modified, update it also in
# the process_Eudora_attach_Mac.sh script
BEGIN {

	MAILBOX_NAME = ARGV[1]
	# remove extension
	end_index=length(MAILBOX_NAME)
	MAILBOX_NAME=substr(MAILBOX_NAME,1,end_index - 4)
	
	WIN_ATTACH_FOLDER = ARGV[3] 
	LOG_FILE = MAILBOX_NAME ".log"
	# Connect attachment names with the mailboxes that refer to them
	ATTACH_REF_INDEX = "attachment_references_index.txt"
	ATTACHMENT_FOLDER = ARGV[2]
	# Awk parameters not deleted are processed as filenames...	
	delete ARGV[2]
	delete ARGV[3]	

	# If the paths do not end in a slash, append it
	end_index=length(WIN_ATTACH_FOLDER)
	end_char=substr(WIN_ATTACH_FOLDER,end_index,end_index)
	if (end_char != "\\")
		WIN_ATTACH_FOLDER= WIN_ATTACH_FOLDER "\\"

	end_index=length(ATTACHMENT_FOLDER)
	end_char=substr(ATTACHMENT_FOLDER,end_index,end_index)
	if (end_char != "/")
		ATTACHMENT_FOLDER= ATTACHMENT_FOLDER "/"
		

	# Begin logging
	print "Conversion started at " strftime("%Y/%m/%d/ %H:%M",systime()) > LOG_FILE
}


# "Main processing":
# Search for attachment references
 
/^Attachment converted: / {
# print $0
 n=split($0, line, ": ")
# print line[2]
 n=split(line[2],attachment," \\(")
 # attachment[1] = full path; attachment[2] = Mime type; attachment[3] = ??
 attachment_mac_path = attachment[1]
 mac_file_name=extract_filename_mac(attachment_mac_path)
 # Convert to DOS filename format and append base path
 dos_file_name=DOS_compliant_filename(mac_file_name,"")

 # Keep a record of transformations

 
 # Rename and move the attachment (destination folder must exist)
 MISSING=""
 mac_attachment_path=ATTACHMENT_FOLDER mac_file_name 
 # Place the attachment in a folder according to its initial
 letter=letter_group(substr(dos_file_name,1,1))
 destination_path=ATTACHMENT_FOLDER letter
 dos_attachment_path=destination_path "/" dos_file_name
 print mac_attachment_path >> LOG_FILE
 print mac_attachment_path "\t" MAILBOX_NAME >> ATTACH_REF_INDEX
 if (check_file_exists(mac_attachment_path) > 0){
	# Quotes are required because paths may contain blank spaces
	if(system("mv \"" mac_attachment_path "\" \"" dos_attachment_path "\"") == 0)
		message="  - Moved to " destination_path 
	else
		message="  - Error moving file to " destination_path
 }else if (check_file_exists(dos_attachment_path) > 0){
 	message="  - Already renamed"
 }else{
 	message="  - Attachment not found"
	MISSING=" [Missing attachment]"	
 }

 # No "\\" is needed between WIN_ATTACH_FOLDER and letter, since at the
 # beginning is ensured that WIN_ATTACH_FOLDER ends with "\\"
 dos_path=WIN_ATTACH_FOLDER  letter "\\" dos_file_name
 print attachment_mac_path " ==> " dos_path message >> LOG_FILE
 print "" >> LOG_FILE
 
 # Finish transformation by adding the "attachment converted" string
 print "Attachment converted: " dos_path
 # Eudora takes the whole line as attachment, so the missing status should be
 # written to a new line
 print MISSING

}

# Print other lines "as-is"
!/^Attachment converted: / {
	print $0
}

