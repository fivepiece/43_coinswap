#!/bin/bash

# TX9 :
# [ ! (H(X) && A5) || (L1 && C5) ] -> [ C1 ] :

TX9_inpoint=( "${TX3_txid}" "0" )
TX9_in="$( tx_mkin_serialize ${TX9_inpoint[@]} "${L1_C5}" "0x${spk_HXA5_L1C5_hex}" )"

TX9_out="$( tx_mkout_serialize "10.007" "$(spk_pay2pkhash $(key_pub2addr ${C1_pub}))" )"

TX9_uns="$( tx_build 2 "" "${TX9_in}" "${TX9_out}" 0 | tr -d ' \n' )"
TX9_mid="${TX9_uns}01000000"
TX9_sha256="$( sha256 ${TX9_mid} )"
TX9_z="$( hash256 ${TX9_mid} )"

TX9_sig_C5="$( signder "${C5_hex}" "${TX9_sha256}" "${TX9_z}" | tr -d ' \n' )"

TX9_in_sig="$( tx_mkin_serialize ${TX9_inpoint[@]} "${L1_C5}" "@${TX9_sig_C5} 0 @${spk_HXA5_L1C5_hex}" )"

TX9_fin="$( tx_build 2 "" "${TX9_in_sig}" "${TX9_out}" 0 | tr -d ' \n' )"
TX9_txid="$( hash256 ${TX9_fin} | revbytes )"

echo "[" > ${Carol_home}/tx9/TX9_credit.json
mkjson_credit ${TX9_inpoint[@]} "$(spk_pay2pkhash $(key_pub2addr ${C1_pub}))" '10.007' >> ${Carol_home}/tx9/TX9_credit.json
echo "]" >> ${Carol_home}/tx9/TX9_credit.json
