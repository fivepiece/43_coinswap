#!/bin/bash

# TX0 :
# A0 -> [ A1 && C0 ]

TX0_inpoint=( "${TXC_A0_txid}" "0" )
TX0_in="$( tx_mkin_serialize ${TX0_inpoint[@]} $((2**32-1)) "0x${spk_A0_hex}" )"

TX0_out="$( tx_mkout_serialize "10.008" "0x${spk_2_A1C0_2_hex}" p2sh )"

TX0_uns="$( tx_build 1 "" "${TX0_in}" "${TX0_out}" 0 | cleanhex )"
TX0_mid="${TX0_uns}01000000"
TX0_sha256="$( sha256 ${TX0_mid} )"

TX0_sig_A0="$( signder "${A0_hex}" "${TX0_sha256}" | cleanhex )"

TX0_in_sig="$( tx_mkin_serialize ${TX0_inpoint[@]} $((2**32-1)) "@${TX0_sig_A0} @${A0_pub}" )"

TX0_fin="$( tx_build 1 "" "${TX0_in_sig}" "${TX0_out}" 0 | cleanhex )"
TX0_txid="$( hash256 ${TX0_fin} | revbytes )"

echo "[" > ${Alice_home}/tx0/TX0_credit.json
mkjson_credit "${TX0_txid}" '0' "$(spk_pay2shash "0x${spk_2_A1C0_2_hex}")" '10.008' "0x${spk_2_A1C0_2_hex}" >> ${Alice_home}/tx0/TX0_credit.json
echo "]" >> ${Alice_home}/tx0/TX0_credit.json

source ${Alice_home}/tx2/tx2.sh
source ${Alice_home}/tx4/tx4.sh
