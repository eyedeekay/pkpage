#! /bin/bash

while getopts ":f:" opt; do
  case $opt in
    f)
      echo "-f using file: $OPTARG" > /dev/null
      PKG_FILE=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
if [ ! -f $PKG_FILE ]; then
    echo "Package file not found" >&2
    exit 1
fi
PROCESS_CMD=markdown
PKG_INFO=$(dpkg --info $PKG_FILE)

PKGFILEBIN=$(dpkg --info $PKG_FILE | grep 'Package:' | sed -e 's/^[ \t]*//')
HONE="============="
printf "%b\n" "\n<div id=\"header\">\n"
printf "%b\n" "$PROFILEBIN \n $HONE \n" | markdown
PKGFILESRC=$(dpkg --info $PKG_FILE | grep 'Source:' | sed -e 's/^[ \t]*//')
HTWO="-------------"
printf "%b\n" "$PROFILESRC \n $HTWO \n" | markdown
printf "%b\n" "\n</div>\n"
printf "%b\n" "\n<div id=\"content\">\n"
PKGFILEVER=$(echo -n "###" && dpkg --info $PKG_FILE | grep 'Version:' | sed -e 's/^[ \t]*//')
PKGFILEMAN=$(echo -n "####" && dpkg --info $PKG_FILE | grep 'Maintainer:' | sed -e 's/^[ \t]*//')
PKGFILEDEP=$(dpkg --info $PKG_FILE | grep 'Depends:' | sed -e 's/^[ \t]*//' | sed -e 's/Depends:/###Depends:\n  */')
PKGFILEREC=$(dpkg --info $PKG_FILE | grep 'Recommends:' | sed -e 's/^[ \t]*//' | sed -e 's/Recommends:/###Recommends:\n  */')
DESCRIPTION_START=$(dpkg --info $PKG_FILE |  grep -n Description |  tr -d '[A-Za-z]' | tr -d '\-:. ' )
TOTAL_LINES=$(dpkg --info $PKG_FILE | nl | tail -1 |  tr -d '[A-Za-z]' | tr -d '\-:=. ' )
TAIL_NUM=$(expr $TOTAL_LINES - $DESCRIPTION_START + 1)
PKGFILEDSC=$(dpkg --info $PKG_FILE | tail -n $TAIL_NUM | sed -e 's/^[ \t]*//' | sed -e 's/Description:/###Description:\n/')
printf "%b\n" "$PKGFILEVER" | markdown
printf "%b\n" "$PKGFILEMAN" | markdown
printf "%b\n" "$PKGFILEDSC" | markdown
printf "%b\n" "$PKGFILEDEP" | markdown
printf "%b\n" "$PKGFILEREC" | markdown
printf "%b\n" "\n</div>\n"
printf "%b\n" "\n<div id=\"sidebar\">\n"
PKGFILEPRV=$(dpkg --info $PKG_FILE | grep 'Provides:' | sed -e 's/^[ \t]*//' | sed -e 's/Provides:/###Provides:\n  */')
PKGFILESEC=$(echo -n "####" && dpkg --info $PKG_FILE | grep 'Section:' | sed -e 's/^[ \t]*//')
PKGFILEPRI=$(echo -n "####" && dpkg --info $PKG_FILE | grep 'Priority:' | sed -e 's/^[ \t]*//')
PKGFILESIZ=$(echo -n "####" && dpkg --info $PKG_FILE | grep 'Installed-Size:' | sed -e 's/^[ \t]*//')
PKG_URL=$(dpkg --info $PKG_FILE | grep 'Homepage:' | sed -e 's/Homepage:/ /' | sed -e 's/^[ \t]*//') #)
PKGFILEURL=$(dpkg --info $PKG_FILE | grep 'Homepage:' | sed -e 's/^[ \t]*//' | sed -e 's/Homepage:/Homepage:[/' | tr "\n" " " && echo "]($PKG_URL)")
printf "%b\n" "$PKGFILEURL" | markdown
printf "%b\n" "$PKGFILEPRV" | markdown
printf "%b\n" "$PKGFILESEC" | markdown
printf "%b\n" "$PKGFILESIZ" | markdown
printf "%b\n" "$PKGFILEPRI" | markdown
printf "%b\n" "\n</div>\n"
