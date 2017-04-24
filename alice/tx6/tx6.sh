#/bin/bash

# TX6 :
# [ ! (H(X) && C2) || (L0 && A2) ] -> [ A4 ] :

TX6_inpoint=( "${TX2_txid}" "0" )
TX6_in="$( tx_mkin_serialize ${TX6_inpoint[@]} "${TX6_seq}" "0x${spk_HXC2_L0A2_hex}" )"

TX6_out="$( tx_mkout_serialize "10.007" "$(spk_pay2pkhash $(key_pub2addr ${A4_pub}))" )"

TX6_uns="$( tx_build 2 "" "${TX6_in}" "${TX6_out}" "${TX6_nlt}" | cleanhex )"
TX6_mid="${TX6_uns}01000000"
TX6_sha256="$( sha256 ${TX6_mid} )"

TX6_sig_A2="$( signder "${A2_hex}" "${TX6_sha256}" | cleanhex )"

TX6_in_sig="$( tx_mkin_serialize ${TX6_inpoint[@]} "${TX6_seq}" "@${TX6_sig_A2} 0 @${spk_HXC2_L0A2_hex}" )"

TX6_fin="$( tx_build 2 "" "${TX6_in_sig}" "${TX6_out}" "${TX6_nlt}" | cleanhex )"
TX6_txid="$( hash256 ${TX6_fin} | revbytes )"

echo "[" > ${Alice_home}/tx6/TX6_credit.json
mkjson_credit ${TX6_inpoint[@]} "$(spk_pay2pkhash $(key_pub2addr ${A4_pub}))" '10.006' >> ${Alice_home}/tx6/TX6_credit.json
echo "]" >> ${Alice_home}/tx6/TX6_credit.json
