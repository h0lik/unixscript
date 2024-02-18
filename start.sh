#!/bin/bash
CHOICE=$(
whiptail --backtitle "SoraxLab shell script"\
         --title "Меню установки."\
         --menu "Клавишами верх/низ выберите справку и нажмите enter.
                 Для выхода выберите Exit." 0 0 20\
  "LEMP" "Установка сервер LEMP."\
  "LAMP" "Установка сервер LEMP."\
  "Exit" "Выход."\
  3>&2 2>&1 1>&3 )
exitstatus=$?
if [ $exitstatus = 0 ]; then
      echo "Вы выбрали:" $CHOICE
else
      echo "Отмена."
fi
sleep 1
for word in $CHOICE
do
if [ $word == LEMP ]; then
      echo "Install LEMP"
      sudo apt install curl wget -y
      mkdir ~/shell/
      cd ~/shell/
      wget https://raw.githubusercontent.com/soraxdev/unixscript/main/src/lemp.sh
      sudo chmod u+x install.sh
      ./install.sh
fi

if [ $word == LAMP ]; then
      echo "Install LEMP"

      sudo apt install curl wget -y
      mkdir ~/shell/
      cd ~/shell/
      wget https://raw.githubusercontent.com/soraxdev/test/main/lamp.sh
      sudo chmod u+x lamp.sh
      ./lamp.sh
fi

if [ $word == Exit ]; then
      exit 1
fi
done
