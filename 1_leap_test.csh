#!/bin/sh
#
# Method 1: setup for a fully dual-topology side chain residue
#


source Z.0000.set_system.csh_2ITO

foreach ligand (`cat ligand.list`)
cd ${system_outside}/${rec_name}.${ligand}
mkdir setup
cd setup
parmchk2      -i ${system_outside}/running_docked_scored_ligands/${ligand}.mol2  -f mol2 -o ${ligand}.precharged.frcmod
####################
cat <<EOFA >tleap.in
# load the AMBER force fields
source $AMBERHOME/dat/leap/cmd/oldff/leaprc.ff14SB
source leaprc.gaff

# load force field parameters for ligand
loadAmberParams frcmod.ionsjc_tip3p
loadAmberParams ${ligand}.precharged.frcmod

# load the coordinates and create the systems
ligand = loadmol2 ${system_outside}/running_docked_scored_ligands/${ligand}.mol2
m1 = loadpdb ${system_outside}/001.protein/${rec_0}
m2 = loadpdb ${system_outside}/001.protein/${rec_1}
#w =  loadpdb ${system_outside}/${rec_name}.${ligand}/002.tleap_build/water_ions.pdb

complex = combine {m1 m2 ligand}
complex1 = combine {m1 ligand}
complex2 = combine {m2 ligand}
source leaprc.protein.ff14SB
source leaprc.water.tip3p
charge complex #3.0
charge complex1 #3.0
charge complex2 #3.0

solvateoct complex TIP3PBOX 12.0
#addions complex  Na+ 0
addions complex  Cl- 4
charge  complex #0.0


set default nocenter on


# create complex in solution
savepdb complex complex.pdb
saveamberparm complex complex.parm7 complex.rst7

quit


EOFA
####################
tleap -f tleap.in


