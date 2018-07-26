pragma solidity ^0.4.18;

contract Blacklist {
	// 블랙리스트 컨트랙트 구성 

	
	// 블랙리스트 투표자 정보 - 주소, 토큰, 플랫폼 넘버, 지역(혹은 좌표), 블랙리스트별 토큰 사용수 
	struct reporter {
		address reporterAddress;
		//uint8 platformNum;
		//string province;
		//uint[] tokenUsedPerBlack;
	}


	struct blacklistInfo {
		string phoneNum;
		uint count;
	}

	struct report {
		address reporterAddr;
		string phoneNum; 
	}


	// 계정 주소를 통한 투표자 정보 저장 (voterInfo)
	mapping (string => blacklist) public blacklist;

    // 토큰: 토큰의 총 수량, 총 토큰 및 각 토큰의 가격을 저장하는 계약 변수입니다. 
    mapping (bytes32 => uint) public votesReceived;


	// 토큰 발행 
	string public constant name = "Blacklist Coin"
	string public constant symbol = "BLC";
	uint public totalTokens;
    uint public balanceTokens;
    uint public tokenPrice;

    // 생성자를 초기화. 투표자 정보를 설정합니다. 
    function Blacklist( ){
    	
    }


    function addList(string phoneNum, Address addr) {
    	blacklist[phoneNum].phoneNum = phoneNum;
    	blacklist[phoneNum].count++;

    	reporter[addr].reporterAddress;
    }

}