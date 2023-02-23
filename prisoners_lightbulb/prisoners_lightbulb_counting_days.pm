// Non-optimal solution for the prisoners with lightbulb
// This solution requires that all prisoners must visited the room in a fixed order
// see for example: https://www.cut-the-knot.org/Probability/LightBulbs.shtml

dtmc

const int NoPrisoners = 100;

module prisoners

    // How many prisoners (except the leader) have visited the room
	visited : [0..NoPrisoners-1] init 0;
    day : [0..NoPrisoners-1] init 0;
    // How many prisoners (except the leader) have turned on the lightbulb
	turnedOn : [0..NoPrisoners-1] init 0;
    // State of the lightbulb
    lightbulb : bool init false;
    // Whether the leader can make the announcement
    ended : bool init false;

    [] day = 0 -> 1 / NoPrisoners : (lightbulb'=true) & (day'=day+1) // Prisoner 1 visited, light is turned on
               +  (NoPrisoners - 1) / NoPrisoners : (lightbulb'=false) & (day'=day+1); // Wrong prisoner visited, turn off light
    [] day > 0 & day < NoPrisoners - 1 & lightbulb -> 1 / NoPrisoners : (day'=day+1) // Correct prisoner visited, lightbulb stays on
                                                   +  (NoPrisoners - 1) / NoPrisoners : (lightbulb'=false) & (day'=day+1); // Wrong prisoner visited, turn off light
    [] day > 0 & day < NoPrisoners - 1 & !lightbulb -> 1 : (day'=day+1);  // Order was already violated before, light stays off
    [] day = NoPrisoners - 1 & lightbulb -> 1 / NoPrisoners : (day'=0) & (ended'=true) // Last prisoner visited, announcement can be made
                                         +  (NoPrisoners - 1) / NoPrisoners : (lightbulb'=false) & (day'=0); // Wrong prisoner visited, turn off light, new sequence of days begins
    [] day = NoPrisoners - 1 & !lightbulb -> 1 : (day'=0);  // Light stays off, but new sequence of days begins

endmodule

rewards "steps"
    true : 1;
endrewards

// Leader has seen the lightbulb often enough
label "ended" = ended;
