// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {FiatTokenV2Storage, SafeMath} from "./USDC_Storage.sol";

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract USDC_Upgrade is FiatTokenV2Storage {
    using SafeMath for uint256;
    mapping(address => bool) public allowlist;

    function addToAllowlist(address user) external {
        require(!allowlist[user], "User is already in the allowlist!");
        allowlist[user] = true;
    }

    function removeFromAllowList(address user) external {
        require(allowlist[user], "User is no in the allowlist!");
        allowlist[user] = false;
    }

    function mint(uint256 _amount) public {
        require(allowlist[msg.sender], "Caller not in allowlist");
        totalSupply_ = totalSupply_.add(_amount);
        balances[msg.sender] = balances[msg.sender].add(_amount);
    }

    function version() external view returns (string memory) {
        return "3";
    }
}
