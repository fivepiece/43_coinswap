#!/bin/bash

set_network_versions mastcoin
source $HOME/Documents/testnet-keys/41_tests/run_test.sh
source $HOME/Documents/testnet-keys/42_bighash/signthis.sh

Alice_home="$HOME/Documents/testnet-keys/43_coinswap/alice"
Carol_home="$HOME/Documents/testnet-keys/43_coinswap/carol"

source ${Alice_home}/res/keys
source ${Alice_home}/res/secrets

source ${Carol_home}/res/keys

for i in 0 2 4 6 8; do
    source ${Alice_home}/tx${i}/scripts
done

for i in 1 3 5 7 9; do
    source ${Carol_home}/tx${i}/scripts
done
