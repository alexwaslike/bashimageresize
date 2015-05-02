#!/bin/bash
# Alexandra Willis awil294 cs410386
# CS4103, Spring 2015 F. Chen

# vars for storing file sizes
sizeOriginalFiles=0
sizeNewFiles=0
# end vars

# if user asks for help
if [ $1 = "help" ]; then
	help
fi
# end if help

# resize image method
resizeImage() {

	# vars for params
	file=$1
	scalar=$2
	dir=$3
	outputDir=$4

	# vars for creating new file name
	original=$(basename $file)
	base="${original%.*}"
	dot='.'
	slash='/'
	dash='-'
	extension="${original##*.}"
	newName=$outputDir$slash$dir$slash$base$dash$scalar$dot$extension
	
	# if dir doesn't exist inside output dir, create it
	if [ ! -d "$outputDir$slash$dir"  ]; then
		mkdir $outputDir$slash$dir
	fi
	# end if
	
	# resize file, save under new file name in file's dir
	convert -resize $scalar% $file $newName
	
	# per-image output
	echo "Name of original: $file"
	originalSize=$(wc -c "$file" | awk '{print $1;}') 
	sizeOriginalFiles=$(($sizeOriginalFiles + $originalSize))
	echo "Original size: $originalSize"
	echo "Resized name: $newName"
	newSize=$(wc -c "$newName" | awk '{print $1;}')
	sizeNewFiles=$(($sizeNewFiles + $newSize))
	echo "New size: $newSize"
	
}
# end resize

# u fucked up method
inputFail() {
	echo "Specified output directory already exists."
	exit 0
}
#

# help method
help() {
	echo "Enter input directory, output directory, and three resize ratios. Input directory must ALREADY exist. Output directory must NOT already exist."
	exit 0
}
# end help

# check if input directory exists
if [ ! -d "$1"  ]; then
	help
else
	input="$1"
fi
# end check input dir

# check if output directory exists
if [ ! -d "$2"  ]; then
	echo -e "Creating output directory $2"
	mkdir "$2"
	output="$2"
	slash="/"
	mkdir $output$slash$input	
else
	inputFail
fi
# end check output dir

# loop through all directories in input dir
numFiles=0
for dir in $( find $input -type d );
do	
	# make sure not in top level dir
	if [ ! $input == $dir  ];
	then
		echo "Inside directory $dir"
		# loop through all files in each directory
		for file in $( find $dir -type f );
		do
			# loop through all scalars provided
			for scalar in $3 $4 $5
			do
				resizeImage $file $scalar $dir $output
				((numFiles++))
			done
			# end scalar loops	
		done
		# end file loop
	fi
	# end check
done
#end dir loop

# after-resizing output
echo "Total files processed: $numFiles"
echo "Total size of original files: $sizeOriginalFiles"
echo "Total size of new files: $sizeNewFiles"
#
