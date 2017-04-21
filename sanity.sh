#!/bin/bash

partxid()
{
    mastcoin-cli decoderawtransaction "$1" | grep '      "txid' | cut -d'"' -f4 | cleanhex
}

parents=( "${TXC_A0_txid}" "${TXC_C3_txid}" "${TX0_txid}" "${TX1_txid}" "${TX2_txid}" "${TX3_txid}" )

txmap=(   "${TXC_A0_txid}" "${TXC_C3_txid}" "${TX0_txid}" "${TX1_txid}" "${TX0_txid}" "${TX1_txid}" "${TX2_txid}" "${TX2_txid}" "${TX3_txid}" "${TX3_txid}" )
childrn=( "${TX0_fin}"     "${TX1_fin}"     "${TX2_fin}"  "${TX3_fin}"  "${TX4_fin}"  "${TX5_fin}"  "${TX6_fin}"  "${TX7_fin}"  "${TX8_fin}"  "${TX9_fin}" )
declare -A branches
branches=( \
    [${childrn[0]}]="${parents[0]}" \
    [${childrn[1]}]="${parents[1]}" \
    [${childrn[2]}]="${parents[2]}" \
    [${childrn[3]}]="${parents[3]}" \
    [${childrn[4]}]="${parents[2]}" \
    [${childrn[5]}]="${parents[3]}" \
    [${childrn[6]}]="${parents[4]}" \
    [${childrn[7]}]="${parents[4]}" \
    [${childrn[8]}]="${parents[5]}" \
    [${childrn[9]}]="${parents[5]}" )

#echo "TX0"
#child="$( partxid "${TX0_fin}" 2>/dev/null )"
#[[ ${parents[0]} == ${child} ]] && echo "${parents[0]} -> $(hash256 ${childrn[0]} | revbytes)"

#echo "TX1"
#child="$( partxid "${TX1_fin}" 2>/dev/null )"
#[[ ${parents[1]} == ${child} ]] && echo "${parents[1]} -> $(hash256 ${childrn[1]} | revbytes)"

for (( i=0; i<${#childrn[@]}; i++ )); do
    echo "TX$i"
    parent="$( partxid ${childrn[$i]} 2>/dev/null )"
    [[ ${branches[${childrn[$i]}]} == ${parent} ]] && echo "${txmap[$i]} -> $(hash256 ${childrn[$i]} | revbytes)"
done
