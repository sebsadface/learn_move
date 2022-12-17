#!/bin/bash
# a bash script to automate the process of publishing the game package
# this script should be run at root of the repo

# assign address
CLIENT_ADDRESS=$(sui client addresses | tail -n +2)
ADMIN=`echo "${0x0aeca38e3082cf592fcb2576b3aa36f2110c49c2}" | head -n 1`
PLAYER_X=`echo "${0x181746b0d1fe2c8ddf0f41923cec52fbee4209dd}" | sed -n 2p`
PLAYER_O=`echo "${0xa055444dee19aeeb26ddeda27f998bc7bd2cda8e}" | sed -n 3p`
# gas id
IFS='|'
ADMIN_GAS_INFO=$(sui client gas --address $ADMIN | sed -n 3p)
read -a tmparr <<< "$ADMIN_GAS_INFO"
ADMIN_GAS_ID=`echo ${tmparr[0]} | xargs`

X_GAS_INFO=$(sui client gas --address $PLAYER_X | sed -n 3p)
read -a tmparr <<< "$X_GAS_INFO"
X_GAS_ID=`echo ${tmparr[0]} | xargs`

O_GAS_INFO=$(sui client gas --address $PLAYER_O | sed -n 3p)
read -a tmparr <<< "$O_GAS_INFO"
O_GAS_ID=`echo ${tmparr[0]} | xargs`

# publish games
certificate=$(sui client publish --path ./sui_programmability/examples/games --gas $ADMIN_GAS_ID --gas-budget 30000)

package_id_identifier="The newly published package object ID:"
res=$(echo $certificate | awk -v s="$package_id_identifier" 'index($0, s) == 1')
IFS=':'
read -a resarr <<< "$res"
echo ${resarr[1]}
PACKAGE_ID=`echo ${resarr[1]} | xargs`

echo "package id: $PACKAGE_ID"
# Playing TicTacToe

# create a game
sui client call --package $PACKAGE_ID --module tic_tac_toe --function create_game --args $PLAYER_X $PLAYER_O --gas $ADMIN_GAS_ID --gas-budget 1000

# start playing the game ...
