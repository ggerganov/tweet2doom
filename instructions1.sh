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
 ${C0}T${C1}w${C2}e${C3}e${C4}t${C5}2${C6}D${C7}o${C8}o${C9}m ${CG}                                                                 2/4 
 
 To make the ${CG}@tweet2doom ${CC}bot play a certain sequence of keys, reply to them
 with a tweet containing the text ${CG}/play [input]${CC}. The ${CG}[input]${CC} text can be any
 combination of the allowed characters. Use the comma ${CG}, ${CC}character to mark the
 beginning of a new frame. To make the bot hold down a certain set of keys
 for more than one frame use the ${CG}N- ${CC}prefix (note: ${CG}N < 100 ${CC}frames).
 
 ${CY}Examples: ${CC}

 - Start a new game:

   ${CG}/play x,,e,,e,,e,,50-,50-u,8-r,64-f,50-, ${CC}

     ${CY}Frame  Input   Description

   ${CD}      1   ${CG}x${CC}      Press escape to show the main menu
   ${CD}      2   ${CG} ${CC}      No input (i.e. release the escape)
   ${CD}      3   ${CG}e${CC}      Press enter to select \"New Game\" in the main menu
   ${CD}      4   ${CG} ${CC}      No input (i.e. release enter)
   ${CD}      5   ${CG}e${CC}      Press enter to select the first episode
   ${CD}      6   ${CG} ${CC}      No input (i.e. release enter)
   ${CD}      7   ${CG}e${CC}      Press enter to select the skill level
   ${CD}      8   ${CG} ${CC}      No input (i.e. release enter)
   ${CD}   9-58   ${CG}50- ${CC}   Wait for 50 frames for the screen wipe effect to finish
   ${CD} 59-108   ${CG}50-u ${CC}  Walk forward for 50 frames by holding the up arrow
   ${CD}109-116   ${CG}8-r ${CC}   Rotate right for 8 frames by holding the right arrow
   ${CD}117-180   ${CG}64-f ${CC}  Shoot for 64 frames by holding Ctrl
   ${CD}181-230   ${CG}50- ${CC}   No input for 50 frames
 
 - Strafe left and shoot for 50 frames:
 
   ${CG}/play 50-<f, ${CC}
 
 - Turn right at about ~90 degrees and press space:
 
   ${CG}/play 28-r,p, ${CC}

 - Quickly rotate 360 degrees while shooting:
 
   ${CG}/play 55-Lf,55-Rf, ${CC}

 - Do nothing for 1 second and then toggle the map for another second:
 
   ${CG}/play 35-,t,35-,t, ${CC}
 
 - Straferun SR40 (shift + up + alt + left/right):
 
   ${CG}/play 25-Ual,25-Uar, ${CC}
 
 - Straferun SR50 (shift + up + alt + left/right + strafe left/right):
 
   ${CG}/play 25-Ual<,25-Uar>, ${CC}
 
" | textimg --background 13,26,39,255 -o instructions1.png -f /usr/share/fonts/truetype/liberation2/LiberationMono-Regular.ttf
