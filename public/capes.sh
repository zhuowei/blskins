for i in `echo lbsg epicmc inpvp`
do
	cpp -P -D CAPE -o ${i}_capes.html $i.html.h
done
