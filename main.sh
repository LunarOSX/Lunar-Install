#!/bin/bash
#lol
#cd ~/ && curl -s "https://raw.githubusercontent.com/LunarOSX/Lunar-Install/refs/heads/main/main.sh" | bash </dev/tty

main() {
    clear
    echo -e "Welcome to Lunar"

    echo -ne "Checking Macsploit status..."
    curl -s "https://git.raptor.fun/main/jq-macos-amd64" -o "./jq"
    chmod +x ./jq
    
    curl -s "https://git.raptor.fun/sellix/hwid" -o "./hwid"
    chmod +x ./hwid
    
    local user_hwid=$(./hwid)
    local hwid_info=$(curl -s "https://git.raptor.fun/api/whitelist?hwid=$user_hwid")
    local hwid_resp=$(echo $hwid_info | ./jq -r ".success")
    rm ./hwid
    
    if [ "$hwid_resp" != "true" ]; then
        echo -ne "\rEnter License Key:       \b\b\b\b\b\b"
        read input_key

        echo -n "Contacting Secure Api... "
        
        local resp=$(curl -s "https://git.raptor.fun/api/sellix?key=$input_key&hwid=$user_hwid")
        echo -e "Done.\n$resp"
        
        if [ "$resp" != 'Key Activation Complete!' ]; then
            rm ./jq
            exit
        fi
    fi

    sleep 3
    
    echo -e "Install Script Version : 1.0.1"
    
    sleep 2
    
    echo -e "Downloading Lunar..."

    curl "https://github.com/LunarOSX/Lunar-Download" -o "./lunar.zip"

    sleep 3
    
    echo -e "Installing!"

    mkdir ~/Downloads/lunar_temp

    asr restore --source ./Lunar.dmg --target ~/Downloads/lunar_temp --erase

    zip -r ~/Downloads/lunar.zip ~/Downloads/lunar_temp

    rm -rf ~/Downloads/lunar_temp

    rm ./Lunar.dmg

    echo -e "Activating auto Update system"

    rm ./jq

    exit
}

main
