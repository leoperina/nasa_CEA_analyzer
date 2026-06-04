# nasa_CEA_analyzer

This small code is a script I did to study for my Space Propulsion exam.
It is a simple 1 afternoon project, so it is not very sophisticated, yet I believe it came up good enough to be published.

## what it does
This project takes as an input a vector of chamber pressures, an expansion ratio, and an O/F (weight), and it outputs the mass fractions of an isoentrophic expansion using the NASA CEA Rocket Equilibrium Model.
It also outputs the Isp, the c* and the thrust coefficient.
To be absolutely clear, those are ceil values, since they were computed with the shifting equilibrium hypothesis.
The basic configuration is H2/F2, later in the *README* it is explained how to modify it if necessary.

## how to run it
Technically, it is sufficient to run the *matlab_CEA.m* code and all the right graphs should come up easily.

## how to modify it
To modify the sections, there are two possibilities:

1. Modify the run configurations
    To do so, just open *matlab_CEA.m* and in the first lines, it will be possible to modify the Pvec (pressure vector), OF and eps (divergent expansion ratio)
2. Modify the reactants
    To do so, open *matlab_CEA.m* and look for the function *callCEA()* at the end of the script.
    All the times the script calls CEA, it does so through such function, so if you modify it, it will automatically be modified throughout the whole script.

## future developments
In the future, a good project would use this basic structure to study different projects, such as studies with the OF changin, instead of the pressure, multivariable analysis, ecc.
For now, this is again still a project to better understand a subject and nothing more.