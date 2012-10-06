#!/bin/bash

if [ "x$1" = "x" ]
then
        echo "Please run this script with the project directory (which contains src, bin, libs, ...) as first parameter!"
        echo "Using ./ as project directory..."
        $0 ./
        exit 0
fi

if [ "x$2" = "x" ]
then
	echo "Please run this script with the output directory as second parameter!"
	echo "Using ./doc/javadoc/ as output directory..."
	$0 "$1" ./doc/javadoc/
	exit 0
fi

for x in src bin doc scripts
do
	if [ "x$x" = "x"$(basename $(pwd)) ]
	then
		cd ..
	fi
done
pwd


export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
export doclet="-doclet com.google.doclava.Doclava -docletpath $(dirname $0)/doclava-1.0.6.jar -bootclasspath $JAVA_HOME/jre/lib/rt.jar"
export federate='-federate Android http://developer.android.com/reference -federationxml Android http://doclava.googlecode.com/svn/static/api/android-10.xml'
mkdir -p $2/
javadoc -hdf project.name "FreeHAL Android App" -d $2/ $doclet $federate $(find $1/src $1/gen -name "*.java") \
	-classpath .:$2:$(for x in $(find libs -name "*.jar"); do echo -n ":$x"; done)

