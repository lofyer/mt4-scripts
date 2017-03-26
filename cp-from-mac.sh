#!/bin/bash
DIR=(Experts Files Images Include Indicators Libraries Logs Projects Scripts)
for i in ${DIR[@]}
do
    rsync -avrPS --delete ~/Library/Application\ Support/CrossOver/Bottles/MetaTrader\ 4/drive_c/Program\ Files/OANDA\ -\ MetaTrader/mql4/$i .
done
