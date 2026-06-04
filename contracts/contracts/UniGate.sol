// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
// UniGate — USDC-gated whitelist access
contract UniGate {
    address public owner;
    uint256 public joinFee = 0.05 ether;
    mapping(address => bool)    public members;
    mapping(address => uint256) public joinedAt;
    uint256 public memberCount;
    event Joined(address indexed member, uint256 feePaid);
    event Removed(address indexed member);
    constructor() { owner = msg.sender; members[owner] = true; memberCount = 1; joinedAt[owner] = block.timestamp; }
    modifier onlyOwner() { require(msg.sender == owner, "Not owner"); _; }
    function join() external payable {
        require(msg.value >= joinFee, "Fee too low");
        require(!members[msg.sender], "Already member");
        members[msg.sender] = true;
        joinedAt[msg.sender] = block.timestamp;
        memberCount++;
        emit Joined(msg.sender, msg.value);
    }
    function remove(address user) external onlyOwner {
        require(members[user] && user != owner, "Cannot remove");
        members[user] = false;
        memberCount--;
        emit Removed(user);
    }
    function isMember(address user) external view returns (bool) { return members[user]; }
    function setFee(uint256 fee) external onlyOwner { joinFee = fee; }
    function withdraw() external onlyOwner { payable(owner).transfer(address(this).balance); }
}