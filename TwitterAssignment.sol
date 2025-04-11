// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 <0.9.0;

contract TweetContract{
    struct Tweet {
    uint id;
    address author;
    string content;
    uint createdAt;
}

    struct Message {
        uint id;
        string content;
        address from;
        address to;
        uint createdAt;
}

    //store every tweet by tweet id
    mapping(uint => Tweet) public tweets;

    //store every user's tweet history
    mapping(address => uint[]) public tweetsOf;

    //like chat history
    //every address means every user with array of message type, 
    mapping(address => Message[]) public conversations;

    //access control, let someone post a message for another user
    mapping(address => mapping(address=>bool)) public operators;


    //which addresses are followed by which addresses
    mapping(address => address[]) public following;


    //counters for generating unique id for tweets and messages
    //next tweetid
    uint nextId;
    //next message id
    uint nextMessageId;

    //funcion to do a tweet
    function _tweet(address _from, string memory _content) internal {
        //checks if sender of the tweet is the actual user or if other user then if it has the access or not.
        require(_from == msg.sender || operators[_from][msg.sender], "You don't have access!");

        //tweet has to saved in the mapping
        //this tweet is getting stored in the tweet-id => tweet mapping
        tweets[nextId] = Tweet( nextId, _from, _content, block.timestamp);

        //this mapping is user => his tweet_id
        //we are storing this mapping as user => tweet_id
        tweetsOf[_from].push(nextId);

        nextId += 1;
    }

    //internal messaging function

    function _message(address _from, address _to, string memory _msg) internal{
        
        //checks if sender of the tweet is the actual user or if other user then if it has the access or not.
        require(_from == msg.sender || operators[_from][msg.sender], "You don't have access!");

        //storing the message in the address => message[] mapping
        //chat history
        conversations[_from].push(Message(nextMessageId, _msg, _from, _to, block.timestamp));

        nextMessageId += 1;
    }


    //public tweet functions

    //Used when user authorised other member wants to post your tweet.
    function tweet(address _from, string memory _content) internal{
        _tweet(_from, _content);
    }

    //Used when user wants to post your own tweet.
    function tweet(string memory _content) internal{
        _tweet(msg.sender, _content);
    }

    //Used when user authorised other member wants to post your message.
    function message(address _from, address _to, string memory _content) internal{
        _message(_from, _to, _content);
    }
    
    //Used when user wants to post your own message.
    function message(address _to, string memory _content) internal{
        _message(msg.sender, _to, _content);
    }



    //function follow
    //user enter the id he wants to follow to, 
    //followed and gets added into the mapping of user => following
    function follow(address _followTo) internal{
        following[msg.sender].push(_followTo);
    }

    //give authorisation
    function allow(address _op) public{
        operators[msg.sender][_op] = true;
    }

    //revoke autherisation
    function disAllow(address _op) public{
        operators[msg.sender][_op] = false;
    }

    //returns last k tweets done in the blockchain, not any personal last k tweets
    function getLatestTweets(uint count) public view returns(Tweet[] memory){

        //check validity of count
        require(count > 0 && count < nextId, "Invalid Count!");

        //Create an array to hold the last k tweets.
        Tweet[] memory _tweets = new Tweet[] (count);
        
        //iterator for our array
        uint j;
        //iterate over lst k tweets and push in our array
        //we are iterating over our map named tweet where tweets are stored by tweetId 
        for(uint i = nextId - count ; i < nextId ; i++){
            Tweet storage _structure = tweets[i];
            _tweets[j] = Tweet(_structure.id, _structure.author, _structure.content, _structure.createdAt);
            j++;
        }

        return _tweets;
    }

    function getLatestTweetsByUsers(address _user, uint count) public view returns(Tweet[] memory){
        Tweet[] memory _tweets = new Tweet[](count);
        uint[] memory _ids = tweetsOf[_user];

        require(count > 0 && count < _ids.length,"Invalid Count");

        uint j;
        for(uint i = _ids.length - count ; i < _ids.length ; i++){
            Tweet storage _structure = tweets[i];
            _tweets[j] = Tweet(_structure.id, _structure.author, _structure.content, _structure.createdAt);
            j++;
        }
        return _tweets;
    }
   
}