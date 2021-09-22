#!/bin/bash

#C0="\x1b[38;2;029;161;242m"
#C1="\x1b[38;2;054;148;220m"
#C2="\x1b[38;2;079;136;199m"
#C3="\x1b[38;2;104;123;177m"
#C4="\x1b[38;2;129;111;156m"
#C5="\x1b[38;2;155;098;134m"
#C6="\x1b[38;2;180;086;113m"
#C7="\x1b[38;2;205;073;091m"
#C8="\x1b[38;2;230;061;070m"
#C9="\x1b[38;2;255;048;048m"

C0="\x1b[38;2;000;255;124m"
C1="\x1b[38;2;000;255;124m"
C2="\x1b[38;2;000;255;124m"
C3="\x1b[38;2;000;255;124m"
C4="\x1b[38;2;000;255;124m"
C5="\x1b[38;2;000;255;124m"
C6="\x1b[38;2;000;255;124m"
C7="\x1b[38;2;000;255;124m"
C8="\x1b[38;2;000;255;124m"
C9="\x1b[38;2;000;255;124m"

CT="\x1b[38;2;029;161;242m"
CD="\x1b[38;2;255;048;048m"

CC="\x1b[0m"
CG="\x1b[38;2;000;255;124m"
CY="\x1b[38;2;255;238;110m"

echo -e "
 ${C0}T${C1}w${C2}e${C3}e${C4}t${C5}2${C6}D${C7}o${C8}o${C9}m ${CG}                                                                 1/4 
 
 The ${CG}@tweet2doom ${CC}account is a ${CT}Twitter ${CC}bot that simulates keyboard input inside
 the ${CD}Doom (1993) ${CC}video game and responds with a movie of the generated gameplay.
 Each valid tweet sent to the bot will generate a new game state. Everybody can
 resume playing the game from any state by replying to the corresponding tweet.
 
 ${CY}Allowed input: ${CC}
 
   ${CG}, ${CC}  - new frame             ${CG}U ${CC}- shift + up arrow
   ${CG}x ${CC}  - escape                ${CG}D ${CC}- shift + down arrow
   ${CG}e ${CC}  - enter                 ${CG}L ${CC}- shift + left arrow
   ${CG}l ${CC}  - left arrow            ${CG}R ${CC}- shift + right arrow
   ${CG}r ${CC}  - right arrow           ${CG}< ${CC}- strafe left
   ${CG}u ${CC}  - up arrow              ${CG}> ${CC}- strafe right
   ${CG}d ${CC}  - down arrow
   ${CG}a ${CC}  - alt                   ${CG}y ${CC}  - yes
   ${CG}s ${CC}  - shift                 ${CG}n ${CC}  - no
   ${CG}p ${CC}  - space                 ${CG}1-7 ${CC}- digits
   ${CG}f ${CC}  - ctrl
   ${CG}t ${CC}  - tab
 
 ${CC}For example, to start a new game, reply to this tweet with the following text:

   ${CG}/play x,,e,,e,,e,,50-,50-u,15-f, ${CC}

 ${CY}Rules: ${CC}

 - Your tweet provides the keyboard input for each new game frame
 - Your tweet must be a ${CG}reply ${CC}to a ${CG}@tweet2doom ${CC}tweet
 - Your tweet must contain a play command: ${CG}/play [input] ${CC}
 - The ${CG}[input] ${CC}text must contain only the allowed characters above
 - Your input will be appended to the tweet chain that you reply to
 - Minimum number of frames per tweet: ${CG}18 ${CC}
 - Maximum number of frames per tweet: ${CG}350 ${CC}
 - The game runs at ${CG}35${CC} frames per second
 - The bot will reply with a video of the last ${CG}10 ${CC}seconds of gameplay
 - The bot will reply with a maximum of ${CG}1${CC} video every ${CG}36 ${CC}seconds

" | textimg --background 13,26,39,255 -o instructions0.png -f /usr/share/fonts/truetype/liberation2/LiberationMono-Regular.ttf
