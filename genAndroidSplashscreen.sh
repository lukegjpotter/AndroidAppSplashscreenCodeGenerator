#/bin/bash
#--------------------------------------
#
#		genAndroidSplashscreen.sh
#
#		Author: Luke Potter
#		GitHub: lukegjpotter
#
#		Date: 31/Jan/2013
#
#--------------------------------------
#		Version: 1.0
#--------------------------------------
#
#		Description:
#			A script to generate the
#			code required for a splash
#			screen for an Android app.
#
#--------------------------------------

# Functions

# A function to change the package name to a directory structure
# ARGS:
#	string in the form of com.mycompany.app.appname
# RETURNS:
#	string in the form of /com/mycompany/app/appname
function package_to_string {
	
	out=""
	arr=$(echo $1 | tr "." "\n")

	for x in $arr
	do
		out="$out/$x"
	done
	
	echo $out
}

# A function to evaluate the arguments
function evaluate_args {
	
	error="coolbeans"
	
	# Check number of args
	if [ $# != 3 ];then
		error="error"
	fi
	
	# Check if $2 is a directory
	if [ ! -d $2 ];then
		error="error"
	fi
	
	# Check if $3 is a file
	if [ ! -f $3 ];then
		error="error"
	fi
	
	# Evaluate weather to print the usage and exit
	if [ "$error" == "error" ];then
		
		echo "    [ERROR]   Incorrect usage!"
		echo " Usage is:"
		echo "   ./genAndroidSplashscreen.sh PACKAGE PATH_TO_APP PATH_TO_IMAGE"
		echo "       PACKAGE:       com.mycompany.app.appname"
		echo "       PATH_TO_APP:   /User/dude/Desktop/App"
		echo "       PATH_TO_IMAGE: /User/dude/Desktop/image.png"
		
		exit $BAD_ARGS
	fi
}

# A function to populate the SplashscreenActivity.java file
function put_text_in_java_file {
	
	touch $JAVA_Location
	packageText="package $AppPackage;"
	
	echo $packageText > $JAVA_Location
	echo "" >> $JAVA_Location
	cat $JAVA_FILE >> $JAVA_Location
}

# A function to populate the activity_splashscreen.xml layout file
function put_text_in_xml_file {
	
	touch $XML_Location
	cat $XML_FILE > $XML_Location
}

# A function to put the supplied image in the app's drawable folder 
function put_image_in_img_location {
	
	cp $SplashImagePath $IMG_Location
}

# A function 
function print_end_message {
	cat resources/manifestfile
}

#--------------------------------------
# Main
#--------------------------------------

# Constants
SUCCESS=0
BAD_ARGS=1

# A call to the function to evaluate the arguments
evaluate_args $@

JAVA_FILE=resources/javafile
XML_FILE=resources/xmlfile

# Arguments
AppPackage=$1
ApplicationRootDir=$2
SplashImagePath=$3

# File structure
stringpackage=$(package_to_string)
JAVA_Location=$ApplicationRootDir/src$stringPackage/SplashscreenActivity.java
XML_Location=$ApplicationRootDir/res/layout/activity_splash.xml
IMG_Location=$ApplicationRootDir/res/drawable-hdpi/

# Stagelist
put_text_in_java_file
put_text_in_xml_file
put_image_in_img_location
print_end_message

# exit successfully
exit $SUCCESS # Awesome sauce
