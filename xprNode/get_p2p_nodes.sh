#!/bin/bash

echo "Checking p2p nodes, this may take a few minutes...."

# Get the directory where the script is located
script_dir=$(dirname "$(readlink -f "$BASH_SOURCE")")

# List of P2P nodes
addresses=(
        "p2p-protontest.saltant.io:9879"
        "testnet-p2p.alvosec.com:9878"
        "proton-seed-testnet.eosiomadrid.io:9877"
        "tn1.cats.vote:9876"
        "p2p-testnet.artwebin.com:9869"
        "tn1.protonnz.com:9876"
        "p2p.proton-testnet.genereos.io:9876"
        "testxpr-p2p.cindro.net:9870"
        "testnet-p2p.xprlabs.org:9870"
        "p2p-xpr-testnet.a-dex.xyz:9876"
        "proton-testnet.cryptolions.io:9874"
        "testnet-p2p.luminaryvisn.com:9876"
        "p2p-testnet.artwebin.com:9869"
        "peer-protontest.nodeone.network:9871"
        "testnet.proton.detroitledger.tech:1337"
        "testnet-api.kof8.com:9876"
        "proton-testnet.edenia.cloud:9878"
        "xpr.testnet.eosdublin.io:9802"
        "p2p-testnet-proton.eosarabia.net:9876"
        "proton-p2p-testnet.neftyblocks.com:19876"
        "bpt-p2p.storex.io:9876"
)

# Temporal array for storing available nodes with latency (ms.)
declare -A latencies

# Node pinging and latency filtering
for address in "${addresses[@]}"; do
  # Ping the node, get the delay in milliseconds
  ping_output=$(ping -c 1 "${address%%:*}" 2>/dev/null)

  if [[ $? -eq 0 ]]; then
    # Extract time from ping output
    latency=$(echo "$ping_output" | grep 'time=' | awk -F 'time=' '{print $2}' | awk '{print $1}')
    latencies["$address"]=$latency
  else
    echo "P2P Node unavailable: $address"
  fi
done

# Declaring a variable with a file name for sorted nodes
output_file="$script_dir/available_nodes.txt"

# Clearing the file before writing
> "$output_file"

# Sorting and outputting available nodes by latency to a file
for address in $(for key in "${!latencies[@]}"; do echo "${latencies[$key]} $key"; done | sort -n | awk '{print $2}'); do
    latency=${latencies[$address]}
    # Write the latency and p2p address with port in the desired format
    echo "#(latency: $latency ms)" >> "$output_file"
    echo "p2p-peer-address = $address" >> "$output_file"
done

# Additionally, we display the available and sorted p2p nodes on the screen
cat "$output_file"
