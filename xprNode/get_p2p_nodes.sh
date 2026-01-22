#!/bin/bash

# Requires: curl, jq
# If the API is unavailable or returns nothing, a static fallback list will be used

API_URL="https://danemarkbp.com/apis/get_json_testnet.php?status=active&type=p2p"

echo "Checking p2p nodes, this may take a few minutes...."

# Get the directory where the script is located
script_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

# ---------- Fallback static list (verified January 2026) ----------
fallback_addresses=(
  "p2p-protontest.saltant.io:9879"
  "testnet-p2p.alvosec.com:9878"
  "proton-seed-testnet.eosiomadrid.io:9877"
  "proton.testnet.protonuk.io:9876"
  "p2p.testnet.totalproton.tech:9842"
  "testnet.brotonbp.com:9877"
  "p2p-xpr-test.danemarkbp.com:9876"
  "tn1.protonnz.com:9876"
  "bpt-p2p.storex.io:9999"
  "xpr-testnet-p2p.bloxprod.io:9875"
  "peer-xprtest.blocksforge.com:9876"
  "test.proton.p2p.eosusa.io:19879"
  "p2p.proton-testnet.genereos.io:9876"
  "protontest.eu.eosamsterdam.net:9905"
  "testnet-p2p.xprcore.com:9876"
  "p2p-testnet.chaininfra.net:9876"
  "testnet-p2p.xprdata.org:19876"
  "proton-testnet.cryptolions.io:9874"
  "testnet-p2p.cerebro.host:9876"
  "testchain.simpleblock.org:9876"
  "p2p-testnet.artwebin.com:19876"
  "testnet-p2p.xprlabs.org:9870"
  "tn1.cats.vote:9876"
  "peer-protontest.nodeone.network:9871"
  "testnet.proton.eosrio.io:58142"
  "p2p-proton-testnet.cryptotribe.io:9877"
  "p2p-test.turtlebp.online:19878"
  "testxpr-p2p.cindro.net:9874"
  "p2p-testnet-proton.eosarabia.net:9876"
  "testnet-p2p.luminaryvisn.com:9876"
  "p2p-xpr-testnet.a-dex.xyz:9876"
  "proton-p2p-testnet.neftyblocks.com:19876"
  "testnet.rockerone.io:9876"
)

# ---------- Try to fetch the p2p list from API ----------
addresses=()

have_curl=false
have_jq=false
command -v curl >/dev/null 2>&1 && have_curl=true
command -v jq   >/dev/null 2>&1 && have_jq=true

if $have_curl && $have_jq; then
  api_list=$(curl -sS --max-time 10 "$API_URL" \
    | jq -r '.[] | select(.type=="p2p" and .status=="active") | .url' 2>/dev/null)

  if [[ -n "$api_list" ]]; then
    declare -A seen
    while IFS= read -r line; do
      norm="${line#p2p://}"
      if [[ -n "$norm" && -z "${seen[$norm]}" ]]; then
        addresses+=("$norm")
        seen[$norm]=1
      fi
    done <<< "$api_list"
  fi
else
  echo "Warning: 'curl' and/or 'jq' not found. Using fallback list."
fi

# If API returned nothing, use fallback
if [[ ${#addresses[@]} -eq 0 ]]; then
  echo "API returned no usable nodes (or request failed). Using fallback list."
  addresses=("${fallback_addresses[@]}")
else
  echo "Loaded ${#addresses[@]} P2P nodes from API."
fi

# ---------- Check availability and measure latency ----------
declare -A latencies

for address in "${addresses[@]}"; do
  host="${address%%:*}"
  ping_output=$(ping -c 1 -W 2 "$host" 2>/dev/null)

  if [[ $? -eq 0 ]]; then
    latency=$(echo "$ping_output" | grep -oE 'time=[0-9.]+' | cut -d= -f2)
    if [[ -n "$latency" ]]; then
      latencies["$address"]=$latency
    else
      echo "Could not parse latency for: $address"
    fi
  else
    echo "P2P Node unavailable: $address"
  fi
done

# ---------- Save and display result ----------
output_file="$script_dir/available_nodes.txt"
> "$output_file"

for address in $(for key in "${!latencies[@]}"; do echo "${latencies[$key]} $key"; done | sort -n | awk '{print $2}'); do
  latency=${latencies[$address]}
  {
    echo "#(latency: $latency ms)"
    echo "p2p-peer-address = $address"
  } >> "$output_file"
done

if [[ -s "$output_file" ]]; then
  cat "$output_file"
else
  echo "No available P2P nodes detected."
fi

