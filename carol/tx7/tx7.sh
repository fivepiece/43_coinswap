#!/bin/bash

# TX7 :
# [ (H(X) && C2) || ! (L0 && A2) ] -> [ C1 ] :

TX7_inpoint=( "${TX2_txid}" "0" )
TX7_in="$( tx_mkin_serialize ${TX7_inpoint[@]} "$((2**32-1))" "0x${spk_HXC2_L0A2_hex}" )"

TX7_out="$( tx_mkout_serialize "10.007" "$(spk_pay2pkhash $(key_pub2addr ${C1_pub}))" )"

TX7_uns="$( tx_build 1 "" "${TX7_in}" "${TX7_out}" 0 | tr -d ' \n' )"
TX7_mid="${TX7_uns}01000000"
TX7_sha256="$( sha256 ${TX7_mid} )"
TX7_z="$( hash256 ${TX7_mid} )"

TX7_sig_C2="$( signder "${C2_hex}" "${TX7_sha256}" "${TX7_z}" | tr -d ' \n' )"

TX7_in_sig="$( tx_mkin_serialize ${TX7_inpoint[@]} "$((2**32-1))" "@${TX7_sig_C2} @${AX_sec} 1 @${spk_HXC2_L0A2_hex}" )"

TX7_fin="$( tx_build 1 "" "${TX7_in_sig}" "${TX7_out}" 0 | tr -d ' \n' )"
TX7_txid="$( hash256 ${TX7_fin} | revbytes )"

echo "[" > ${Carol_home}/tx7/TX7_credit.json
mkjson_credit ${TX7_inpoint[@]} "$(spk_pay2pkhash $(key_pub2addr ${C1_pub}))" '10.007' >> ${Carol_home}/tx7/TX7_credit.json
echo "]" >> ${Carol_home}/tx7/TX7_credit.json
