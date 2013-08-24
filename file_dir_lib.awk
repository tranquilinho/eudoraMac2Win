#
# NAME
# file_dir_lib.awk
#
# DESCRIPTION
# A library of functions related to files and directories
#
# NOTES
# Use it appending "-f file_dir_lib.awk" to the awk call
#
# AUTHOR
#   Jesus Cuenca
#
# VERSION
#   1.0
# 
# HISTORY
#   1.0 - Initial release


# Return a file name valid in DOS (but with no 8.3 length check)
# Characters in SKIP_CHARS are not validated
function DOS_compliant_filename (FILE_NAME,SKIP_CHARS){
	gsub("=.3","",FILE_NAME)
	gsub("Ì\\201","",FILE_NAME)
	gsub("=","",FILE_NAME)
	gsub("Ì.","",FILE_NAME)
	# Replace sequences of dots and trailing dots
	gsub("\\.*\\.",".",FILE_NAME)
	gsub("\\.\\.",".",FILE_NAME)	
	end_index=length(FILE_NAME)
	end_char=substr(FILE_NAME,end_index,end_index)
	if (end_char == ".")
		FILE_NAME=substr(FILE_NAME,1,end_index -1)
	
	gsub("[#()~,:&?;|]","",FILE_NAME)
	gsub("\\[","",FILE_NAME)
	gsub("\\]","",FILE_NAME)
	if (index(SKIP_CHARS,"/") == 0)
		gsub("/","",FILE_NAME)
	gsub("\\","",FILE_NAME)
	if(index(SKIP_CHARS, " ") == 0)
		gsub(" ","",FILE_NAME)
	gsub("\\*","",FILE_NAME)
	return FILE_NAME
}

# Return the file name from a MAC OS full path
# In Mac, the directory separator is ':'
function extract_filename_mac(MAC_PATH){
	n=split(MAC_PATH, path,":")
	return path[n]
}


function check_file_exists(FILE_NAME){
	if ((getline kk < FILE_NAME) > 0){
 		# Found it
		close(FILE_NAME)
		return 1
	}
	return 0
}
