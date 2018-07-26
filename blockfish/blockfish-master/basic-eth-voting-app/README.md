# 기본 투표 예제

## written by [@Flowkater](https://github.com/flowkater)

- 예제에서는 로컬(fake?) 네트워크인 ganache 를 이용 (geth에서 했던 복잡한 설정을 생략하고 바로 dapp 개발)
- node 콘솔에서 webjs 컴파일 진행

## 환결설정 관련

- [리눅스 환경 설치법](https://kr.zastrin.com/courses/4/lessons/3-2)
- [맥OS 환결 설치법](https://kr.zastrin.com/courses/4/lessons/3-3)
- [윈도우 환경 설치법](https://kr.zastrin.com/courses/4/lessons/3-4)

## Yarn 또는 NPM 설치

```terminal
npm install ganache-cli web3@0.20.1 solc
node_modules/.bin/ganache-cli
```

```terminal
node_modules/.bin/ganache-cli
```

## 프로젝트 설명

해당 예제 프로젝트에서는 트러플이나 remix 등으로 자동으로 컴파일해서 실행하는게 아니고 로컬에서 직접 노드 콘솔을 이용해서 실행합니다. 거기서 나온 바이트코드, abi 인터페이스를 index.js 에서 하드코딩해서 진행되는 예제입니다.

```javascript
In the node console
> Web3 = require('web3')
> web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
> web3.eth.accounts
['0x5c252a0c0475f9711b56ab160a1999729eccce97'
'0x353d310bed379b2d1df3b727645e200997016ba3'
'0xa3ddc09b5e49d654a43e161cae3f865261cabd23'
'0xa8a188c6d97ec8cf905cc1dd1cd318e887249ec5'
'0xc0aa5f8b79db71335dacc7cd116f357d7ecd2798'
'0xda695959ff85f0581ca924e549567390a0034058'
'0xd4ee63452555a87048dcfe2a039208d113323790'
'0xc60c8a7b752d38e35e0359e25a2e0f6692b10d14'
'0xba7ec95286334e8634e89760fab8d2ec1226bf42'
'0x208e02303fe29be3698732e92ca32b88d80a2d36']


> code = fs.readFileSync('Voting.sol').toString()
> solc = require('solc')
> compiledCode = solc.compile(code)

> abiDefinition = JSON.parse(compiledCode.contracts[':Voting'].interface) // 요 부분
> VotingContract = web3.eth.contract(abiDefinition)
> byteCode = compiledCode.contracts[':Voting'].bytecode
> deployedContract = VotingContract.new(['Rama','Nick','Jose'],{data: byteCode, from: web3.eth.accounts[0], gas: 4700000})
> deployedContract.address 
'0x0396d2b97871144f75ba9a9c8ae12bf6c019f610' <- Your address will be different // 요 부분
> contractInstance = VotingContract.at(deployedContract.address)
```

위 코드를 노드 콘솔에서 돌릴 수 있는데, index.js 에서

```javascript
// 이 부분
abi = JSON.parse('[{"constant":false,"inputs":[{"name":"candidate","type":"bytes32"}],"name":"totalVotesFor","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"candidate","type":"bytes32"}],"name":"validCandidate","outputs":..')

// 이 부분
contractInstance = VotingContract.at('0x329f5c190380ebcf640a90d06eb1db2d68503a53');
```

index.js에서 각 코드 각 줄에서 '' string 부분을 본인 로컬 node 콘솔에서 뽑은 abi, contractInstance (deployedContract) 복사해서 붙이면 됨.

```javascript
> abiDefinition = JSON.parse(compiledCode.contracts[':Voting'].interface) // 요 부분
> deployedContract.address 
'0x0396d2b97871144f75ba9a9c8ae12bf6c019f610' <- Your address will be different // 요 부분
```