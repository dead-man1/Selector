#!/bin/bash
clear

# Display the title in multiple colors and big size
echo -e "\e[1;31mY\e[1;32mO\e[1;33mU\e[1;34mT\e[1;35mU\e[1;36mB\e[1;37mE\e[0m : \e[1;31mK\e[1;32mO\e[1;33mL\e[1;34mA\e[1;35mN\e[1;36mD\e[1;37mO\e[1;31mN\e[1;32mE\e[0m"

echo "Please choose an option:"
echo "1. IPv4 scan"
echo "2. IPv6 scan"
echo "3. V2ray and MahsaNG wireguard config"
echo -e "4. Hiddify config, After the first use, you can enter the \e[1;32mKOLAND\e[0m command"
echo "5. Warp License Cloner"
echo "Enter your choice:" 
read -r user_input

measure_latency() {
    local ip_port=$1
    local ip=$(echo $ip_port | cut -d: -f1)
    local latency=$(ping -c 1 -W 1 $ip | grep 'time=' | awk -F'time=' '{ print $2 }' | cut -d' ' -f1)
    if [ -z "$latency" ]; then
        latency="N/A"
    fi
    printf "| %-21s | %-10s |\n" "$ip_port" "$latency"
}

measure_latency6() {
    local ip_port=$1
    local ip=$(echo $ip_port | cut -d: -f1)
    local latency=$(ping6 -c 1 -W 1 $ip | grep 'time=' | awk -F'time=' '{ print $2 }' | cut -d' ' -f1)
    if [ -z "$latency" ]; then
        latency="N/A"
    fi
    printf "| %-45s | %-10s |\n" "$ip_port" "$latency"
}

display_table_ipv4() {
    printf "+-----------------------+------------+\n"
    printf "| IP:Port               | Latency(ms) |\n"
    printf "+-----------------------+------------+\n"
    echo "$1" | head -n 10 | while read -r ip_port; do measure_latency "$ip_port"; done
    printf "+-----------------------+------------+\n"
}

display_table_ipv6() {
    printf "+---------------------------------------------+------------+\n"
    printf "| IP:Port                                     | Latency(ms) |\n"
    printf "+---------------------------------------------+------------+\n"
    echo "$1" | head -n 10 | while read -r ip_port; do measure_latency6 "$ip_port"; done
    printf "+---------------------------------------------+------------+\n"
}

