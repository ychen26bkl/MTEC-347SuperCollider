# MTEC-347 Sharing Codes

##### by Yujin Chen

### 1. What you did?
I created a live performance patch that includes several instrumental sound design and live performance.

### 2. How you did it
First set the global clock, then created Drum Kit, Notes, Bass, Pad and other instruments in SynthDef, and then applied the corresponding Pbind to control them. Almost all parameters can be modified in Pbind, which gives the patch a lot of possibilities.

In addition, I used some interesting tools, such as the control of different conversion frequency LFO Pad. When designing bass and notes, the ideas are similar, both of them are sequenceing some notes. I use octave related note to assemble, which will be more intuitive, and easy to modify and get a good melody.

When designing drum sets, I really enjoyed the process of sound design - in Pbind, it was mainly about changing the rhythm of the drums. It can also have many possibilities, just need to change a few Array [0,1] to modify the rhythm effect.

### 3. The problems you faced

To avoid any possible conflicts (like make it work on anybody's laptop :/), I decided to self-design all the sounds and not using any external plug-ins or samples.

By just using internal stuff, "make it cool" and not boring is the most challenge that I faced. Hope it works and the sequences work properly :)

After looking at Nathaneil's code, I felt that my code could use some more quantification and better stops/endings.

### 4. Referenced codes

N/A