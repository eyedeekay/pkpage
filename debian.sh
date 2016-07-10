#! /bin/sh
# Configure your paths and filenames
SOURCEBINPATH=.
SOURCEBIN=pkpage.sh
SOURCEBINH=hdpage.sh
SUPPBIN=hdpage
SOURCEDOC=README.md
DEBFOLDER=pkpage
DEBVERSION=$(date +%Y%m%d)
CONTROL_FILE="Source: pkpage
Section: admin
Priority: optional
Maintainer: idk <eyedeekay@i2pmail.org>
Build-Depends: debhelper (>= 9)
Standards-Version: 3.9.5
Homepage: https://cmotc.github.io/pkpage/
Vcs-Git: git@github.com:cmotc/pkpage.git
Vcs-Browser: https://github.com/cmotc/pkpage

Package: pkpage
Architecture: all
Depends: \${misc:Depends}, markdown
Description: Generates a Markdown-formatted description of a software package
 and a corresponding html page. For use with my repo generator, apt-git so that
 it can generate package description pages automatically and make the
 repositories easier to browse. It's a very, very basic little script. I don't
 intend to expand it or make it smarter, instead I'm going to use it by
 redirecting it's output and processing that. It uses dpkg --info to read the
 contents of your debian package, grep and sed, and doesn't need bash, so it
 should run fine on any Debian-based system.
 "
DEBFOLDERNAME="../$DEBFOLDER-$DEBVERSION"

cd $DEBFOLDER

# Create your scripts source dir
mkdir $DEBFOLDERNAME

# Copy your script to the source dir
cp $SOURCEBINPATH/$SOURCEBIN $DEBFOLDERNAME/$DEBFOLDER
cp $SOURCEBINPATH/$SOURCEBINH $DEBFOLDERNAME/$SUPPBIN
cd $DEBFOLDERNAME

# Create the packaging skeleton (debian/*)
dh_make -s --indep --createorig
echo "$CONTROL_FILE" > debian/control

# Remove make calls
grep -v makefile debian/rules > debian/rules.new
mv debian/rules.new debian/rules

# debian/install must contain the list of scripts to install
# as well as the target directory
echo $DEBFOLDER usr/bin > debian/install
#echo $SOURCEDOC usr/share/doc/apt-git >> debian/install

# Remove the example files
rm debian/*.ex

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild -us -uc #> ../log