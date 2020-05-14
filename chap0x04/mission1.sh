#!/usr/bin/env bash`

#dir='pwd'
#echo $dir
shopt -s nullglob
#images_list=/home/azurehpz/shell-example/images
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
	quality=$2
	for file in `ls $1`;
	do
	  extension=${file##*.}
	 #echo $extension
	  if [[ $extension == "jpeg" ]];then
                  echo $file
		  echo "compressing...";
		  out=$1/compress_$file
		  convert -quality $quality"%" $1/$file $out
	  fi
	done
}

# resize the images while keeping original aspect ratio
function resize {
	size=$2
	for images in `ls $1`;
	do
	  extension=${images##*.}
	  if [[ $extension == "jpeg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
	  out=$1/resize_$images
	  echo $images
	  echo "resizing...";
	  convert -resize ${size} $1/$images $out
    fi
    done
}

# adding text to all the images
function add_text {
	color=$2
	size=$3
	text=$4
	for images in `ls $1`;
	do
	  extension=${images##*.}
	  if [[ $extension == "jpeg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
	  echo $images
	  echo "adding text....";
          out=$1/draw_${images%.*}.${images##*.}
	  convert -fill $color -pointsize $size -draw "text 16,80 '$text'" $1/$images $out
  fi
  done
}  

# converting other images into JPEG images
function converting {
	for images in `ls $1`;
	do
	  extension=${images##*.}
	  if [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
	  out=$1/type_${images%.*}.jpeg
	  echo $out
	  echo "converting...";
	  convert $1/$images $out
  fi
  done
}

# renaming all the images
function rename {
        new_name=$2
	for file in `ls $1`;
	do
	  extension=${file##*.}
	  if [[ $extension == "jpeg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
          echo $file
	  out=$1/$new_name.${file##*.}
	  echo $out
	  echo "renaming...";
	  convert $1/$file $out
  fi
  done
}

dir=""

if [[ $# -lt 1 ]];then
        echo "Please enter your command."
else
# main function
        while [[ $# -ne 0 ]];do
                case $1 in
                        "-d")
                             dir="$2"
                             shift 2
                             ;;
                        "-c")
		             compressJPEG $dir $2
	                     shift 2;;
                	"-s")
		             resize $dir $2
		             shift 2;;
	                "-h")
		             helps
		             shift;;
	                "-a")
		             add_text $dir $2 $3 $4
		             shift 4;;
	                "-t")
		             converting $dir
		             shift;;
	                "-n")
		             rename $dir $2
                             shift 2;;
                        "*") 
                             echo "Input error!"
                    shift;;
             esac
       done
fi
