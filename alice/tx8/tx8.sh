#!/bin/bash

# TX8 :
# [ (H(X) && A5) || ! (L1 && C5) ] -> [ A4 ] :

TX8_inpoint=( "${TX3_txid}" "0" )
TX8_in="$( tx_mkin_serialize ${TX8_inpoint[@]} "$((2**32-1))" "0x${spk_HXA5_L1C5_hex}" )"

TX8_out="$( tx_mkout_serialize "10.007" "$(spk_pay2pkhash $(key_pub2addr ${A4_pub}))" )"

TX8_uns="$( tx_build 1 "" "${TX8_in}" "${TX8_out}" 0 | cleanhex )"
TX8_mid="${TX8_uns}01000000"
TX8_sha256="$( sha256 ${TX8_mid} )"

TX8_sig_A5="$( signder "${A5_hex}" "${TX8_sha256}" | cleanhex )"

TX8_in_sig="$( tx_mkin_serialize ${TX8_inpoint[@]} "$((2**32-1))" "@${TX8_sig_A5} @${AX_sec} 1 @${spk_HXA5_L1C5_hex}" )"

TX8_fin="$( tx_build 1 "" "${TX8_in_sig}" "${TX8_out}" 0 | cleanhex )"
TX8_txid="$( hash256 ${TX8_fin} | revbytes )"

echo "[" > ${Alice_home}/tx8/TX8_credit.json
mkjson_credit ${TX8_inpoint[@]} "$(spk_pay2pkhash $(key_pub2addr ${A4_pub}))" '10.007' >> ${Alice_home}/tx8/TX8_credit.json
echo "]" >> ${Alice_home}/tx8/TX8_credit.json
