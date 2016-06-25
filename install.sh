#! /bin/sh
install_pkpage(){
        sudo cp pkpage.sh /usr/local/bin/pkpage
        sudo chmod a+x /usr/local/bin/pkpage
        sudo cp pkpage-wrap /usr/local/bin/pkpage-html
        sudo chmod a+x /usr/local/bin/pkpage-html
}
remove_pkpage(){
        sudo rm /usr/local/bin/pkpage
        sudo rm /usr/local/bin/pkpage-html
}
if [ $1="install " ]; then
        install_pkpage
elif [ $1="remove " ]; then
        remove_pkpage
else
        echo " \"install\" or \"remove\"! I don't know what I'm supposed to do!"
fi
