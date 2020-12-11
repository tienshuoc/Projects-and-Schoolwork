for i in $(seq 0 10)
do
    FILE=$(ls test)
    python3 test/$FILE
done
