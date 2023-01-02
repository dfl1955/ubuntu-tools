#!/usr/bin/wish


# I have 22 44 & 88 size images
set imagefile ./cut44.png
set imagefile ./chat44.png
image create photo imgobj -file $imagefile
pack [label .myLabel ]
.myLabel configure -image imgobj 
