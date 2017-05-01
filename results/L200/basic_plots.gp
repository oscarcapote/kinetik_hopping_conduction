
set terminal postscript eps enhanced color
set output 'energy150.eps'

set title 'Energy for L=150'
set ylabel 'Energy'
set xlabel 'Time'
set logscale x


plot 'EP_0.5.dat' t 'T=0.5' w l ,'EP_0.4.dat' t 'T=0.4' w l  ,'EP_0.3.dat' t 'T=0.3' w l ,'EP_0.25.dat' t 'T=0.25' w l ,'EP_0.1.dat' t 'T=0.1' w l ,'EP_0.075.dat' t 'T=0.075' w l ,'EP_0.05.dat' t 'T=0.05' w l



reset
set output 'polarization150.eps'

set title 'Polarization for L=150'
set ylabel 'Polarization'
set xlabel 'Time'
unset logscale


plot 'EP_0.5.dat' u 1:3 t 'T=0.5' w l ,'EP_0.4.dat' u 1:3 t 'T=0.4' w l ,'EP_0.3.dat' u 1:3 t 'T=0.3' w l ,'EP_0.25.dat' u 1:3 t 'T=0.25' w l ,'EP_0.1.dat' u 1:3 t 'T=0.1' w l ,'EP_0.075.dat' u 1:3 t 'T=0.075' w l ,'EP_0.05.dat' u 1:3 t 'T=0.05' w l
