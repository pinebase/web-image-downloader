#!/bin/bash


# set program name
program_name="web-image-downloader"


# get current version
version=$(cat ./version)


# load installation header
header="
           _     _ 
          (_)   | |
 __      ___  __| |
 \ \ /\ / / |/ _  |
  \ V  V /| | (_| |
   \_/\_/ |_|\__ _|
"
echo "$header"
echo ""
echo "Web Image Downloader"
echo "version $version"
echo "https://github.com/pinebase/$program_name"
echo ""

# install writable /var directory 
if [ ! -d /var/lib/$program_name/ ]
then
	mkdir /var/lib/$program_name/
	echo "# created folder: /var/lib/$program_name/"
fi


# install write protected program folder
if [ ! -d /usr/lib/$program_name/ ]
then
	mkdir /usr/lib/$program_name/
	echo "# created folder: /usr/lib/$program_name/"
fi


# install current version log
if [ ! -f /var/lib/$program_name/current_version ]
then
	touch /var/lib/$program_name/current_version
	echo "# created file: /var/lib/$program_name/current_version"
fi


# update current version file
echo $version > /var/lib/$program_name/current_version
echo "# current version updated"


# install version specific files
if [ ! -d /usr/lib/$program_name/v$version/ ]
then
	mkdir /usr/lib/$program_name/v$version/
	echo "# created folder: /usr/lib/$program_name/v$version/"
fi


# copy program files to /var/lib
cp `pwd`/* -r /usr/lib/$program_name/v$version/
echo "# copied files to: /usr/lib/$program_name/v$version/"


# update permissions for executables
chmod 755 /usr/lib/$program_name/v$version/wid*.sh
echo "# updated permissions: 755 /usr/lib/$program_name/v$version/wid*.sh"


if [ -f ./manual/wid.1 ]
then
	if [ -d /usr/local/share/man/man1/ ]
	then
		# copy manual file
		cp ./manual/wid.1 /usr/local/share/man/man1/

		# refresh system man pages
		mandb -q
		echo "# man page updated for wid"
	fi
fi


# create soft links in /usr/bin
unlink /usr/bin/wid 2>/dev/nul
ln -s /usr/lib/$program_name/v$version/wid.sh /usr/bin/wid
echo "# soft link created: /usr/bin/wid"


echo "# installation complete"
echo ""

exit
