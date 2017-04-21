#!/bin/bash

# A0 :

spk_A0_scr=( $( spk_pay2pkhash $(key_pub2addr ${A0_pub}) ) )
spk_A0_hex="$( script_serialize "${spk_A0_scr[*]}" )"

TXCnew_A0_out="$( tx_mkout_serialize '10.009' "0x${spk_A0_hex}" )" 
TXCnew_A0="$( tx_build 1 "" "" ${TXCnew_A0_out} 0 | cleanhex )"
TXCfund_A0="$( ${clientname}-cli fundrawtransaction ${TXCnew_A0} '{"changePosition":1}' | grep -o "[0-f]\{10,\}" )"
TXC_A0="$( ${clientname}-cli signrawtransaction ${TXCfund_A0} | grep -o "[0-f]\{10,\}" )"
TXC_A0_txid="$( hash256 ${TXC_A0} | revbytes )"

echo "[" > ${Alice_home}/tx0/TXC_A0.json
mkjson_credit ${TXC_A0_txid} 0 "0x${spk_A0_hex}" '10.009' >> ${Alice_home}/tx0/TXC_A0.json
echo "]" >> ${Alice_home}/tx0/TXC_A0.json

source ${Alice_home}/tx0/tx0.sh
