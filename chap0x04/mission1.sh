#!/usr/bin/env bash

#dir='pwd'
#echo $dir

# help 
function helps {
	      echo "the options:" 
	      echo "-c     input quality to compress JPEG images"
	      echo "-h     get the help of the operations"
	      echo "-t     turn all png/svg images into JPEG"
	      echo "-s     input size to resize the JPEG/PNG/SVG images"
	      echo "-a     add text into the images"
	      echo "-n     rename all the PNG/SVG images"
}

# compress JPEG images
function compressJPEG {
	quality=$1
	for file in `ls images`
	do
	  extension=${file##*.}
	 #echo $extension
	  if [[ $extension == "jpg" ]];then
                  echo $file
		  echo "compressing...";
		  out=compress_$file
		  convert -quality $quality"%" $file $out
	  fi
	done
}

# resize the images while keeping original aspect ratio
function resize {
	size=$1
	for images in `ls images`;
	do
	  extension=${images##*.}
	  if [[ $extension == "jpeg" ]] || [[ $extension == "png" ]] || [[ $exyension == "svg" ]];then
	  out=resize_$images
	  echo $images
	  echo "resizing...";
	  convert -sample $size"%x"$size"%" $images $out
    fi
    done
}

# adding text to all the images
function add_text {
	color=$1
	size=$2
	text=$3
	for images in `ls images`;
	do
	  extension=${images##*.}
	  if [[ $extension == "jpeg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
	  echo $images
	  echo "adding text....";
          out=draw_${images%.*}.${images##*.}
	  convert -fill $color -pointsize $size -draw "text 16,80 '$text'" $images $out
  fi
  done
}  

# converting other images into JPEG images
function converting {
	for images in `ls $dir`;
	do
	  extension=${images##*.}
	  if [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
	  out=type_${images%.*}.jpeg
	  echo $out
	  echo "converting...";
	  convert $images $out
  fi
  done
}

# renaming all the images
function rename {
        new_name=$1
	for file in `ls images`;
	do
	  extension=${file##*.}
	  if [[ $extension == "jpeg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
          echo $file
	  out=$new_name.${file##*.}
	  echo $out
	  echo "renaming...";
	  convert $file $out
  fi
  done
}

# main function
while [[ "$#" -ne 0 ]];do
 case $1 in
        "-c")
		compressJPEG $2
		shift 2;;
	"-s")
		resize $2
		shift 2;;
	"-h")
		helps
		shift;;
	"-a")
		add_text $2 $3 $4
		shift 4;;
	"-t")
		converting
		shift;;
	"-n")
		rename $2
                shift 2;;
        "*") 
                echo "Input error!"
      shift;;
             esac
done

