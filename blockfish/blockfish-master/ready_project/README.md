# 블록체인에 기반한 예약신용평가 dAPP

## 개요

예약고객 중 노쇼(No-show) 고객에 대하여 해당 정보를 블록체인에 블랙리스트로 등록하여 추후 예약시에 신용평가요소로 사용하며, 우수 고객에 대해서는 화이트리스트에 등록하고 토큰을 제공하여 보상

## 목적(내용) 및 기대효과

사회적 문제인 노쇼(No-show) 고객에 대하여 정보등록을 통해 평가요소로 활용하여 시간적, 금전적 손실을 사전에 방지하며 , 정상적인 고객에 대해서는 토큰을 제공하여 혜택을 부여함으로써 올바른 예약문화를 조성할 수 있다. *토큰에 대한 내용은 피드백 필요*

## Spec

### 블록체인에 블랙리스트 대상 추가

- 전화번호 // 나중에는 해시값으로 들어가야하나 지금은 그냥 전화번호
- 카운트 (블랙리스트 누적 횟수)
- 예약 플랫폼 // 포잉, 데일리 호텔, 야놀자 등등, 마찬가지로 데이터 분석을 위해
- 식당 또는 예약 장소의 좌표 (latitude, longitude) // 추후 데이터 분석을 위해
- 또 들어갈게 있을까요? // 식당(예약 장소) 정보나 식당(예약 장소) 종류(한식, 중식 등)

### 블록체인에 화이트리스트 대상 추가

- 전화번호 // 나중에는 해시값으로 들어가야하나 지금은 그냥 전화번호
- 카운트 (화이트리스트 누적 횟수)
- 예약 플랫폼 // 포잉, 데일리 호텔, 야놀자 등등, 마찬가지로 데이터 분석을 위해
- 식당 또는 예약 장소의 좌표 (latitude, longitude) // 추후 데이터 분석을 위해

### 토큰 거래

- 기본적으로 토큰 사고 팔기 가능
- 토큰을 사면 본인의 블랙 리스트 카운트를 제거 가능
- 예를들어, 1000000, 100만 토큰을 발행하고 1토큰에 0.01 ETH 로 지정하여 1 토큰으로 1 블랙 카운트를 제거할 수 있도록 한다.
- 토큰을 다른 가맹점에서 포인트처럼 사용하여 할인혜택 부여

*위 구현을 위해 Voting.sol 참고 부탁드립니다!*

### UI 구성

- Single Page로 블랙 리스트 대상 추가 및 토큰 거래 가능
- 전화번호 검색, Table UI
- 나의 토큰 잔액 확인 및 토큰 거래 내역

## 개발 스택

### Frontend

- HTML, CSS, JS(React) // 제가 jQuery 보다 이게 편합니다..

### BlockChain (Back)

- Solidity
- Remix, Truffle 등으로 컴파일

## 목표 및 추후 계획

- 개발 환경에서 개발 후 ropsten 테스트넷에 배포 (웹 브라우저에 metamask 가 있으면 사용 가능)
- 레거시 시스템과 연동 가능한 API 제공
- 쌓인 데이터를 활용해서, 블랙 리스트가 많은 지역 데이터 분석 및 시각화
- 식당 뿐만 아니라 다양한 예약 시스템으로 확장
- ICO 등 부자되기(?)