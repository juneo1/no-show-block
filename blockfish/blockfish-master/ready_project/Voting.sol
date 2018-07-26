pragma solidity ^0.4.18;

contract Voting {
    // 개별 유권자 정보: 솔리디티에는 연관된 데이터 그룹을 하나의 개체로 저장하는 데 사용할 수 있는 구조체 struct라는 데이터 유형이 있습니다. 
    // 이것은 유권자 정보를 저장하는 방식으로 최적입니다. 
    // (구조체struct에 대해 들어보지 못했다면, 속성을 가진 객체지향 클래스와 그 속성에 액세스하는 get/set 메소드 정도로 간주하면 됩니다). 
    // 구조체를 사용하여 유권자의 주소, 구입한 총 토큰 및 각 후보자를 투표하는 데 사용된 토큰을 저장합니다.
    struct voter {
        address voterAddress;
        uint tokensBought;
        uint[] tokensUsedPerCandidate;
    }

    // 유권자 정보 조회: 유권자의 계정 주소가 표시된 유권자 정보를 표시해야 할 때 필요합니다. voterInfo 필드를 사용하여 이 정보를 저장합니다.
    mapping (address => voter) public voterInfo;

    // 토큰: 토큰의 총 수량, 총 토큰 및 각 토큰의 가격을 저장하는 계약 변수입니다. 
    mapping (bytes32 => uint) public votesReceived;

    bytes32[] public candidateList;

    uint public totalTokens;
    uint public balanceTokens;
    uint public tokenPrice;

    // 이전 튜토리얼에서와 마찬가지로 생성자를 초기화합니다. 누구든지 구입할 수 있는 토큰을 발행할 것이므로, 판매중인 총 토큰과 각 토큰의 가격을 후보자와 함께 설정해야 합니다. 
    function Voting(uint tokens, uint pricePerToken, bytes32[] candidateNames) public {
        candidateList = candidateNames;
        totalTokens = tokens;
        balanceTokens = tokens;
        tokenPrice = pricePerToken;
    }

    // buy 함수는 토큰을 구입하는 데 사용됩니다. 여기에서 'payable' 키워드에 주목해야 합니다. 이 키워드를 함수에 추가하기만 하면, 이 컨트랙트는 누구든지 이 함수를 호출한 사람으로부터 이더를 받을 수 있게 됩니다.
    // 이 컨트랙트의 buy 메소드를 호출할 때는, 토큰 구매에 사용할 총 이더 수량을 인수로 설정해야 합니다. 
    // 이더 수량에 해당하는 변수는 msg.value입니다. 이더 수량과 토큰의 가격에 따라 구매자가 가져갈 토큰의 총 개수를 계산하고 그만큼의 토큰을 구매자에게 할당하게 됩니다. 
    // 구매자의 주소에 해당하는 것은 msg.sender입니다.
    function buy() payable public returns (uint) {
        uint tokensToBuy = msg.value / tokenPrice;
        require(tokensToBuy <= balanceTokens);
        voterInfo[msg.sender].voterAddress = msg.sender;
        voterInfo[msg.sender].tokensBought += tokensToBuy;
        balanceTokens -= tokensToBuy;
        return tokensToBuy;
    }

    
    function totalVotesFor(bytes32 candidate) view public returns (uint) {
        return votesReceived[candidate];
    }

    // 후보자의 득표 수를 증가시킬 뿐 아니라, 표를 던진 유권자의 정보(유권자의 주소, 해당 유권자가 던진 표의 수, 해당 유권자가 투표한 후보자의 정보 등)도 함께 추적하기 때문입니다. 
    function voteForCandidate(bytes32 candidate, uint votesInTokens) public {
        uint index = indexOfCandidate(candidate);
        require(index != uint(-1));

        if(voterInfo[msg.sender].tokensUsedPerCandidate.length == 0) {
            for (uint i = 0; i < candidateList.length; i++) {
                voterInfo[msg.sender].tokensUsedPerCandidate.push(0);
            }
        }

        uint availableTokens = voterInfo[msg.sender].tokensBought - totalTokenUsed(voterInfo[msg.sender].tokensUsedPerCandidate);
        require(availableTokens >= votesInTokens);

        votesReceived[candidate] += votesInTokens;
        voterInfo[msg.sender].tokensUsedPerCandidate[index] += votesInTokens;
    }

    function totalTokenUsed(uint[] _tokenUsedPerCandidate) private pure returns (uint) {
        uint totalUsedTokens = 0;
        for (uint i = 0; i < _tokenUsedPerCandidate.length; i++) {
            totalUsedTokens += _tokenUsedPerCandidate[i];
        }
        return totalUsedTokens;
    }
    
    function indexOfCandidate(bytes32 candidate) view public returns (uint) {
        for (uint i = 0; i < candidateList.length; i++) {
            if(candidateList[i] == candidate) {
                return i;
            }
        }
        return uint(-1);
    }

    function tokenSold() view public returns (uint) {
        return totalTokens - balanceTokens;
    }

    function voterDetails(address user) view public returns (uint, uint[]) {
        return (voterInfo[user].tokensBought, voterInfo[user].tokensUsedPerCandidate);
    }

    // 사용자가 buy 메소드를 호출하고 이더를 보내 토큰을 구매하면, 여기에 쓰인 이더는 어디로 가게 될까요? 정답은 바로 스마트 컨트랙트입니다. 
    // 모든 스마트 계약은 자체적으로 계정을 가지고 있고 계정에 돈을 보관합니다. 여기에 transferTo 메소드를 정의해서, 모든 돈을 지정된 계정으로 전송할 수 있습니다. 
    // 메소드를 이렇게 정의하면, 누구나 이 메소드를 호출해서 이더를 계정에 전송할 수 있고, 이는 문제의 소지가 될 수 있습니다. 
     // 그러므로 돈을 낼 수 있는 계정에 대한 제한을 추가하는 것이 좋습니다.
    function transferTo(address account) public {
        address myAddress = this;
        account.transfer(myAddress.balance);
    }

    function allCandidates() view public returns (bytes32[]) {
        return candidateList;
    }

    // tokensSold, voterDetails 와 같은 메소드에는 조정자 view가 있습니다. 
    // 이러한 메소드는 블록체인의 상태를 변경하지 않는 메소드입니다. 즉, 읽기 전용이며, 실행시에도 가스를 전혀 소모하지 않습니다.  
}
