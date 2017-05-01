
cat <<EOF > basic_plots2.gp
set terminal postscript enhanced color

set output 'energy.ps'

set ylabel 'Energy for L=50'
set xlabel 'Time'
set logscale x

EOF
