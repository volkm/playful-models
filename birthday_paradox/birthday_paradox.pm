// Birthday paradox: what is the probability that two people in a group have the same birthday?
dtmc

// Number of people
const int N = 23;
// Days in a year (assuming a leap year for worst-case)
const int D = 366;

module birthday

    i : [0..N] init 0;
    duplicate : bool init false;

    [] i < N -> ((D-i) / D) : (i'=i+1) + (i / D) : (i'=i+1) & (duplicate' = true);

endmodule
