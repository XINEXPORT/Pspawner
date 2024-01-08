// Pspawner examples
// One clear advantage is that the spawner *knows* when a pattern has finished.
// (... as opposed to sequencing patterns inside a {}.fork)
// (older examples are at the end of file)

// REALLY SIMPLE EXAMPLE

// ===================================
// Define a bunch of "score snippets"
// Here is where you put your Pbinds.
// Notice that you have to put them
// into a variable (whatever name you want),
// like ~one, ~two, etc.
// Also notice that you do not .play the
// Pbind right away (notice how each Pbind just
// ends on a parenthesis and semicolon).
// The point is that Pspawner will take care of
// starting them.
// ===================================

(
// just examples. You can delete these Pbinds and put yours in here.
~one = Pbind(
	\degree, Pseq([ 0, 1, 2, 3, 4, 5, 6, 7 ], 1),
	\octave, 6,
	\dur, 0.2,
	\legato, 0.1,
	\amp, 0.2
);

~two = Pbind(
	\degree, Pwhite(10, 15, 9),
	\dur, 0.1
);

~three = Pbind(
	\degree, Pseq([ [5, 7, 9], [6, 8, 10] ], inf),
	\dur, 0.2
);
) // end of Pbind definitions

// ============
// Quick test
// ============

~one.play;
~two.play;
~three.play; // notice this one never ends


// =====================
// Sequencing & playing
// =====================

// Simple example

(
Pspawner({ arg maestro;

	maestro.seq(~one);
	maestro.wait(1);
	maestro.seq(~two);
	x = maestro.par(~three);
	maestro.wait(4);
	maestro.suspend(x);
	maestro.wait(4);
	"wow".postln;
	maestro.suspendAll;

}).play
)






// LONGER EXAMPLE

// ===================================
// Define a bunch of "score snippets"
// ===================================

(

~beat = Pbind(
    \degree, [0, 7],
    \ctranspose, 24,
    \dur, 0.2,
    \legato, 0.1,
    \amp, Pseq([0.2, 0.12, 0.16, 0.12], inf)
); // forever pattern

~up = Pbind(
	\scale, Scale.major,
    \degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 1), // finite pattern
    \dur, 0.2
);

~down = Pbind(
	\scale, Scale.minor,
    \degree, Pseq([7, 6, 5, 4, 3, 2, 1, 0], 1), // finite pattern
    \dur, 0.1,
);

~trill = Pbind(
	\degree, Pseq([8, 9], 4), // finite Pattern
    \dur, 0.1
);

~thick = Pbind(
    \degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 1), // finite Pattern
    \dur, 0.2,
    \mtranspose, [0, 2, 4, 6, 8, 10, 12, 14]
);

) // end of Pbind definitions





// ============
// Quick test
// ============

~beat.play;
~up.play;
~down.play;
~trill.play;
~thick.play;






// =====================
// Sequencing & playing
// using Pspawner
// =====================

// The advantage is that the spawner *knows* when a pattern has finished.
// (... as opposed to sequencing patterns inside a {}.fork)

// It's like a fork (things happen in order top to bottom), but
// you always use the spawner argument (in this case, "maestro" -- arbitrary name)
// in order to request a new pattern.

// Notice you should NOT put any .play inside the Pspawner. The only .play is at the very end of the Pspawner.

// When you write "maestro.seq(somePattern)", you are saying:
// "maestro, please play this pattern and only move on in the sequence AFTER said pattern is finished".

// When you write "maestro.par(somePattern)", you are saying:
// "maestro, please start playing this pattern and MOVE ON RIGHT AWAY to the next line."

// Patterns that self-terminate will do so as expected.
// Patterns that do not self-terminate (inf) will keep going forever until told to stop.

// TIP 1: Notice that if you write maestro.seq(someInfPattern) you are setting yourself up for failture. If you request maestro to play an *infinite* pattern and only move on when it's finished, maestro will never move on.

// TIP 2: In order to control start and stop of specific patterns, you should declare a new variable to name it (as you learned before). See ~player1 example below.



(
Pspawner({ arg maestro;

	"Scales in sequence, one right after the other".postln;
    maestro.seq(~up);
	"Down...".postln;
    maestro.seq(~down);

	"With a little pause in between".postln;
    maestro.wait(2.5);
    maestro.seq(~up);
    maestro.wait(1);
    maestro.seq(~down);
    maestro.wait(1);

	"Now two of them in paralell".postln;
    maestro.seq(Ppar([~up, ~down]));

	maestro.wait(4);

	"Now the never-ending beat".postln;
    // Saving into a variable so I can stop it later
    ~player1 = maestro.par(~beat);
    maestro.wait(4);

	"Up again...".postln;
    maestro.seq(~up);
    maestro.wait(1);

	"Stop player1 beta".postln;
	maestro.suspend(~player1); // stop that one
    maestro.wait(1);

	"Play the thick pattern".postln;
    maestro.seq(~thick);

	"Bye!".postln;
    maestro.suspendAll;

}).play
)







































