#!/bin/bash

# TX1 :
# C3 -> [ A3 && C4 ]

TX1_inpoint=( "${TXC_C3_txid}" "0" )
TX1_in="$( tx_mkin_serialize ${TX1_inpoint[@]} $((2**32-1)) "0x${spk_C3_hex}" )"

TX1_out="$( tx_mkout_serialize "10.008" "0x${spk_2_A3C4_2_hex}" p2sh )"

TX1_uns="$( tx_build 1 "" "${TX1_in}" "${TX1_out}" 0 | cleanhex )"
TX1_mid="${TX1_uns}01000000"
TX1_sha256="$( sha256 ${TX1_mid} )"

TX1_sig_C3="$( signder "${C3_hex}" "${TX1_sha256}" | cleanhex )"

TX1_in_sig="$( tx_mkin_serialize ${TX1_inpoint[@]} $((2**32-1)) "@${TX1_sig_C3} @${C3_pub}" )"

TX1_fin="$( tx_build 1 "" "${TX1_in_sig}" "${TX1_out}" 0 | cleanhex )"
TX1_txid="$( hash256 ${TX1_fin} | revbytes )"

echo "[" > ${Carol_home}/tx1/TX1_credit.json
mkjson_credit "${TX1_txid}" '0' "$(spk_pay2shash "0x${spk_2_A3C4_2_hex}")" '10.008' "0x${spk_2_A3C4_2_hex}" >> ${Carol_home}/tx1/TX1_credit.json
echo "]" >> ${Carol_home}/tx1/TX1_credit.json

source ${Carol_home}/tx3/tx3.sh
source ${Carol_home}/tx5/tx5.sh
