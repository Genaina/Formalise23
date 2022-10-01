mdp

  const double p2 = 0.9;
  const double p3_1 = 0.9;
  const double p3_2 = 0.9;
  const double p4_1 = 0.9;
  const double p4_2 = 0.9;
  const double p5 = 0.9;
  const double p6_1 = 0.9;
  const double p6_2 = 0.9;

module ChangeMgmt
  // variables required for each goal g1, g2, ... with its variants 1, 2, 3, ...ble::
  g2_Achievable: bool init true;
  g2_Achieved: bool init false;

  g3_1_Achievable : bool init true; 
  g3_2_Achievable : bool init true; 
  g3_1_Achieved : bool init false; 
  g3_2_Achieved : bool init false; 

  g4_1_Achievable : bool init true; 
  g4_2_Achievable : bool init true; 
  g4_1_Achieved : bool init false; 
  g4_2_Achieved : bool init false;

  g5_Achievable: bool init true;
  g5_Achieved: bool init false;
  
  g6_1_Achievable : bool init true; 
  g6_2_Achievable : bool init true; 
  g6_1_Achieved : bool init false; 
  g6_2_Achieved : bool init false;

  step : [0..7] init 0; 
  needHelp : bool init false;

  // outcomes of pursuing goal 2
  [skip] !t & !needHelp & step=0 & g2_pursued=0 -> 1:(step'=1);
  [] !t & !needHelp & step=0 & g2_pursued>0 -> p2:(g2_Achieved'=true)&(step'=1) + (1-p2):(g2_Achievable'=false)&(needHelp'=true)&(step'=1);

  // outcomes of pursuing goal 3
  [skip] !t & !needHelp & step=1 & g3_pursued=0 -> 1:(step'=2);
  [] !t & !needHelp & step=1 & g3_pursued=1 -> p3_1:(g3_1_Achieved'=true)&(step'=2) + (1-p3_1):(g3_1_Achievable'=false)&(needHelp'=true)&(step'=2);
  [] !t & !needHelp & step=1 & g3_pursued=2 -> p3_2:(g3_2_Achieved'=true)&(step'=2) + (1-p3_2):(g3_2_Achievable'=false)&(needHelp'=true)&(step'=2);

  // outcomes of pursuing goal 4
  [skip] !t & !needHelp & step=2 & g4_pursued=0 -> 1:(step'=3);
  [] !t & !needHelp & step=2 & g4_pursued=1 -> p4_1:(g4_1_Achieved'=true)&(step'=3) + (1-p4_1):(g4_1_Achievable'=false)&(needHelp'=true)&(step'=3);
  [] !t & !needHelp & step=2 & g4_pursued=2 -> p4_2:(g4_2_Achieved'=true)&(step'=3) + (1-p4_2):(g4_2_Achievable'=false)&(needHelp'=true)&(step'=3);

  // outcomes of pursuing goal 2
  [skip] !t & !needHelp & step=3 & g5_pursued=0 -> 1:(step'=4);
  [] !t & !needHelp & step=3 & g5_pursued>0 -> p5:(g5_Achieved'=true)&(step'=4) + (1-p5):(g5_Achievable'=false)&(needHelp'=true)&(step'=4);
  
  // outcomes of pursuing goal 11
  [skip] !t & !needHelp & step=4 & g6_pursued=0 -> 1:(step'=5);
  [] !t & !needHelp & step=4 & g6_pursued=1 -> p6_1:(g6_1_Achieved'=true)&(step'=5) + (1-p6_1):(g6_1_Achievable'=false)&(needHelp'=true)&(step'=5);
  [] !t & !needHelp & step=4 & g6_pursued=2 -> p6_2:(g6_2_Achieved'=true)&(step'=5) + (1-p6_2):(g6_2_Achievable'=false)&(needHelp'=true)&(step'=5);

  // done
  [done] !t & !needHelp & step=5 -> (step'=6);
  [] !t & step=6 -> true;

  // there has been a goal that became unachievable
  [update] !t & needHelp -> 1:(needHelp'=false); 

  // return to step 0
  [controller_done] true -> 1:(step'=0);
endmodule

formula G1_achieved_or_pursued = 
             (g2_Achieved | g2_pursued>0) & 
             (g3_1_Achievable | g3_2_Achievable | g3_pursued>0) & 
             (g4_1_Achievable | g4_2_Achievable | g4_pursued>0) & 
             (g5_Achieved | g5_pursued>0);

module GoalController
  g2_pursued : [0..1] init 0; // goal g2 is: 0 - not pursued, 1 - pursued
  g3_pursued : [0..2] init 0; // goal g3 is: 0 - not pursued, 1 - pursued as variant 1, 2 - pursued as variant 2
  g4_pursued : [0..2] init 0; // goal g4 is: 0 - not pursued, 1 - pursued as variant 1, 2 - pursued as variant 2
  g5_pursued : [0..1] init 0; // goal g5 is: 0 - not pursued, 1 - pursued
  g6_pursued : [0..2] init 0; // goal g6 is: 0 - not pursued, 1 - pursued as variant 1, 2 - pursued as variant 2

  n : [0..5] init 0; // goal counter

  // block of commands for the selecting the way in which goal g2 is pursued
  // - If the goal was achieved _or_ is unachievable in any of the potential variants, then don't pursue it
  [g2_pass] t & (n=0) & (g2_Achieved | !g2_Achievable) -> 1:(g2_pursued'=0)&(n'=1); 
  // - We have a choice of pursuing/not pursuing the goal in any of the available variants
  [g2_pursue0] t & (n=0) & !g2_Achieved & g2_Achievable -> 1:(g2_pursued'=0)&(n'=1);
  [g2_pursue1] t & (n=0) & !g2_Achieved & g2_Achievable -> 1:(g2_pursued'=1)&(n'=1);

  // block of commands for the selecting the way in which goal g3 is pursued
  // - If the goal was achieved _or_ is unachievable in any of the potential variants, then don't pursue it
  [g3_pass] t & (n=1) & (g3_1_Achieved | g3_2_Achieved | (!g3_1_Achievable & !g3_2_Achievable)) -> 1:(g3_pursued'=0)&(n'=2); 
  // - We have a choice of pursuing/not pursuing the goal in any of the available variants
  [g3_pursue0] t & (n=1) & !(g3_1_Achieved | g3_2_Achieved) & (g3_1_Achievable | g3_2_Achievable)-> 1:(g3_pursued'=0)&(n'=2);
  [g3_pursue1] t & (n=1) & !(g3_1_Achieved | g3_2_Achieved) & g3_1_Achievable -> 1:(g3_pursued'=1)&(n'=2);
  [g3_pursue2] t & (n=1) & !(g3_1_Achieved | g3_2_Achieved) & g3_2_Achievable -> 1:(g3_pursued'=2)&(n'=2);

  // block of commands for the selecting the way in which goal g4 is pursued
  // - If the goal was achieved _or_ is unachievable in any of the potential variants, then don't pursue it
  [g4_pass] t & (n=2) & (g4_1_Achieved | g4_2_Achieved | (!g4_1_Achievable & !g4_2_Achievable)) -> 1:(g4_pursued'=0)&(n'=3); 
  // - We have a choice of pursuing/not pursuing the goal in any of the available variants
  [g4_pursue0] t & (n=2) & !(g4_1_Achieved | g4_2_Achieved) & (g4_1_Achievable | g4_2_Achievable)-> 1:(g4_pursued'=0)&(n'=3);
  [g4_pursue1] t & (n=2) & !(g4_1_Achieved | g4_2_Achieved) & g4_1_Achievable -> 1:(g4_pursued'=1)&(n'=3);
  [g4_pursue2] t & (n=2) & !(g4_1_Achieved | g4_2_Achieved) & g4_2_Achievable -> 1:(g4_pursued'=2)&(n'=3);

  // block of commands for the selecting the way in which goal g5 is pursued
  // - If the goal was achieved _or_ is unachievable in any of the potential variants, then don't pursue it
  [g5_pass] t & (n=3) & (g5_Achieved | !g5_Achievable | !(g2_Achieved | g2_pursued>0)) -> 1:(g5_pursued'=0)&(n'=4); 
  // - We have a choice of pursuing/not pursuing the goal in any of the available variants
  [g5_pursue0] t & (n=3) & !g5_Achieved & g5_Achievable & (g2_Achieved | g2_pursued>0) -> 1:(g5_pursued'=0)&(n'=4);
  [g5_pursue1] t & (n=3) & !g5_Achieved & g5_Achievable & (g2_Achieved | g2_pursued>0) -> 1:(g5_pursued'=1)&(n'=4);

  // block of commands for the selecting the way in which goal g4 is pursued
  // - If the goal was achieved _or_ is unachievable in any of the potential variants, then don't pursue it
  [g6_pass] t & (n=4) & (g6_1_Achieved | g6_2_Achieved | ((!g6_1_Achievable | !G1_achieved_or_pursued) & !g6_2_Achievable)) -> 1:(g6_pursued'=0)&(n'=5); 
  // - We have a choice of pursuing/not pursuing the goal in any of the available variants
  [g6_pursue0] t & (n=4) & !(g6_1_Achieved | g6_2_Achieved) & ((g6_1_Achievable & G1_achieved_or_pursued) | g6_2_Achievable)-> 1:(g6_pursued'=0)&(n'=5);
  [g6_pursue1] t & (n=4) & !(g6_1_Achieved | g6_2_Achieved) & g6_1_Achievable & G1_achieved_or_pursued -> 1:(g6_pursued'=1)&(n'=5);
  [g6_pursue2] t & (n=4) & !(g6_1_Achieved | g6_2_Achieved) & g6_2_Achievable -> 1:(g6_pursued'=2)&(n'=5);

  // Controller done
  [controller_done] t & (n=5) -> 1:(n'=0);
endmodule


module Turn
  t : bool init true; // true - controller has the turn, false - goal model updating has the turn

  [controller_done] true -> 1:(t'=false);
  [update] true -> 1:(t'=true);
endmodule


formula g0_Achieved = (g1a_Achieved | g1b_Achieved) & (g6_1_Achieved | g6_2_Achieved);
formula g1a_Achieved = g2_Achieved & (g3_1_Achieved | g3_2_Achieved) & (g4_1_Achieved | g4_2_Achieved) & g5_Achieved;
formula g1b_Achieved = g3_2_Achieved;

rewards "utility"
  [done] g0_Achieved : 20;
  [done] g1a_Achieved : 12;
  [done] g1b_Achieved : 0;
  [done] g2_Achieved : 10;
  [done] g3_1_Achieved : 5;
  [done] g3_2_Achieved : 6;
  [done] g4_1_Achieved : 7;
  [done] g4_2_Achieved : 2;
  [done] g5_Achieved : 6;
  [done] g6_1_Achieved : 10;
  [done] g6_2_Achieved : 6;
endrewards

rewards "cost"
  [done] g0_Achieved : 0;
  [done] g1a_Achieved : 0;
  [done] g1b_Achieved : 0;
  [done] g2_Achieved : 5;
  [done] g3_1_Achieved : 3;
  [done] g3_2_Achieved : 12;
  [done] g4_1_Achieved : 4;
  [done] g4_2_Achieved : 2;
  [done] g5_Achieved : 5;
  [done] g6_1_Achieved : 3;
  [done] g6_2_Achieved : 2;
endrewards
