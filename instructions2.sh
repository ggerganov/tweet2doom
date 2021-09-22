#!/bin/bash

# https://dot-to-ascii.ggerganov.com/?src_hash=cc419368

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

tb="${CG}@tweet2doom ${CC}"
tp1="${CY}@player1 ${CC}"
tp2="${CY}@player2 ${CC}"
tr="\x1b[38;2;120;120;120mreply${CC}"

echo -e "
 ${C0}T${C1}w${C2}e${C3}e${C4}t${C5}2${C6}D${C7}o${C8}o${C9}m ${CG}                                                                 3/4 
 
 With every new valid tweet, the state tree will expand with a new node.
 The tree starts with the ${CT}ROOT ${CC}node (i.e. this tweet). In order to continue
 playing from a certain state, reply to the corresponding tweet posted by the
 ${tb}bot. Make sure to post your commands as ${CG}replies ${CC}- quoted retweets
 will be ignored by the bot.

                  ┌─────────────┐
                  │ $tb│
                  │             │
          ┌─────> │    ${CT}ROOT ${CC}    │ <─────┐
          │       └─────────────┘       │
          │         ▲                   │
          │         │ ${tr}             │ ${tr}
          │         │                   │
    ┌───────┐     ┌─────────────┐     ┌─────────────────┐
    │       │     │  $tp1  │     │    $tp2    │
    │  ...  │     │             │     │                 │
    │       │     │ /play 50-u  │     │ /play 30-l,50-f │
    └───────┘     └─────────────┘     └─────────────────┘
                    ▲                   ▲
                    │                   │
                    │                   │
                  ┌─────────────┐     ┌─────────────────┐
                  │ $tb│     │   $tb  │
                  │             │     │                 │
                  │    ${CD}Video ${CC}   │     │      ${CD}Video ${CC}     │
                  │             │     │                 │
                  │  Start:  1  │     │    Start:  1    │
                  │  End:   50  │     │    End:   80    │ <─────┐
                  └─────────────┘     └─────────────────┘       │
                    ▲                   ▲                       │
                    │                   │ ${tr}                 │ ${tr}
                    │                   │                       │
                  ┌────────────┐      ┌─────────────────┐    ┌─────────────┐
                  │    ....    │      │    $tp1    │    │   $tp2 │
                  │            │      │                 │    │             │
                  │ 550 frames │      │ /play 20-U,30-L │    │ /play 30-l  │
                  └────────────┘      └─────────────────┘    └─────────────┘
                    ▲                    ▲                      ▲
                    │                    │                      │
                    │                    │                      │           
                  ┌─────────────┐     ┌─────────────┐        ┌─────────────┐
                  │ $tb│     │ $tb│        │ $tb│
                  │             │     │             │        │             │
                  │    ${CD}Video ${CC}   │     │    ${CD}Video ${CC}   │        │    ${CD}Video ${CC}   │
                  │             │     │             │        │             │
                  │  Start: 601 │     │  Start:   1 │        │  Start:   1 │
                  │  End:   950 │     │  End:   130 │        │  End:   110 │
                  └─────────────┘     └─────────────┘        └─────────────┘

" | textimg --background 13,26,39,255 -o instructions2.png -f /usr/share/fonts/truetype/liberation2/LiberationMono-Regular.ttf
