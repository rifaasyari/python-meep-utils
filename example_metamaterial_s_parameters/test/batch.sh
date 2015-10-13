#!/bin/bash
if [ -z $NP ] ; then NP=2 ; fi             # number of processors
model=SphereArray
cellsize=300e-6
thz=1e12
mpirun -np $NP ../../scatter.py model=Slab fillfraction=.1 resolution=5u simtime=50p cellsize=$cellsize padding=100e-6 epsilon=4
../../effparam.py
mpirun -np $NP ../../scatter.py model=Slab fillfraction=.1 resolution=5u simtime=50p cellsize=$cellsize padding=100e-6 epsilon=9
../../effparam.py
mpirun -np $NP ../../scatter.py model=Slab fillfraction=.1 resolution=5u simtime=50p cellsize=$cellsize padding=100e-6 epsilon=16
../../effparam.py

sharedoptions='effparam/*.dat --paramname comment --paramlabel none --figsizey 2 --xeval x/1e12  --ylim1 0'

../../plot_multiline.py $sharedoptions --xlabel "Frequency (THz)" --ycol '|r|' \
   	--ylabel 'Reflectance   $|r|$' --output ${PWD##*/}_r.pdf --color RdYlBu

../../plot_multiline.py $sharedoptions --xlabel "Frequency (THz)" --ycol '|t|' \
   	--ylabel 'Transmittance $|t|$' --figsizey 2 --output ${PWD##*/}_t.pdf --color RdYlBu_r

../../plot_multiline.py $sharedoptions --xlabel "Frequency (THz)" --ycol 'real N' --ylim2 5. \
   	--ylabel 'Refractive index $N_{\text{eff}}^\prime$' --output ${PWD##*/}_nr.pdf --color PiYG_r \
    --overlayplot "c/2/$cellsize/x/$thz,2*c/2/$cellsize/x/$thz,3*c/2/$cellsize/x/$thz"

../../plot_multiline.py $sharedoptions --xlabel "Frequency (THz)" --ycol 'imag N' --ylim2 5. \
   	--ylabel 'Refractive index $N_{\text{eff}}^{\prime\prime}$' --output ${PWD##*/}_ni.pdf --color PiYG_r


