pragma solidity ^0.4.18; // 코드를 컴파일할 컴파일러의 버전을 명시합니다

contract Voting {
    // 맵핑(mapping)은 연관 배열 또는 해시와 같습니다. 
    // 맵핑은 bytes32 유형으로 저장된 후보의 이름과, 부호없는 정수형으로 저장된 해당 후보의 득표 수를 연관시킵니다
    mapping (bytes32 => uint8) public votesReceived;
    // 대부분의 프로그래밍 언어는 votesRecieved.keys를 사용하여 모든 후보의 이름을 얻을 수 있습니다. 
    // 그러나 솔리디티에는 이러한 메소드가 없으므로, 각각의 후보를 별도로 관리해야 합니다.
    bytes32[] public candidateList;

    function Voting(bytes32[] candidateNames) public {
        candidateList = candidateNames;
    }

    // votesReceived[key]는 기본적으로 0의 값을 가지므로, 이를 명시적으로 0으로 초기화하지 않고도 값을 0부터 증가시킬 수 있습니다
    function totalVotesFor(bytes32 candidate) view public returns (uint8) {
        require(validCandidate(candidate));
        return votesReceived[candidate];
    }

    function voteForCandidate(bytes32 candidate) public {
        require(validCandidate(candidate));
        votesReceived[candidate] += 1;
    }

    function validCandidate(bytes32 candidate) view public returns (bool) {
        for(uint i = 0;i < candidateList.length; i++) {
            if (candidateList[i] == candidate) {
                return true;
            }
        }
        return false;
    }
}
 