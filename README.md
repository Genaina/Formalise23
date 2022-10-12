# NIER23
We propose EDGE, an ExtenDed Goal modElling paradigm for self-adaptive (SAS) systems. The EDGE notation - shown below - provides support for the specification of goal variants, properties, status and dependencies, and allows the automated synthesis of goal controllers for the goal management layer of SAS.

![EDGE Notation](EDGENotation.svg)

We illustrate the use for the EDGE notation below, for a SAS comprising a robot whose top-level goal G0 is to maintain a patient room in a hospital by cleaning its floor in one of two ways (goal variants G1a, G1b, cf.~desideratum D1) and sterilizing the whole room/its bathroom (goal variants G6a, G6b). Cleaning the floor thoroughly (goal variant G1a) requires the moving of some of the room furniture to one side (goal G2), vacuum cleaning (goal variants (G3a), (G3b), wiping the floor (goal variants (G4a), (G4b), and replacing the removed furniture in its initial position (G5).

![Keeping Clean](KeepingClean.svg)
