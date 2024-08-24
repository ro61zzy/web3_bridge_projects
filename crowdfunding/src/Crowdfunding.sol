// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Crowdfunding {

    uint public noOfCampaigns;

    address public owner;

    struct Campaign {
        string title;
        string description;
        address payable benefactor;
        uint goal;
        uint deadline;
        uint amountRaised;
        bool ended;
    }

    mapping(uint => Campaign) public campaigns;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can access this function!");
        _;
    }

    event CampaignCreated(uint indexed campaignId, string name, uint goal);
    event Donation(uint indexed campaignId, address donor, uint amount);
    event EndedCampaign(uint indexed campaignId, address benefactor, uint amount);

    function WithdrawFromAccount() public payable onlyOwner {
        (bool sent, bytes memory data) = owner.call{value: address(this).balance}("");
        require(sent, "Withdrawal failed");
    }

    function CheckContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function CreateCampaign(string memory _title, string memory _description, address payable _benefactor, uint _goal, uint duration) public {
        require(_goal > 0, "Goal must be greater than 0");

        uint _duration = block.timestamp + duration;

        Campaign memory newCampaign = Campaign({
            title: _title,
            description: _description,
            benefactor: _benefactor,
            goal: _goal,
            deadline: _duration,
            amountRaised: 0,
            ended: false
         });

         noOfCampaigns++;

         campaigns[noOfCampaigns] = newCampaign;

         emit CampaignCreated(noOfCampaigns, _title, _goal);

    }

    function DonateToCampaign(uint campaignId) public payable{
        Campaign storage campaign = campaigns[campaignId];

        require(campaign.deadline > block.timestamp, "Campaign has ended!");

        require(msg.value > 0, "Donation must be greater than 0");

        campaign.amountRaised += msg.value;

        emit Donation(campaignId, msg.sender, msg.value);

    }

    function EndCampaign(uint campaignId) public payable  {

        Campaign storage campaign = campaigns[campaignId];


        require(campaign.deadline < block.timestamp, "Campaign is still on!");

        campaign.ended = true;

        (bool sent, bytes memory data) = campaign.benefactor.call{value: campaign.amountRaised}("");
        require(sent, "Transfaring to Benefactor failed!");

        emit EndedCampaign(campaignId, campaign.benefactor, campaign.amountRaised);

    }
}