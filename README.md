#  To Predict Drug Resistance Caused by EGFR T790M Mutant with TI Simulations

This is the script to run TI simulation with AMBER18 pmemd GPU version (much faster relative to CPU version) for side–chain mutations. (Modified from amber tutorial "Small molecule binding to T4-lysozyme L99A")

I will investigate here what happens to binding to anti-tumor drug Gefitinib and WZ4002 in EGFR (PDB ID 2ITO and 3IKA) when wild EGFR was mutated T790 to M790, which happened in some patients after Gefitinib treatment for while; T790M cells is resistant to Gefitinib treatment. WZ4002 is an EGFR selective inhibitor targeting cancers which express the T790M mutation. WZ4002 suppresses Gefitinib resistant cancer cell lines in vitro. I hypothesize that mutating this residue to Methionine will have a destabilizing effect to Gefitinib (but not WZ4002) due to steric clashes.

The result suggests that T790 is favored over M790 mutant by about 5 kcal/mol in EGFR-Gefitinib complex; M790 mutant is favored over T790 by about 2 kcal/mol in EGFR-WZ4002 complex. This calculation successful explained why M790 mutant cell is resistant to Gefitinib, but drug WZ4002 still can kill tumor cells with T790M mutant. TI simulation can predict the relative drug binding affinity between wild type and mutant, it may be useful for personalized medicine.

In drug development, TI simulation can be used in drug design or lead optimization. 

![](./2ITO.jpg)

#
#

#

#

![](./3ika.jpg)






