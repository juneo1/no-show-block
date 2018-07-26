web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
web3.eth.accounts

// code = fs.readFileSync('Voting.sol').toString()
// solc = require('solc')
// compiledCode = solc.compile(code)

abi = JSON.parse('[{"constant":true,"inputs":[{"name":"candidate","type":"bytes32"}],"name":"totalVotesFor","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"candidate","type":"bytes32"}],"name":"validCandidate","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"votesReceived","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"candidateList","outputs":[{"name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"candidate","type":"bytes32"}],"name":"voteForCandidate","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"candidateNames","type":"bytes32[]"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]')
VotingContract = web3.eth.contract(abi);
// byteCode = compiledCode.contracts[':Voting'].bytecode
// deployedContract = VotingContract.new(['Rama','Nick','Jose'],{data: byteCode, from: web3.eth.accounts[0], gas: 4700000})
// deployedContract.address

contractInstance = VotingContract.at('0x8e2f693af6eb2b1753d219d37067de969e5665a0');
candidates = {"Rama": "candidate-1", "Nick": "candidate-2", "Jose": "candidate-3"}

function voteForCandidate(candidate) {
 candidateName = $("#candidate").val();
 try {
  contractInstance.voteForCandidate(candidateName, {from: web3.eth.accounts[0]}, function() {
   let div_id = candidates[candidateName];
   $("#"+div_id).html(contractInstance.totalVotesFor.call(candidateName).toString());
  });
 } catch (err) {
 }
}

$(document).ready(function() {
 candidateNames = Object.keys(candidates);
 for (var i = 0; i < candidateNames.length; i++) {
  let name = candidateNames[i];
  let val = contractInstance.totalVotesFor.call(name).toString()
  $("#"+candidates[name]).html(val);
 }
});
