// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


contract SocialNetwork {

    address public useraccount;
    uint256 public postCount = 0;
    uint256 public postTipCount = 0;

    struct Tips{
        uint256 id;
        address payable tipAddress;
        uint256 tipAmount;
    }

    struct Post {
        uint256 id;
        address payable author;
        string title;
        string content;
        uint256 moneyRecieved;
        Tips[] tips;
    }

    event PostCreated(
        uint256 id,
        address payable author,
        string title,
        string content,
        uint256 moneyRecieved
    );

    event PostTipped(
        uint256 id,
        uint256 postid,
        address payable author,
        address payable tipAddress,
        uint256 tipAmount,
        uint256 moneyRecieved
    );

    mapping(uint256 => Post) public posts;

    constructor(){
        useraccount = msg.sender;
    }

 
    function returnBalance() external view returns (uint256){
        return useraccount.balance;
    }

    
    function postExists(uint256 _id) external view returns (bool){
        require(posts[_id].id > 0, "Post doesn't exist");
        return true;  
    }
  

   function getPostTips(uint256 _id) external view returns (Tips[] memory){
        return posts[_id].tips;   
    }


    function createPost(string memory _title, string memory _content) external{
        // Require valid content
        require(bytes(_content).length > 0);
        // Increment the post count
        postCount ++;
        // Create the post
        Post storage postHold = posts[postCount];
        postHold.id = postCount;
        postHold.author = payable(msg.sender);
        postHold.title = _title;
        postHold.content = _content;
        postHold.moneyRecieved = 0;
        // Trigger event
        emit PostCreated(postCount, payable(msg.sender),_title, _content, 0);
    }

   function tipPost(uint256 _id) external payable {
        // Make sure the id is valid
       require(_id > 0 && _id <= postCount);
        // Fetch the post
        Post storage _post = posts[_id];
        // Fetch the author
        address payable _author = _post.author;
        // Pay the author by sending them Ether
        _author.transfer(msg.value);
        //Update the Money Recieved
        _post.moneyRecieved += msg.value;
        // Increment the post Tip count
        postTipCount ++;
        // Update the post
        Post storage postHold = posts[_id];
        postHold.moneyRecieved = _post.moneyRecieved;
        postHold.tips.push(Tips(postTipCount, payable(msg.sender), msg.value));
        // Trigger an event
        emit PostTipped(postTipCount, _post.id, _author, payable(msg.sender),
         msg.value, _post.moneyRecieved);

    }

    //Referenced https://github.com/OnahProsperity/Blockchain-social-network/blob/master/src/contracts/SocialNetwork.sol

    
}
