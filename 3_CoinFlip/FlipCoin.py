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
factor = 57896044618658097711785492504343953926634992332820282019728792003956564819968
target_times = 10

my_address = '0x'
contract_address = '0x'
method = 'flip(bool)'

# Don't save your private key after running this program!
private_key = ''


def calculate_result(block_number):
    # block = web3.eth.get_block('pending')
    # target_block_number = block.number - 1
    # print(target_block_number)
    # print(block_number)
    target_hash = web3.eth.get_block(block_number).hash
    hash_to_decimal = int.from_bytes(target_hash, byteorder='big') 
    # bin(int.from_bytes(b'\x11', byteorder=sys.byteorder)) => '0b10001'
    div_result = hash_to_decimal // factor
    #print(hash_to_decimal)
    #print(factor)
    if div_result == 1:
        return True
    else:
        return False


def send_tx_to_contract(msg_sender, target_contract, target_block_number):
    #data_method = get_method_id(method=method_id)
    nonce = web3.eth.get_transaction_count(msg_sender)
    if calculate_result(block_number=target_block_number) == True:
        data_parameter = '0x1d263f670000000000000000000000000000000000000000000000000000000000000001'
        print(True)
    else:
        data_parameter = '0x1d263f670000000000000000000000000000000000000000000000000000000000000000'
        print(False)
    
    params = {
        'nonce': nonce,
        'from': msg_sender,
        'to': target_contract,
        'value': web3.toWei(0, 'ether'),
        'gas': 210000,
        'maxFeePerGas': web3.toWei(100, 'gwei'),
        'maxPriorityFeePerGas': web3.toWei(50, 'gwei'),
        'data': data_parameter,
        'chainId': 4
    }

    signed_tx = web3.eth.account.sign_transaction(params, private_key=private_key)
    tx_hash = web3.eth.send_raw_transaction(signed_tx.rawTransaction)

    return tx_hash


# def callee_contract_method(contract_address, contract_abi):
#     contract_instance = web3.eth.contract(address=contract_address, abi=contract_abi)
#     contract_instance.functions

def get_method_id(method):
    method_id ='0x' + sha3("%s" % method)[0:4].hex()
    return method_id


if __name__ == '__main__':
    n = 0
    while n <= target_times:
        new_block = web3.eth.get_block('pending').number
        print("==========")
        print(new_block)
        if n == 0:
            old_block = new_block
            n = n + 1

        if old_block == new_block:
            time.sleep(2)
            continue
        else:
            print("第 %s 次" %n)
            result = send_tx_to_contract(msg_sender=my_address,
								target_contract=contract_address,
								target_block_number=new_block-1)
            old_block = new_block
            #print(result)
            n = n + 1
            #time.sleep(30)
    
    #send_tx_to_contract(msg_sender=my_address, target_contract=contract_address)