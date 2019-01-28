#!/bin/tcsh -fe
source Z.0000.set_system.csh_2ITO

foreach ligand (`cat ligand.list`)
echo $PWD
cd ${rec_name}.${ligand}
echo $PWD
source 00.source.sh

cd 002.tleap_build
####################
cat <<EOFA >001.ptraj.strip.protein_lig.in
parm      ${system}/${main_folder}/002.tleap_build/${rec_name}.${lig_name}.wet.complex.prmtop 
trajin    ${system}/${main_folder}/002.tleap_build/${rec_name}.${lig_name}.wet.complex.rst7 
strip :1-${lig_resid} outprefix stripped_water.complex
trajout   ${system}/${main_folder}/002.tleap_build/water_ions.pdb pdb
EOFA
####################
cpptraj -i 001.ptraj.strip.protein_lig.in

end

