#!/bin/bash

###############################################################################
# NAME
#   vmd_box_dims.sh
# AUTHOR
#   Benjamin D. Madej
# SYNOPSIS
#
# DESCRIPTION
#   Measures the distance between the maximum and minimum coordinates of the
#   PDB structure in the X, Y, and Z dimensions
# OPTIONS
#   -i
#     input_structure.pdb
#       PDB format molecular structure to be read by VMD
#   -s
#     vmd_selection
#       Text used for selecting atoms in VMD to measure box dimensions
###############################################################################

while getopts ":i:s:" opt; do
  case $opt in
    i)
      input_structure=$OPTARG
      ;;
    s)
      vmd_selection=$OPTARG
      ;;
  esac
done

cat << EOF > water_box_dims.tcl
mol new $input_structure
set sel [ atomselect top "$vmd_selection" ]
set dims [ measure minmax \$sel ]
puts "Dimensions: \$dims"
quit
EOF

vmd -dispdev text -nt -e water_box_dims.tcl > water_box_dims.txt

x_min=`grep Dimensions water_box_dims.txt | awk '{print $2}' | sed 's/{//'`
y_min=`grep Dimensions water_box_dims.txt | awk '{print $3}'`
z_min=`grep Dimensions water_box_dims.txt | awk '{print $4}' | sed 's/}//'`
x_max=`grep Dimensions water_box_dims.txt | awk '{print $5}' | sed 's/{//'`
y_max=`grep Dimensions water_box_dims.txt | awk '{print $6}'`
z_max=`grep Dimensions water_box_dims.txt | awk '{print $7}' | sed 's/}//'`
x_diff=`echo "$x_max - $x_min" | bc`
y_diff=`echo "$y_max - $y_min" | bc`
z_diff=`echo "$z_max - $z_min" | bc`
echo $x_diff, $y_diff, $z_diff
rm water_box_dims.tcl water_box_dims.txt
