#!/bin/bash

# TX3 :
# [ A3 && C4 ] -> [ (H(X) && A5) || (L1 && C5) ] :

TX3_inpoint=( "${TX1_txid}" "0" )
TX3_in="$( tx_mkin_serialize ${TX3_inpoint[@]} $((2**32-1)) "0x${spk_2_A3C4_2_hex}" )"

TX3_out="$( tx_mkout_serialize "10.007" "0x${spk_HXA5_L1C5_hex}" p2sh )"

TX3_uns="$( tx_build 1 "" "${TX3_in}" "${TX3_out}" 0 | cleanhex )"
TX3_mid="${TX3_uns}01000000"
TX3_sha256="$( sha256 ${TX3_mid} )"
TX3_z="$( hash256 ${TX3_mid} )"

TX3_sig_A3="$( signder "${A3_hex}" "${TX3_sha256}" "${TX3_z}" | cleanhex )"

TX3_sig_C4="$( signder "${C4_hex}" "${TX3_sha256}" "${TX3_z}" | cleanhex )"

TX3_in_sig="$( tx_mkin_serialize ${TX3_inpoint[@]} "$((2**32-1))" "0 @${TX3_sig_A3} @${TX3_sig_C4} @${spk_2_A3C4_2_hex}" )"

TX3_fin="$( tx_build 1 "" "${TX3_in_sig}" "${TX3_out}" 0 | cleanhex )"
TX3_txid="$( hash256 ${TX3_fin} | revbytes )"

echo "[" > ${Carol_home}/tx3/TX3_credit.json
mkjson_credit ${TX3_txid} 0 "$(spk_pay2shash "0x${spk_HXA5_L1C5_hex}")" '10.007' "0x${spk_HXA5_L1C5_hex}" >> ${Carol_home}/tx3/TX3_credit.json
echo "]" >> ${Carol_home}/tx3/TX3_credit.json

source ${Alice_home}/tx8/tx8.sh
source ${Carol_home}/tx9/tx9.sh
