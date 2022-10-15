# EDGE - An ExtenDed Goal modElling paradigm for self-adaptive (SAS) systems

We propose EDGE, an ExtenDed Goal modElling paradigm for self-adaptive systems (SAS). The EDGE notation - shown below - provides support for the specification of goal variants, properties, status and dependencies, and allows the automated synthesis of goal controllers for the goal management layer of SAS.

![EDGE Notation](EDGENotation.svg)

We illustrate the use for the EDGE notation below, for a SAS comprising a robot whose top-level goal G0 is to maintain a patient room in a hospital by cleaning its floor in one of two ways (goal variants G1a, G1b, cf.~desideratum D1) and sterilizing the whole room/its bathroom (goal variants G6a, G6b). Cleaning the floor thoroughly (goal variant G1a) requires the moving of some of the room furniture to one side (goal G2), vacuum cleaning (goal variants (G3a), (G3b), wiping the floor (goal variants (G4a), (G4b), and replacing the removed furniture in its initial position (G5).

![Keeping Clean](KeepingClean.svg)

The Markov decision process derived by applying the method from our ICSE-NIER 2023 submission to this EDGE goal model is included in the [EDGE-CaseStudy folder](EDGE-CaseStudy). We used the probabilistic model checker PRISM to synthesise a goal controller (i.e., a policy for this MDP) that:
    
    - Requirement 1: maximises the SAS utility 
    
    - Requirement 2: while keeping the cost no larger than 25. 
    
The probabilistic temporal logic formula supplied to PRISM in order to obtain this MDP policy is available [in the Requirements.pctl](EDGE-CaseStudy/Requirements.pctl) file, and the actual policy (in raw PRISM format) is available [in the GoalController.txt](EDGE-CaseStudy/GoalController.txt) file, along with the encoding that PRISM used for the MDP states, which we made available [in the MDPstates.txt](EDGE-CaseStudy/MDPstates.txt) file.


## INSTALLATION INSTRUCTIONS TO SYNTHESIZE THE EDGE GOAL CONTROLLER
1. Install the probabilistic model checker PRISM (freely available [here](https://www.prismmodelchecker.org/download.php)) on your computer.
2. Start the PRISM GUI and load the [EDGE MDP model](EDGE-CaseStudy/EDGE_MDP.pm) into PRISM. 
<<<PRISM screenshot to be loaded here>>>
3. Load the [PCTL-encoded property](EDGE-CaseStudy/Requirements.pctl) into PRISM. 
<<<<We add a screenshot with the property loaded into PRISM below this step.>>>>
4. Configure PRISM to export the MDP policies it synthesises to a file by:
    
..1. Choosing Options in the Options menu.
    
..2. In 'Adversary Export' property, choose DTMC

..3. In 'Adversary Export filename' property type the direct you want to have the synthesised MDP policies by PRISM

..4. Select 'Save Options.

5. Go to the Properties tab, and right-click on the first property. Then select Verify as depicted below.
6. Export the MDP states to a file. From the menu select: Model -> Export -> States and save it a file
7. Extract the goal controller from the MDP policy synthesised by PRISM by setting up the failing configuration at stake. For example:

While pursuing all first variants, the system failed while pursuing G3a. The trace below can be found in line 52931 of your exported PRISM states file, which should be also found in the [MDPstates.txt file](EDGE-CaseStudy/MDPstates.txt). In the trace below, the tuple '1,1,1,1,1' means that all the first variant of the goal model were pursued. However, when step = 2 (pursuing G3), it failed (prior to last field in the tuple below fail = true)
52931:(1,1,1,1,1,0,true,true,false,true,false,false,true,true,false,false,true,false,true,true,false,false,2,true,false)

Given the turn to the controller, it pursues another variant for G3, but skips G2 as it was already achieved. The first two field in the tuple below (0,2,...). Notice that the controller is still with the Turn (t=true) as the last field of the tuple below.  
41337:(0,2,1,1,1,2,true,true,false,true,false,false,true,true,false,false,true,false,true,true,false,false,0,false,true)

And the full policy below is passed to the Change Management, where G2 is no longer pursued as it has been already achieved:
41187:(0,2,1,1,1,0,true,true,false,true,false,false,true,true,false,false,true,false,true,true,false,false,0,false,false)
