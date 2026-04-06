#!/bin/bash
sleep 2

kwriteconfig6 --file kwinrc --group Desktops --key Name_1 ""
kwriteconfig6 --file kwinrc --group Desktops --key Name_2 "󰵅"
kwriteconfig6 --file kwinrc --group Desktops --key Name_3 ""
kwriteconfig6 --file kwinrc --group Desktops --key Name_4 ""
kwriteconfig6 --file kwinrc --group Desktops --key Name_5 ""

qdbus org.kde.KWin /KWin reconfigure
