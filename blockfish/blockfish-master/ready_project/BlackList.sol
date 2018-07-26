pragma solidity ^0.4.18;

contract Blacklist {
    struct member {
        address memberAddress;
        bytes32 phoneNumber;
        uint tokensBought;
    }
   
    struct blacklist {
        bytes32 phoneNumber;
        uint registered;
        uint count;
        string latitude;
        string longitude;
        string platform;
    }

    mapping (address => member) public memberInfo;

    mapping (bytes32 => blacklist) public blacklistInfo;
    bytes32[] phoneNumbers;

    uint public totalTokens;
    uint public balanceTokens;
    uint public tokenPrice;

    function Blacklist(uint tokens, uint pricePerToken) public {
        totalTokens = tokens;
        balanceTokens = tokens;
        tokenPrice = pricePerToken;
    }

    function addList(bytes32 number) public {
        if (blacklistInfo[number].registered == 0) {
            phoneNumbers.push(number);
        }

        blacklistInfo[number].phoneNumber = number;
        blacklistInfo[number].count += 1;
    }

    function buy() payable public returns (uint) {
        uint tokensToBuy = msg.value / tokenPrice;
        require(tokensToBuy <= balanceTokens);
        memberInfo[msg.sender].memberAddress = msg.sender;
        memberInfo[msg.sender].tokensBought += tokensToBuy;
        balanceTokens -= tokensToBuy;
        return tokensToBuy;
    }

    function tokenSold() view public returns (uint) {
        return totalTokens - balanceTokens;
    }

    function transferTo(address account) public {
        address myAddress = this;
        account.transfer(myAddress.balance);
    }

    function getBlacklist(bytes32 number) view public returns (bytes32, uint, string, string, string) {
        return (blacklistInfo[number].phoneNumber, 
            blacklistInfo[number].count, 
            blacklistInfo[number].latitude,
            blacklistInfo[number].longitude,
            blacklistInfo[number].platform);
    }
}