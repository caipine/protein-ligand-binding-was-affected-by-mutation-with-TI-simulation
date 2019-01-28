#!/bin/tcsh -fe
source 00.source.sh

cd ${system}/${main_folder}/
mkdir 002.tleap_build
mkdir 003.equilibration_production
mkdir 004.PTRAJ

cd 002.tleap_build
cp ${system}/${main_folder}/${lig} ${system}/${main_folder}/002.tleap_build
module load amber

parmchk2      -i ${lig}  -f mol2 -o ${lig}.precharged.frcmod

####################
cat <<EOFA >tleap.wet.in

#source /opt/apps/intel16/cray_mpich_7_3/amber/16.0/dat/leap/cmd/oldff/leaprc.ff14SB 
source leaprc.gaff
source leaprc.phosaa10
loadamberparams ${lig}.precharged.frcmod
set default PBradii mbondi3
lig =  loadmol2    ${lig}                                      
charge lig # 1.0
saveamberparm  lig    ${lig_name}.gas.prmtop    ${lig_name}.gas.rst7

#source /opt/apps/intel16/cray_mpich_7_3/amber/16.0/dat/leap/cmd/leaprc.protein.ff14SB
source leaprc.protein.ff14SB
source leaprc.water.tip3p
loadamberparams frcmod.ionsjc_tip3p
rec = loadpdb ${system}/001.protein/${rec}
charge rec #3.0
saveamberparm rec ${rec_name}.rec.gas.prmtop ${rec_name}.rec.gas.rst7


solvcomplex = combine {rec lig}
charge solvcomplex #4.0
#solvateoct solvcomplex TIP3PBOX 12.0
solvatebox solvcomplex TIP3PBOX 8.0 
addions solvcomplex  Na+ 0
addions solvcomplex  Cl- 0
charge solvcomplex #0.0
savepdb solvcomplex ${rec_name}.${lig_name}.wet.complex.pdb
saveamberparm solvcomplex ${rec_name}.${lig_name}.wet.complex.prmtop ${rec_name}.${lig_name}.wet.complex.rst7


EOFA
########################

tleap -s -f tleap.wet.in > tleap.wet.out



##########
cat <<EOFB >tleap.gas.in
#source /opt/apps/intel16/cray_mpich_7_3/amber/16.0/dat/leap/cmd/oldff/leaprc.ff14SB
source leaprc.gaff
source leaprc.phosaa10
loadamberparams ${lig}.precharged.frcmod
set default PBradii mbondi3
lig =  loadmol2    ${lig}
charge lig # 1.0
saveamberparm  lig    ${lig_name}.gas.prmtop    ${lig_name}.gas.rst7

#source /opt/apps/intel16/cray_mpich_7_3/amber/16.0/dat/leap/cmd/leaprc.protein.ff14SB
source leaprc.protein.ff14SB
source leaprc.water.tip3p
loadamberparams frcmod.ionsjc_tip3p
rec = loadpdb ${system}/001.protein/${rec}
charge rec #3.0
saveamberparm rec ${rec_name}.rec.gas.prmtop ${rec_name}.rec.gas.rst7

gascomplex = combine {rec lig}
savepdb gascomplex ${rec_name}.${lig_name}.gas.complex.pdb
saveamberparm gascomplex ${rec_name}.${lig_name}.gas.complex.prmtop ${rec_name}.${lig_name}.gas.complex.rst7

EOFB
########################

tleap -s -f tleap.gas.in > tleap.gas.out
