eudoraMac2Win - a set of scripts to migrate e-mail from Eudora for Macintosh to Eudora for Windows

Author: Jesus Cuenca (jesus.cuenca@gmail.com)

Features
--------

- It compresses the Macintosh mailboxes (gzip format), and stores the Windows mailboxes with ".mbx" extension. Each time the script is run, it recreates the Windows mailboxes.

- It arranges the attachments in subfolders according to their initial.

It may not be able to move some attachments. It's recommended to move them to the "ORPHAN" subfolder of attachments folder. Use the script "move_orphan_attachments.awk" to achieve this.

The main script is eudora_mac2win.sh

Migration process
-----------------

1) Copy the Eudora for Macintosh folder to a Linux system.
Best option would be to have direct access to the HFS+ partition storing the Eudora folder. Since this option is complex, try archiving the Eudora folder in the Mac system and then copy the archive through the network. Once copied, unpack it to get the files back. Note that tar would be enough, but "HFS forks" require a MAC-OS specific archiver. Another option is to use an Appleshare server.

2) Process the mailboxes and attachments:
eudora_mac2win.sh PATH_TO/Eudora\ Folder "c:\\PATH_TO_WINDOWS_EUDORA\\Attachments Folder\\"

3) Move the remaining orphan attachments:
awk -f PATH_TO_SCRIPT/move_orphan_attachments.awk -f PATH_TO_SCRIPT/file_dir_lib.awk ORPHAN_ATTACHS_DIR < ORPHAN_ATTACH_FILE_LIST

4) Copy the converted Eudora Folder to the Windows system. Delete the ".gz" files

5) Address book:
Look in your System Folder:Eudora Folder for a file called Eudora Nicknames.
Convert to MS-DOS format and rename this file to NNDBASE.TXT and copy to Windows system.
Convert to MS-DOS format and add the ".txt" extension to all files in "Nicknames Folder", and copy them to the
"NICKNAME" folder of Windows system

6) Account settings: configure Eudora for Windows from the Eudora for Mac settings. Keep a copy of the settings in text format

