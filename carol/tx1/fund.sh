#!/bin/bash

# C3 :

spk_C3_scr=( $( spk_pay2pkhash $(key_pub2addr ${C3_pub}) ) )
spk_C3_hex="$( script_serialize "${spk_C3_scr[*]}" )"

TXCnew_C3_out="$( tx_mkout_serialize '10.009' "0x${spk_C3_hex}" )" 
TXCnew_C3="$( tx_build 1 "" "" ${TXCnew_C3_out} 0 | cleanhex )"
TXCfund_C3="$( ${clientname}-cli fundrawtransaction ${TXCnew_C3} '{"changePosition":1}' | grep -o "[0-f]\{10,\}" )"
TXC_C3="$( ${clientname}-cli signrawtransaction ${TXCfund_C3} | grep -o "[0-f]\{10,\}" )"
TXC_C3_txid="$( hash256 ${TXC_C3} | revbytes )"

echo "[" > ${Carol_home}/tx1/TXC_C3.json
mkjson_credit ${TXC_C3_txid} 0 "0x${spk_C3_hex}" '10.009' >> ${Carol_home}/tx1/TXC_C3.json
echo "]" >> ${Carol_home}/tx1/TXC_C3.json

source ${Carol_home}/tx1/tx1.sh
