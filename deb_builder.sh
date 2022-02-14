#!/bin/bash
if ! which convert > /dev/null; then
   echo "imagemagick is not installed!"
   sleep 1s;
   exit
fi
echo "deb-builder.1.0.stable"
echo "created by sreeranj"
echo "#################################"
echo "creating essential files.."
r=$RANDOM
sleep 5s;
cd
mkdir deb_builder
cd deb_builder
mkdir src
cd src
mkdir DEBIAN
mkdir usr
cd usr
mkdir bin
mkdir share
cd share
echo "creating share file.."
mkdir applications
mkdir icons
sleep 3s;
cd /home/$USER/deb_builder/src/DEBIAN/
touch control
echo "created necessary files!"
sleep 2s;
echo "starting user setup.."
sleep 1s;
echo "project-name:"
read a
echo "Version:"
read b
echo "Description:"
read c
echo "maintainer:"
read d
echo "architecture:"
read e
cd /home/$USER/deb_builder/src/usr/share/icons/
FILE=`zenity --file-selection --title="Select a icon"`
convert $FILE $r.xpm
#cp x.xpm /home/$USER/deb_builder/src/usr/share/icons/icon.xpm
FILE2=`zenity --file-selection --title="Select a executable"`
cd /home/$USER/deb_builder/src/usr/bin/
cp $FILE2 /home/$USER/deb_builder/src/usr/bin/$r
cp /usr/share/preinst /home/$USER/deb_builder/src/DEBIAN/
cd /home/$USER/deb_builder/src/DEBIAN/
echo "adding data to preinst.."
sed -i "s/executable/$r/" preinst
sed -i "s/app.desktop/$r.desktop/" preinst
sed -i "s/icon.xpm/$r.xpm/" preinst
sleep 1s;
echo "applying user setup.."
sleep 1s;
echo "control.."
echo "Package: $a" > control
echo "Version: $b" >> control
echo "Architecture: $e" >> control
echo "Essential: no" >> control
echo "Priority: optional" >> control
echo "Depends: less,parted,rsync" >> control
echo "Maintainer: $d" >> control
echo "Description: $c" >> control
sleep 5s;
echo "launcher.."
cd /home/$USER/deb_builder/src/usr/share/applications/
touch $r.desktop
echo "[Desktop Entry]" > $r.desktop
echo "Version=$b" >> $r.desktop
echo "GenericName=$a" >> $r.desktop
echo "Comment=$c" >> $r.desktop
echo "Exec=/usr/bin/$r" >> $r.desktop
echo "TryExec=/usr/bin/$r" >> $r.desktop
echo "Icon=/usr/share/icons/$r.xpm" >> $r.desktop
echo "Terminal=true" >> $r.desktop
echo "Type=Application" >> $r.desktop
echo "Categories=Utility;" >> $r.desktop
echo "Keywords=Backup;" >> $r.desktop
echo "Name=$a" >> $r.desktop
sleep 10s;
echo "managing permission"
chmod +x /home/$USER/deb_builder/src/usr/bin/$r
chmod +x /home/$USER/deb_builder/src/DEBIAN/preinst
chmod +x /home/$USER/deb_builder/src/usr/share/applications/$r.desktop
sleep 2s;
cd /home/$USER/deb_builder/
echo "building-deb.."
dpkg-deb --build src $a.deb
echo "creating-md5sum"
md5sum *.deb > md5sums.txt
sleep 2s;
echo "build finished!"
sleep 2s;
echo "Do you wish to install this program?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) sudo dpkg -i *.deb; break;;
        No ) exit;;
    esac
done
$SHELL
