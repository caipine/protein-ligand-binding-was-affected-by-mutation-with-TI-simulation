#!/bin/tcsh -fe
source Z.0000.set_system.csh_2ITO
foreach ligand (`cat ligand.list`)
cd ${system_outside}/${rec_name}.${ligand}
mkdir setup
cd setup
####################
cat <<EOFA >001.ptraj.strip.protein_lig.in
parm      ${system_outside}/${rec_name}.${ligand}/setup/complex.parm7 
trajin    ${system_outside}/${rec_name}.${ligand}/setup/complex.rst7 
strip :${lig_resid} outprefix stripped_lig
trajout   ${system_outside}/${rec_name}.${ligand}/setup/protein.rst7
trajout   ${system_outside}/${rec_name}.${ligand}/setup/protein.pdb pdb
EOFA
####################
cpptraj -i 001.ptraj.strip.protein_lig.in

end


cp stripped_lig.complex.parm7 protein.parm7