warp_license_cloner() {
    if ! command -v wg &>/dev/null; then
        if [ -d "$PREFIX" ] && [ "$(uname -o)" = "Android" ]; then
            echo "Installing wireguard-tools"
            pkg install wireguard-tools -y
            pkg install jq -y
        elif [ -x "$(command -v apt)" ]; then
            echo "Installing wireguard-tools on Debian/Ubuntu"
            sudo apt update -y && sudo apt install wireguard-tools -y
        elif [ -x "$(command -v yum)" ]; then
            echo "Installing wireguard-tools on CentOS/RHEL"
            sudo yum install epel-release -y && sudo yum install kmod-wireguard wireguard-tools -y
        elif [ -x "$(command -v dnf)" ]; then
            echo "Installing wireguard-tools on Fedora"
            sudo dnf install wireguard-tools -y
        elif [ -x "$(command -v zypper)" ]; then
            echo "Installing wireguard-tools on openSUSE"
            sudo zypper install wireguard-tools -y
        fi
    fi

    licenses=(
        "0L156IFo-Xlou7509-cL0kj975"
        "1E987bRY-KI8167Rp-2cO3I5a0"
        "450sxY1P-0927yEPv-538cGDa0"
        "82gHq31I-785W3PSO-1rW35X9v"
        "BQ91v37L-s296aVH3-5p34vXS6"
        "8NP103zQ-u2T68YS3-b3Cy25H9"
        "6M10oEq7-HA0h5y92-F42KMv61"
        "Pi0n45K6-24ON7A1C-7Q18My2n"
        "q36pSa91-240vtF1s-F25r10gZ"
        "H9y510oc-PR53o01f-cW176f0y"
        "Y4v03C5u-Ad81i3z5-PQ30z45f"
        "8V2hX14D-D0SR78w3-2ule45m3"
        "7V9p34gb-9hlI5Y64-C35dO6l2"
        "MAa9251S-M19y53Hb-05cJ2hS4"
        "R7k0j3p4-5B14RK6p-C8F6vw72"
        "X16yb7g2-1P3fH56y-x8L7e1D0"
        "5hc0L42Z-f15su76j-r0N8ia43"
        "8wnc27d1-C5F3d2y9-45eKs3F9"
        "05skL7r1-d683ZSB0-7RrT964j"
        "iTP2I901-821KdD5h-2840MpQv"
        "14b68TNu-v801R2Mi-690t7vYu"
        "QPIE0458-1VDX92W5-70e2iNA3"
        "53RN8G7d-24J59kYR-08b4v9RU"
        "G438E2Ve-uH4sE653-Kn53fJ76"
        "21Ig0LE8-47emp59P-N190Vf5z"
    )

    echo -e "\e[1;32m######################\e[0m"
    echo -en "\e[1;33mEnter a license (\e[1;32mPress Enter to use a random license, may not work\e[1;33m): \e[0m"
    read -r input_license

    if [ -z "$input_license" ]; then
        # Choose a random license from the list
        license=$(shuf -n 1 -e "${licenses[@]}")
    else
        license="$input_license"
    fi
    echo -e "\e[1;32m######################\e[0m"
    echo -e "\e[1;34mWarp License cloner\e[0m"
    echo -e "\e[1;32mStarting...\e[0m"
    echo -e "\e[1;34m-------------------------------------\e[0m"
    while true; do
        # Requirements
        if [ $(type -p wg) ]; then
            private_key=$(wg genkey)
            public_key=$(wg pubkey <<<"$private_key")
        else
            wg_api=$(curl -m5 -sSL https://wg-key.forvps.gq/)
            private_key=$(awk 'NR==2 {print $2}' <<<"$wg_api")
            public_key=$(awk 'NR==1 {print $2}' <<<"$wg_api")
        fi
        install_id=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 22)
        fcm_token="${install_id}:APA91b$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 134)"
        rand=$(tr -dc '0-9' </dev/urandom | head -c 3)

        # Register
        response=$(curl --request POST "https://api.cloudflareclient.com/v0a${rand}/reg" \
            --silent \
            --location \
            --tlsv1.3 \
            --header 'User-Agent: okhttp/3.12.1' \
            --data-raw "{\"install_id\":\"${install_id}\",\"fcm_token\":\"${fcm_token}\",\"locale\":\"en\",\"device_model\":\"${private_key}\",\"device_id\":\"${public_key}\"}")
        
        # Output response for debugging
        echo "Response: $response"

        # Parse response and handle accordingly
        if echo "$response" | grep -q '"code":"200"'; then
            echo "License cloned successfully!"
            break
        else
            echo "License cloning failed. Retrying..."
            sleep 5
        fi
    done
}

# Execute the chosen
# Execute the chosen option
if [ "$user_input" -eq 1 ]; then
    echo "Fetching IPv4 addresses from install.sh..."
    ip_list=$(echo "1" | bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh) | grep -oP '(\d{1,3}\.){3}\d{1,3}:\d+')
    clear
    echo "Top 10 IPv4 addresses with their latencies:"
    display_table_ipv4 "$ip_list"
elif [ "$user_input" -eq 2 ]; then
    echo "Fetching IPv6 addresses from install.sh..."
    ip_list=$(echo "2" | bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh) | grep -oP '(\[?[a-fA-F\d:]+\]?\:\d+)')
    clear
    echo "Top 10 IPv6 addresses with their latencies:"
    display_table_ipv6 "$ip_list"
elif [ "$user_input" -eq 3 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/V2/main/koland.sh)
elif [ "$user_input" -eq 4 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Hidify/main/install.sh)
    KOLAND
elif [ "$user_input" -eq 5 ]; then
    warp_license_cloner
else
    echo "Invalid input. Please enter 1, 2, 3, 4, or 5."
fi
