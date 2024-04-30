//////////////////////Initialization///////////////////////

(Server.killAll;
Server.default.options.numOutputBusChannels_(15);
Server.default.options.numInputBusChannels_(15);
Server.default.options.numAudioBusChannels_(1024);
Server.default.options.inDevice_("MacBook Pro Microphone");
Server.default.options.outDevice_( "MacBook Pro Speakers");
MIDIClient.init;
s.boot;)


//////////////////////Tempo Setting///////////////////////
// 1. Set the Clock
t = TempoClock.new(1.75, 0); t.schedAbs(t.nextBar, {t.beatsPerBar_(4)}); ProxySpace.push(s.boot, clock: t);


//////////////////////Synth Defines///////////////////////
// 2. Set different instruments are a whole
(
//Drums
SynthDef.new(\kit,
	{
		arg pan=0, bdpan=0, hhpan=0, sdpan=0, bd=0, hh=0, hho=0, sd=0, amp=0.5, mix=0.33, room=0.8;

		var osc, env, output1, output2, kick, snare, hihat, hhopen, hhclosed;

		// Bass Drum sound
		osc = {SinOsc.ar(60,1,amp*bd)};
		env = {Line.ar(1, 0, 0.15)};

		output1 = osc * env;

		osc = {PinkNoise.ar(0.1 * bd * amp)};
		env = {Line.ar(1, 0, 0.1)};

		output2 = osc * env;

		kick = Pan2.ar(output1 + output2, bdpan);

		// HH sound
		hhopen = Pan2.ar({ WhiteNoise.ar( amp * hho * 0.5) * EnvGen.ar(Env([0,amp,0],[0.01, 0.25]),doneAction:2); }, hhpan);
		hhclosed = Pan2.ar({ WhiteNoise.ar( amp * hh * 0.5) * EnvGen.ar(Env.perc(0.01, 0.05, amp)); },hhpan);
		hihat = FreeVerb.ar((hhclosed + hhopen), mix, room, 0.5, 1);

		// Snare Sound

		env = EnvGen.ar(Env.perc(0.01, 0.1, amp));
		osc = LFNoise0.ar(6000, mul:sd * amp);
		snare = Pan2.ar(osc * env, sdpan);

		// Collect

		Out.ar(0, Pan2.ar( kick + snare + hihat, pan));
        }).add;

SynthDef.new( \pad,
	{
		arg amp=0, sustain=1, pan=0, freq=0, lfo=0;

		var osc, env;

		osc = RLPF.ar((SinOsc.ar(freq, 0, amp / 4) + SinOsc.ar(freq + 2, 0, amp / 4)),SinOsc.ar(XLine.kr(lfo, 100, 20) , 0, 3600, 4000), 0.2);

		env = EnvGen.ar(Env(times:[t.beatDur * sustain * 0.5, t.beatDur * sustain * 0.5]), doneAction:2);

		Out.ar(0, Pan2.ar( osc * env, pan));
        }).add;

SynthDef.new( \notes,
	{
		arg amp=0, sustain=1, pan=0, freq=0;

		var osc, env;

		osc = SinOsc.ar(freq+2, mul:amp);

		env = EnvGen.ar(Env.perc(0.001, t.beatDur * sustain), doneAction:2);

		Out.ar(0, Pan2.ar( osc * env, pan));
        }).add;

SynthDef.new( \bass,
	{
		arg amp=0, sustain=1, pan=0, freq=0;

		var osc, env;

		osc = Saw.ar(freq, mul:amp);

		env = EnvGen.ar(Env.perc(0.01, t.beatDur * sustain), doneAction:2);

		Out.ar(0, Pan2.ar( osc * env, pan));
        }).add;
)



//////////////////////Pbind Playing///////////////////////
//3. Playing one by one
// Recommond start from pads, add more octaves to pads, then add notes, then speed up the notes, then add drum kit with only hh, then add bass notes, with different octaces, then add kicks and snares in.
//Feel free to change the "anergy level" when ever you want
//Fade out recommond, just as howwe start...

(
t.schedAbs( t.nextBar,
	{
		~pad = Pbind(
			\instrument, \pad,

			\scale, Scale.minor,
			\root, 0,

			\amp, 0,
			\pan, [1, -1],

			\dur, 8,
			\sustain, 16,

			// when only play pad,change its LPF rate in real time?
			\lfo, 0.6,

			// Add more octaves to make it more various [3,4,5,6,7,...]
			\octave, [3,4,5,6],
			\degree, Pseq([0,1,-3,-5],inf) + [0,2]
		);
	}
));

(
t.schedAbs( t.nextBar,
	{
		~notes = Pbind(
			\instrument, \notes,

			\scale, Scale.minor,
			\root, 0,

			\amp, 0.4,
			\pan, Prand([-0.8, 0.8],inf),

			//gradually set the min dur to a less number (4, 2, 1, 0.5, 0.25), like: Pn(0.25,8) etc.
			\dur, Pseq([Pn(0.3,8), Pn(0.3,4)],inf),
			\sustain, Pseq([Pn(4,6), Pn(2,4)],inf),

			//gradually expand the range of it cover, like to [2,5] etc.
			\octave, Pwrand([[4,6],[2,4]],[0.2,0.8],inf),
			\degree, Pstutter(15, Pseq([-2,0,1,3,4,6],inf)) + Prand([0,1,2,4,6],inf))

	}
));

(
t.schedAbs( t.nextBar,
	{
		~bass = Pbind(
			\instrument, \bass,

			\scale, Scale.minor,
			\root, 0,

			\amp, 0.15,
			\pan, Prand([-1, 1],inf),

			\dur, 1,
			\sustain, 1,

			\octave, Pwrand([[2,6],[1,3]],[0.1, 0.4],inf),
			//Could change the degree setting if don't add
			\degree, Pstutter(16, Pseq([0,4,2,6],inf)) + Prand([0,1,0,3,4],inf))

	}
));


(
t.schedAbs( t.nextBar,
	{
		~kit = Pbind(
			\instrument, \kit,
			\dur, 0.5,
			\amp, 0,
			\mix, 0.6,
			\room, 0.6,
			\bd, Place([[0,1],1,[0,1],1,[0,1], 0],inf),
			\hh, Prand([0,1,0,0,3],inf),
			\hhpan, Prand(Array.series(10,-1,0.2),inf),
			\sd, Place([[0,1],0,[0,1],1,1,0],inf)
	);
	}
)
);

		