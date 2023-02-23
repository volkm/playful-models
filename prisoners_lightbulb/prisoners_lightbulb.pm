// Solution for the prisoners with lightbulb
// see for example: https://www.cut-the-knot.org/Probability/LightBulbs.shtml

dtmc

const int NoPrisoners = 100;

module prisoners

    // How many prisoners (except the leader) have visited the room
	visited : [0..NoPrisoners-1] init 0;
    // How many prisoners (except the leader) have turned on the lightbulb
	turnedOn : [0..NoPrisoners-1] init 0;
    // State of the lightbulb
    lightbulb : bool init false;
    // How many times the leader has seen the lightbulb on
    leaderSeen : [0..NoPrisoners-1] init 0;
    // Whether the leader can make the announcement
    ended : bool init false;

    [] leaderSeen < 99 & !lightbulb -> 1 / NoPrisoners : true // Leader does nothing
                                    + turnedOn / NoPrisoners : true // Already visited room and turned on light
                                    + (visited-turnedOn) / NoPrisoners : (turnedOn'=turnedOn+1) & (lightbulb'=true) // Already visited room but not yet turned on light
                                    + (NoPrisoners-1-visited) / NoPrisoners : (turnedOn'=turnedOn+1) & (lightbulb'=true) & (visited'=visited+1); // Not yet visited the room
    [] leaderSeen < 99 & lightbulb  -> visited / NoPrisoners : true // Already visited room
                                    + (NoPrisoners - visited - 1) / NoPrisoners : (visited'=visited+1) // Not yet visited the room
                                    + 1 / NoPrisoners : (lightbulb'=false) & (leaderSeen'=leaderSeen+1); // Leader turns off light
    [] leaderSeen >= 99  -> (NoPrisoners-1) / NoPrisoners : true
                         + 1 / NoPrisoners : (ended'=true); // Leader can give announcement

endmodule

rewards "steps"
    true : 1;
endrewards

// Leader has seen the lightbulb often enough
label "leaderAllSeen" = ended;
// All prisoners have visited the room at least once
label "allVisited" = visited >= NoPrisoners-1 & leaderSeen > 0;
