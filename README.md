[![Twitter Follow](https://img.shields.io/twitter/follow/tweet2doom?style=social)](https://twitter.com/tweet2doom)
[![Subreddit subscribers](https://img.shields.io/reddit/subreddit-subscribers/tweet2doom?style=social)](https://www.reddit.com/r/tweet2doom/)

![image](https://user-images.githubusercontent.com/1991296/135762414-2c25424a-242b-42ed-85f8-9c02954b6250.png)

<p align="center">
  <b>A Twitter bot that plays Doom</b><br>
  <a href="https://twitter.com/tweet2doom">@tweet2doom</a>
</p>

## Examples

Here are a few moves that I played to demonstrate how the bot works:

- [ROOT tweet](https://t.co/YszpiKnXEE)
  - [/play x,10-,e,10-,e,10-,e,50-,50-u,35-,](https://t.co/xCGTkBM7AW) *(Start new game)*
    - [/play 50-<f,35-,](https://t.co/IN7WYRuNWS) *(Strafe left and shoot)*
    - [/play 55-Lf,55-Rf,35-,](https://t.co/d2UoxWC4b1) *(Rotate and shoot)*
    - [/play x,15-,d,15-,e,35-,d,10-,d,70-,e,70-,x,70-,](https://t.co/5DgReHUJ1q) *(Change graphics detail)*
    - [/play 35-,t,35-,t,35-,](https://t.co/sKlWjaGTfv) *(Toggle map)*
      - [/play x,10-,e,10-,e,10-,e,50-,50-u,35-,](https://t.co/AALvW58X4G) *(Restart the game)*
    - [/play 29-l,80-U,35-,](https://t.co/3289f7O6LG) *(Pickup armor)*
      - [/play 54-r,70-U,35-,](https://t.co/DYDdd45p5p) *(Go back)*
        - [/play 15-l,10-U,99-f,](https://t.co/RYQ62ARIs6) *(Shoot barrel)*
        - [/play 15-l,24-U,1,1,1,1,1,20-f,5-fu,99-f,99-f,](https://t.co/kQpwowFG0A) *(Punch barrel)*
        - [/play 25-Ual,25-Uar,35-,](https://t.co/gz1FPDhwQD) *(Straferun SR40)*
        - [/play 25-Ual<,25-Uar>,35-,](https://t.co/Js9vS07OeL) *(Straferun SR50)*

The above is a textual representation of part of the "state tree" of [@tweet2doom](https://twitter.com/tweet2doom).\
All branches of the state tree begin with the [ROOT tweet](https://t.co/YszpiKnXEE). You can reply to any node of this tree to generate a new game state / branch.
The full state tree can be explored here: https://tweet2doom.github.io

<p align="center">
<img src="https://user-images.githubusercontent.com/1991296/137181096-db4df596-abe4-4b8a-8783-d9afe3673ee6.png"></img><br>
Fig 1. The state tree of <a href="https://twitter.com/tweet2doom">@tweet2doom</a>
</p>

Here are a few tips for navigating the state tree on Twitter:
 - Scrolling up brings you to the previous state of the game
 - Keep scrolling up to see the parent tweet, followed by the grand-parent, grand-grand-parent, etc.
 - Scrolling up will eventually always lead you to the [ROOT tweet](https://t.co/YszpiKnXEE)
 - Scrolling down shows you all the branches from this point forward. Each reply creates a new branch in the state tree
 - Extensions like [treeverse.app](https://treeverse.app) can be useful to explore the tree as a graph: [example](https://i.imgur.com/YdmahlL.png)

<p align="center">
<img src="https://user-images.githubusercontent.com/1991296/135765815-2f043695-cceb-4d3e-88dd-74c75cd4132c.png"></img><br>
Fig 2. Understanding the Twitter feed
</p>

## How it works

Below is a technical description of how the bot is implemented. For instructions about how to use it, simply visit [@tweet2doom](https://t.co/YszpiKnXEE) on Twitter and read the instructions in the ROOT tweet.

This is my first Twitter bot, so most likely there are multiple bad practices here. Also, a few setup instructions are omitted in the current description, such as creating API access tokens, setting environment variables, etc., but it should not be too difficult to figure them out. The [doomreplay](https://github.com/ggerganov/doomreplay) fork is used to generate the gameplay videos by passing keyboard input from a text file. The rest of the bot consists of 3 independent processes written in Bash, Node and C++ to manage all the data:

- A [filtered stream](https://developer.twitter.com/en/docs/twitter-api/tweets/filtered-stream/introduction) receives all replies to the [@tweet2doom](https://twitter.com/tweet2doom) account. The filter is configured to pass only the tweets that contain the string `/play` and are part of the conversation with id determined by the [ROOT tweet](https://t.co/YszpiKnXEE). The implementation of this part is in [./stream](./stream). Each filtered tweet is stored in a unique folder in the [./requests](./requests) directory. The folder name is given by the `id` of the tweet.

- A separate process ([./processor/service.sh](./processor/service.sh)) continuously checks the [./requests](./requests) folder for new entries. If there is a new entry, it moves it to the [./processing](./processing) folder and starts processing it. It does some basic validation of the json data, checks if the parent node (i.e. the tweet that it replies to) is known and then parses the tweet text, searching for the `/play` command. The parsing is implemented in [./parse-tweet.cpp](./parse-tweet.cpp). If the tweet text is a valid command, it is translated to [doomreplay](https://github.com/ggerganov/doomreplay) format. The translated input string is appended to the parent's input and the result is simulated *from the beginning* in order to generate the new video. The folder is then moved to [./pending](./pending) where it is later processed by another process.

- The [./reply/service.sh](./reply/service.sh) process continuously checks the [./pending](./pending) folder for new entries. If there is a new entry which is indicated as an error, then we reply with the error information using the [@tweet2doom_info](https://twitter.com/tweet2doom_info) account. Otherwise, we reply using the [@tweet2doom](https://twitter.com/tweet2doom) account and attach the generated video as media. Upon successful reply, we use the id of the newly generated tweet to create a new node in the [./nodes](./nodes) folder. Finally, we move the current folder to [./processed](./processed), [./invalid](./invalid) or [./failed](./failed) based on the outcome of the reply operation. The replies are rate limited to a maximum of 1 reply per 36 seconds in order to avoid hitting the tweet limit of [maximum of 2400 tweets per day per account](https://help.twitter.com/en/rules-and-policies/twitter-limits).

The described infrastructure makes use of the atomicity of the `mv` (i.e. `rename`) operation on Unix system. This way, the 3 processes can safely pass each other the data. In theory, with small modifications, there can be multiple [./processor/service.sh](./processor/service.sh) instances running in parallel in order to process things faster.

Why 3 separate processes?
The first process needs to be separated from the rest in order to process the filtered stream as fast as possible in case of a heavy income of new tweets. Delaying the processing can drop your connection and cause you to miss some of the events. The second process is separated from the third mainly because of the 1 reply per 36 seconds restriction - i.e. we can start generating the next video even before we replied to the previous one.

All of this runs on a 2GB Linode $10/month server and it should be able to handle processing of very long tweet chains (for example, reaching several hours of gameplay). It might get problematic if suddenly, too many people start playing the game, in which case the 1 reply per 36 seconds limit would make things pretty slow. But I guess there is no way around this short of using multiple Twitter accounts.

A copy of the entire state tree is maintained in a sister repository:

https://github.com/tweet2doom/tweet2doom.github.io

The repository is automatically updated every 15 seconds with any new nodes that might have been generated. This allows all [@tweet2doom](https://twitter.com/tweet2doom) data to be explored and processed by anyone. The repository also contains a few scripts and tools. For example, the state explorer is implemented [here](https://github.com/tweet2doom/tweet2doom.github.io/blob/master/index.html).

## Instructions

These are the instructions included in the [ROOT tweet](https://t.co/YszpiKnXEE) as images.
The images are generated using simple Bash scripts. The state tree ASCII diagram is partially created using https://dot-to-ascii.ggerganov.com

- [./instructions0.sh](./instructions0.sh)

![Instructions0](./instructions0.png?raw=true "Instructions0")

- [./instructions1.sh](./instructions1.sh)

![Instructions1](./instructions1.png?raw=true "Instructions1")

- [./instructions2.sh](./instructions2.sh)

![Instructions2](./instructions2.png?raw=true "Instructions2")

- [./instructions3.sh](./instructions3.sh)

![Instructions3](./instructions3.png?raw=true "Instructions3")

## Summary

Overall this was a very fun project to work on. I dived into [Doom's source code](https://github.com/id-Software/DOOM), understood better why this game was such a turning point in the game industry and also implemented my first Twitter bot. Everything started 2 weeks ago with a "brilliant" idea to run Doom on Twitter :) I still think it could be a fun collaborative activity if more people give it a try... although, it does require a lot of patience to play the game like this :D

If you found this idea interesting, please let me know what you think. Would love to hear any comments or suggestions!
