#!/bin/bash
cd /workspaces/MINENENENENE/SERVERS MINE
source .venv/bin/activate 
cd crafty-4 

if [[ -v 1 ]]; then
    yn="$1"
fi

while true; do
    if [[ ! -v yn ]]; then
        read -p 'Can we overwrite any local codebase changes? (Y/N)' yn
    fi
    
    case $yn in
        [yY] | -y )
            git reset --hard origin/master
            break;;
        [nN] | -n )
            break;;
        * )
            unset yn
            echo 'Please use Y or N to reply.';;
    esac
done

git pull 
python3 -m ensurepip --upgrade 
pip3 install --upgrade pip --no-cache-dir
pip3 install -r requirements.txt --no-cache-dir 
