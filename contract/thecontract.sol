// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract APIConsumer is ChainlinkClient {
    using Chainlink for Chainlink.Request;
    uint256 public games;
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    
    constructor() {
        setPublicChainlinkToken();
        oracle = 0x96A5EF6312ea150346BE4a7819aE76fe57B704F6;
        jobId = "eee80e392a31497f86dc201e6480cfb1";
        fee = 0.1 * 10 ** 18; // (Varies by network and job)
    }

    function requestGamesData() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        request.add("playerId", "90026531");
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    function fulfill(bytes32 _requestId, uint256 _games) public recordChainlinkFulfillment(_requestId)
    {
        games = _games;
    }
}
