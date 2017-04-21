#!/bin/bash

# TX2 : 
# [ A1 && C0 ] -> [ (H(X) && C2) || (L0 && A2) ] :

TX2_inpoint=( "${TX0_txid}" "0" )
TX2_in="$( tx_mkin_serialize ${TX2_inpoint[@]} $((2**32-1)) "0x${spk_2_A1C0_2_hex}" )"

TX2_out="$( tx_mkout_serialize "10.007" "0x${spk_HXC2_L0A2_hex}" p2sh )"

TX2_uns="$( tx_build 1 "" "${TX2_in}" "${TX2_out}" 0 | cleanhex )"
TX2_mid="${TX2_uns}01000000"
TX2_sha256="$( sha256 ${TX2_mid} )"

TX2_sig_A1="$( signder "${A1_hex}" "${TX2_sha256}" | cleanhex )"

TX2_sig_C0="$( signder "${C0_hex}" "${TX2_sha256}" | cleanhex )"

TX2_in_sig="$( tx_mkin_serialize ${TX2_inpoint[@]} "$((2**32-1))" "0 @${TX2_sig_A1} @${TX2_sig_C0} @${spk_2_A1C0_2_hex}" )"

TX2_fin="$( tx_build 1 "" "${TX2_in_sig}" "${TX2_out}" 0 | cleanhex )"
TX2_txid="$( hash256 ${TX2_fin} | revbytes )"

echo "[" > ${Alice_home}/tx2/TX2_credit.json
mkjson_credit ${TX2_txid} 0 "$(spk_pay2shash "0x${spk_HXC2_L0A2_hex}")" '10.007' "0x${spk_HXC2_L0A2_hex}" >> ${Alice_home}/tx2/TX2_credit.json
echo "]" >> ${Alice_home}/tx2/TX2_credit.json

source ${Carol_home}/tx7/tx7.sh
source ${Alice_home}/tx6/tx6.sh
