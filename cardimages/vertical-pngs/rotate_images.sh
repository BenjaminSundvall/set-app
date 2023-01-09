for szFile in ./*.png
do
    convert "$szFile" -rotate -90 ./"$(basename "$szFile")" ;
done
