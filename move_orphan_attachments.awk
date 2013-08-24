#!/usr/bin/awk -f

# Moves the files listed in standard input to the "ORPHAN" subdirectory of the
# folder passed as parameter. If needed, this script
# also renames the files to make their names DOS-compliant.
#
# EXAMPLE:
# awk -f PATH_TO_SCRIPT/move_orphan_attachments.awk -f \
# PATH_TO_SCRIPT/file_dir_lib.awk ORPHAN_ATTACHS_DIR < ORPHAN_ATTACH_FILE_LIST

BEGIN{
	ATTACH_INDEX="attachment_references_index.txt"
	ATTACH_FOLDER= ARGV[1] "/ORPHAN/"
	delete ARGV[1] 
}

{

	system("mv \"" $0 "\" \"" ATTACH_FOLDER DOS_compliant_filename($0,"/ ") "\"")
	
}
		


		
