// QuickCode Assigment
// Yujin Chen


// Under the Sea
{MoogFF.ar((CombC.ar(SinOsc.ar(100 * MouseY.kr(0.05,0.5),0,0.1), 2, LFNoise1.ar(1.89*LFSaw.ar(0.1)+20,0.5,1.4), 20).dup), MouseX.kr(100, 10000, 1), MouseX.kr(0, 4))}.play


/*
UGens used:
    MoogFF
    CombC
    MouseY
    MouseX
    SinOsc
    LFSaw
*/