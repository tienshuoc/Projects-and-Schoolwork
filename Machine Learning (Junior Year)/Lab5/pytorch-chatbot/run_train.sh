for i in $(seq 1 50)
do
    FILE_NAME="save/model/Gossiping-QA-Dataset/1-1_512/"$(ls -v save/model/Gossiping-QA-Dataset/1-1_512/ | tail -1)
    echo $FILE_NAME
    srun --gres=gpu:1 -u --x11=first python main.py -tr data/Gossiping-QA-Dataset.txt -l $FILE_NAME -lr 0.0001 -it 50000 -b 64 -p 500 -s 250
done
