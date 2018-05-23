for entry in config/*;
do
    SUBSTR=$(echo "$entry" | cut -d'/' -f 2 | cut -d'.' -f 1)
    FOLDER=`date +%Y-%m-%d`
    if ! [ -d "experiment/$FOLDER" ]; then
      mkdir experiment/$FOLDER
    fi
    nohup python pylm_scripts/client.py $entry experiment/$FOLDER/$SUBSTR.csv &> logs/client/$SUBSTR.out&
done