// NEXT EXAMPLE DERIVED FROM HELP FILE

// ===================================
// Define a bunch of "score snippets"
// ===================================

(
~scale = [ 0, 1, 2, 3, 4, 5, 6, 7 ];

~one = Pbind(
	\degree, [0, 7],
	\octave, 7,
	\dur, 0.2,
	\legato, 0.1,
	\db, Pseq([-20, -24, -22, -24], inf));

~two = Pbind(
	\degree, Pseq(~scale.mirror),
	\dur, 0.2);

~three = Pbind(
	\degree, Pseq(~scale.mirror),
	\dur, 0.2,
	\octave, 4);

~four = Pbind(
	\degree, Pseq(~scale.reverse.mirror),
	\dur, 0.2);

~five = Pbind(
	\degree, Pseq(~scale.mirror),
	\dur, 0.2,
	\mtranspose, [0, 2, 4, 6, 8, 10, 12, 14]);

) // end of Pbind definitions

// ============
// Quick test
// ============

~one.play;
~two.play;
~three.play;
~four.play;
~five.play;

// =====================
// Sequencing & playing
// =====================

// Simple example first

(
Pspawner({ arg sp;
	// scales in sequence, one right after the other
	sp.seq(~three);
	sp.seq(~two);
	// with a little pause in between
	sp.wait(0.4);
	sp.seq(~four);
	sp.wait(1);
	sp.seq(~two);
	sp.wait(1);
	// Now two of them in paralell:
	sp.seq(Ppar([~three, ~four]));

	sp.suspendAll;

}).play
)


// A more complex example
(
Pspawner({ | sp |

	// parallel pulses will run throughout the example (like "In C")
	sp.par(~one);

	// scales in sequence with pauses
	sp.seq(~two);

	sp.wait(0.4);

	sp.seq(Ppar([~three, ~four]));

	sp.wait(3);

	sp.seq(~five);

	// scales overlaped at 0.4 second intervals
	10.do {
		sp.par(~two);
		sp.wait(0.4)
	};

	sp.wait(1.6);

	sp.suspendAll;

}).play
)

























// Pspawner example
// One clear advantage is that the spawner *knows* when a pattern has finished.
// (... as opposed to sequencing patterns inside a {}.fork)

(
Pspawner({ | sp |

	// parallel in-c'ish pulses will run throughout the example
	sp.par(
		Pbind(
			\degree, [0, 7],
			\octave, 7,
			\dur, 0.2,
			\legato, 0.1,
			\db, Pseq([-20, -24, -22, -24], inf)));

	// scales in sequence with pauses
	sp.seq(
		Pbind(
			\degree, Pseq((0..7).mirror),
			\dur, 0.2));

	sp.wait(0.4);

	sp.seq(
		Ppar([
			Pbind(
				\degree, Pseq((0..7).mirror),
				\dur, 0.2,
				\octave, 4),
			Pbind(
				\degree, Pseq((0..7).reverse.mirror),
				\dur, 0.2)
	]));

	sp.wait(3);

	sp.seq(
		Pbind(
			\degree, Pseq((0..7).mirror),
			\dur, 0.2,
			\mtranspose, (0,2..14))
	);

	// scales overlaped at 0.4 second intervals
	10.do {
		sp.par(
			Pbind(
				\degree, Pseq((0..7).mirror),
				\dur, 0.2)
		);
		sp.wait(0.4)
	};

	sp.wait(1.6);

	sp.suspendAll;

}).play
)










(
~one =         Pbind(
	\degree, [0, 7],
	\octave, 7,
	\dur, 0.2,
	\legato, 0.1,
	\db, Pseq([-20, -24, -22, -24], inf));

~two = Pbind(
	\degree, Pseq((0..7).mirror),
	\dur, 0.2);

~three = Pbind(
	\degree, Pseq((0..7).mirror),
	\dur, 0.2,
	\octave, 4);

~four = Pbind(
	\degree, Pseq((0..7).reverse.mirror),
	\dur, 0.2);

~five = Pbind(
	\degree, Pseq((0..7).mirror),
	\dur, 0.2,
	\mtranspose, (0,2..14));



Pspawner({ | sp |

	// parallel in-c'ish pulses will run throughout the example
	sp.par(~one);

	// scales in sequence with pauses
	sp.seq(~two);

	sp.wait(0.4);

	sp.seq(Ppar([~three, ~four]));

	sp.wait(3);

	sp.seq(~five);

	// scales overlaped at 0.4 second intervals
	10.do {
		sp.par(~two);
		sp.wait(0.4)
	};

	sp.wait(1.6);

	sp.suspendAll;

}).play
)