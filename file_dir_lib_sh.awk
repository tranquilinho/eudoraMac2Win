#
# Interface to use functions from the library "file_dir_lib.awk"
# The function name must be passed in the standard input, and the
# function parameters in the ARGV array (command parameters)
#
# Use file_dir_lib.sh if you want to run this script directly from the shell

BEGIN {
	for (i=1 ; i< ARGC ; i++){
		PARAMETERS[i]=ARGV[i]
		# print i " - " PARAMETERS[i]
		# Awk parameters not deleted are processed as filenames...
		delete ARGV[i]
	}
}

/DOS_compliant_filename/ {
	print DOS_compliant_filename(PARAMETERS[1],PARAMETERS[2])
	exit 0
}

/extract_filename_mac/ {
	print extract_filename_mac(PARAMETERS[1])
	exit 0
}

/check_file_exists/ {
	exit check_file_exists(PARAMETERS[1])
}

# If the function name is not recognized, return 1 to reflect it
{ exit 1}
