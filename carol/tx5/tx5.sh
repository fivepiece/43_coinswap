#!/bin/bash

# TX5 : 
# [ A3 && C4 ] -> [ A4 ] :

TX5_inpoint=( "${TX1_txid}" "0" )
# tx_mkin_serialize ${TX5_inpoint[@]} "$((2**32-1))" "0x${spk_2_A3C4_2_hex}"
TX5_in="${TX3_in}"

TX5_out="$( tx_mkout_serialize "10.007" "$(spk_pay2pkhash $(key_pub2addr ${A4_pub}))" )"

TX5_uns="$( tx_build 1 "" "${TX5_in}" "${TX5_out}" 0 | cleanhex )"
TX5_mid="${TX5_uns}01000000"
TX5_sha256="$( sha256 ${TX5_mid} )"

TX5_sig_A3="$( signder "${A3_hex}" "${TX5_sha256}" | cleanhex )"

TX5_sig_C4="$( signder "${C4_hex}" "${TX5_sha256}" | cleanhex )"

TX5_in_sig="$( tx_mkin_serialize ${TX5_inpoint[@]} "$((2**32-1))" "0 @${TX5_sig_A3} @${TX5_sig_C4} @${spk_2_A3C4_2_hex}" )"

TX5_fin="$( tx_build 1 "" "${TX5_in_sig}" "${TX5_out}" 0 | cleanhex )"
TX5_txid="$( hash256 ${TX5_fin} | revbytes )"

echo "[" > ${Carol_home}/tx5/TX5_credit.json
mkjson_credit ${TX5_txid} 0 "$(spk_pay2pkhash $(key_pub2addr ${A4_pub}))" '10.007' >> ${Carol_home}/tx5/TX5_credit.json
echo "]" >> ${Carol_home}/tx5/TX5_credit.json
