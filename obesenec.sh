#!/bin/bash
IFS=$'\n'
readonly HANGMANPICS=(
"
  +---+
  |   |
      |
      |
      |
      |
=========
" 
"
  +---+
  |   |
  O   |
      |
      |
      |
=========" 
"
  +---+
  |   |
  O   |
  |   |
      |
      |
=========" 
"
  +---+
  |   |
  O   |
 /|   |
      |
      |
=========" 
"
  +---+
  |   |
  O   |
 /|\  |
      |
      |
=========" 
"
  +---+
  |   |
  O   |
 /|\  |
 /    |
      |
=========" 
"
  +---+
  |   |
  O   |
 /|\  |
 / \  |
      |
=========")

#Načíst slova ze souboru do pole
vsechny_slova=()
for i in $(cat slova.txt)
do
vsechny_slova+=("$i")
done

#Výběr náhodného slova
index=$(( RANDOM % ${#vsechny_slova[@]} ))
final_slovo=${vsechny_slova[index]}

#Převedení slova na malá písmena
final_slovo=${final_slovo,,}

uhadnuto=0
zobrazene_slovo=""
zivotu=6

delka_slova=${#final_slovo}

#Vytvoření slova, které se bude zobrazovat uživateli
for ((i=0; i<$delka_slova; i++))
do
  zobrazene_slovo+="_"
done


#Hlavní cyklus hry
while [ $uhadnuto -eq 0 ]
do
    clear

    #Vykreslení oběšence
    for i in ${HANGMANPICS[${#HANGMANPICS[*]} - zivotu]}
    do
        echo "$i"
    done

    echo "Slovo: $zobrazene_slovo"
    echo "Zbývá ti $zivotu životů"
    read -r -p "Zadejte písmeno: " pismeno


    if [ ${#pismeno} -gt 1 ]
    then
    echo "!! Zadávejte pouze 1 písmeno !!"
    read -r
    continue
    fi

    uhadnute_pismeno=0
    for ((i=0; i<delka_slova; i++))
    do
        if [ "${final_slovo:i:1}" == "$pismeno" ]
        then
            zobrazene_slovo="${zobrazene_slovo:0:i}$pismeno${zobrazene_slovo:i+1}"
            uhadnute_pismeno=1
        fi
    done

    if [ $zobrazene_slovo == $final_slovo ]
        then
            uhadnuto=1
        fi
    
    #Pokud neuhádl písmeno odebere se život
    if [ $uhadnute_pismeno -eq 0 ]
    then
    zivotu=$((zivotu-1))
    fi

    #Pokud nejsou životy, konec
    if [ $zivotu -eq 0 ]
    then
        break
    fi
done
clear
if [ $uhadnuto -eq 1 ]
then
echo "Gratuluji, uhádl si slovo ($final_slovo)"
else
    #Vykreslení oběšeného oběšence
    for i in ${HANGMANPICS[-1]}
    do
        echo "$i"
    done
echo "Byl si oběšen"
echo "Slovo bylo $final_slovo"
fi

read -r