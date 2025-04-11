# TweetContract 🐦

A Solidity smart contract that simulates core social media features such as tweeting, messaging, following, and access control.

## Features

- ✍️ Post tweets (with timestamp and author)
- 💬 Send private messages between users
- 👥 Follow other users
- 🔐 Access control: allow/disallow posting on behalf of others
- 📥 Retrieve latest tweets (global or user-specific)

## How to Use

1. Deploy `TweetContract.sol` using Remix, Hardhat, or Truffle.
2. Interact with the contract functions:
   - `tweet()`, `sendMessage()`, `follow()`
   - `allow()`, `disallow()`
   - `getLatestTweets()`, `getLatestOfUser()`

## Contract Details

- Language: Solidity `^0.8.0`
- License: MIT

## License

This project is licensed under the MIT License.
