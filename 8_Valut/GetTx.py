#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 27 23:28:43 2021

@author: max850701
"""
from web3 import Web3, WebsocketProvider
from web3.middleware import geth_poa_middleware
from ethereum.utils import sha3
import sys
import time
import binascii

# Enter your websocket url on Ethereum Testnet
rpc_test = 'wss://'
web3 = Web3(WebsocketProvider(rpc_test))

# Change the mechanism of POA
# Add this line below, if you're running on Ethereum Testnet
web3.middleware_onion.inject(geth_poa_middleware, layer=0)

# Enter a transaction hash you want to track
tx_hash = '0x'

def get_tx_info(_tx_hash):
    return web3.eth.get_transaction(_tx_hash)


if __name__ == '__main__':
    result = get_tx_info(_tx_hash=tx_hash)
    print(result)