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
 ${C0}T${C1}w${C2}e${C3}e${C4}t${C5}2${C6}D${C7}o${C8}o${C9}m ${CG}                                                                 4/4 
 
 Make history by collaborating and completing achievements:
 
  ${CY}     ___________
  ${CY}    '._==_==_=_.'
  ${CY}    .-\.      /-.
  ${CY}   | (|. ${C0}T${C5}2${C9}D ${CY} |) |     - Complete a level
  ${CY}    '-|.      |-'
  ${CY}      \:.     /        - Complete the entire game
  ${CY}       ':.  .'
  ${CY}         ) (           - Community suggested achievements
  ${CY}       _.' '._
  ${CY}      '-------'


 A tweet chain that completes an achievement will get fully rendered
 from start to finish and the video will be shared online.

 The ${CT}Twitter ${CC}handle of everyone who contributed to the gameplay will be shown
 in the upper right corner of each frame for which they have provided input.

 
 Have fun!










" | textimg --background 13,26,39,255 -o instructions3.png -f /usr/share/fonts/truetype/liberation2/LiberationMono-Regular.ttf
