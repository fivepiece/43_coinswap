#!/bin/bash

# TX4 :
# [ A1 && C0 ] -> [ C1 ]

TX4_inpoint=( "${TX0_txid}" "0" )
# tx_mkin_serialize ${TX4_inpoint[@]} "$((2**32-1))" "0x${spk_2_A1C0_2_hex}"
TX4_in="${TX2_in}"

TX4_out="$( tx_mkout_serialize "10.007" "$(spk_pay2pkhash $(key_pub2addr ${C1_pub}))" )"

TX4_uns="$( tx_build 1 "" "${TX4_in}" "${TX4_out}" 0 | cleanhex )"
TX4_mid="${TX4_uns}01000000"
TX4_sha256="$( sha256 ${TX4_mid} )"

TX4_sig_A1="$( signder "${A1_hex}" "${TX4_sha256}" | cleanhex )"

TX4_sig_C0="$( signder "${C0_hex}" "${TX4_sha256}" | cleanhex )"

TX4_in_sig="$( tx_mkin_serialize ${TX4_inpoint[@]} "$((2**32-1))" "0 @${TX4_sig_A1} @${TX4_sig_C0} @${spk_2_A1C0_2_hex}" )"

TX4_fin="$( tx_build 1 "" "${TX4_in_sig}" "${TX4_out}" 0 | cleanhex )"
TX4_txid="$( hash256 ${TX4_fin} | revbytes )"

echo "[" > ${Alice_home}/tx4/TX4_credit.json
mkjson_credit ${TX4_txid} 0 "$(spk_pay2pkhash $(key_pub2addr ${C1_pub}))" '10.007' >> ${Alice_home}/tx4/TX4_credit.json
echo "]" >> ${Alice_home}/tx4/TX4_credit.json
