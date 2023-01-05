// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./Token.sol";
import "./Team.sol";

contract Ballot is Team {
    struct poll {
        uint number;
        string title;
        uint token;
    }
    uint pollNum;
    mapping(uint => poll) Polls;
    uint tokenSum;

    function setPoll(string memory _title) public {
        Polls[pollNum+1] = poll(pollNum+1, _title, 0);
        pollNum+=1;
    }

    function setToken(uint _num, uint _tpe) public {
        Polls[_num].token = _tpe;
        tokenSum = tokenSum - _tpe;
    }

    function getPoll(uint _num) public view returns(uint, string memory, uint) {
        return (Polls[_num].number, Polls[_num].title, Polls[_num].token);
    }

    address leader;

    constructor(string memory _subject, uint _token, string memory _name) public Team(_subject, _token, _name){
        MT = new MyToken(_token);
        tokenSum = MT.getTotalSupply();
        leader = msg.sender;
    }

    function getTotal() public view returns(uint) {
        return MT.getTotalSupply();
    }

    function getUserToken() public view returns(uint) {
        return Team.Users[msg.sender].token;
    }

    function setTeam(string memory _teamName) public {
        Teams[teamNum+1] = team(subject, teamNum+1, _teamName, teamMember, pollNum, MT.getTotalSupply());
        teamNum+=1;
    }

    mapping(address => uint) voting;

    function vote(uint _token, address _addr) public returns(uint) {
        voting[_addr] += _token;
        Team.Users[msg.sender].token -= _token;
        return Team.Users[msg.sender].token;
    }

    function getVote(address _addr) public view returns(uint) {
        return voting[_addr];
    }

    address ranker = leader;

    function ranking() public returns(address, address, address, address, address) {
        for(uint i; i<Team.teamMember.length-1; i++) {
            for(uint j=1; j<Team.teamMember.length; j++) {
                if(voting[Team.teamMember[i]] < voting[Team.teamMember[j]]) {
                    (Team.teamMember[i], Team.teamMember[j]) = (Team.teamMember[j], Team.teamMember[i]);
                }
            }
        }

        return (Team.teamMember[0], Team.teamMember[1], Team.teamMember[2], Team.teamMember[3], Team.teamMember[4]);

        // Team.teamMember[i]
    }

    function what() public view returns(address, address, address, address, address) {
        return (Team.teamMember[0], Team.teamMember[1], Team.teamMember[2], Team.teamMember[3], Team.teamMember[4]);
    }
}