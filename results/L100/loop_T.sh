
#0.05 0.075 
for T in  0.5 0.4 0.3 0.25 0.1 0.075 0.05
do
    echo "T="$T
    filename=EP_$T.dat
    ./main.out $T 1 10 100 1000000 100>$filename
done
