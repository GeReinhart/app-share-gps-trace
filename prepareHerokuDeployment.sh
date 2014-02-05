#!/bin/bash

function get-dart-dependencies {
	echo "get-dart-dependencies"
	pub get || { echo 'get-dart-dependencies failed' ; exit 1; }
}

function test-dart-sources {
	echo "test-dart-sources"
	dart test/test_runner.dart || { echo 'test-dart-sources failed' ; exit 1; }
}

function prefix-assets {
	prefixFile=`date +"%Y%m%d%H%M%S"`
	echo "prefix is $prefixFile"

	clientDir="web/client/pages"
	clientFiles=`grep -r "main()" $clientDir   | grep -v packages |  awk -F":" '{print $1}' | awk -F"/" '{print $4}' `

	for clientFile  in $clientFiles
	do
    		cp "$clientDir/$clientFile" "$clientDir/$prefixFile-$clientFile"
	done
	cp "web/assets/css/app-share-gps-trace.css" "web/assets/css/$prefixFile-app-share-gps-trace.css"

	viewDir="web/rsp"
	viewFiles=`grep -r "type=\"application/dart\"" "$viewDir" | grep -v packages | awk -F":" '{print $1}' `

	for viewFile  in $viewFiles
	do
   		sed -i "s:src=\"/client/pages/:src=\"/client/pages/$prefixFile-:" "$viewFile"
	done
	sed -i "s:app-share-gps-trace.css:$prefixFile-app-share-gps-trace.css:" "web/rsp/templates/assetsimports.html"
}

function dart-2-js {

	echo "dart-2-js"
	clientDir="web/client/pages"
	clientFiles=`grep -r "main()" $clientDir   | grep -v packages |  awk -F":" '{print $1}' | awk -F"/" '{print $4}' `

	for clientFile  in $clientFiles
	do
            echo "dart2js on $clientDir/$clientFile"
	    dart2js "$clientDir/$clientFile" -o "$clientDir/$clientFile.js" || { echo 'dart-2-js failed' ; exit 1; }
	done
}


function commit-changes {

	echo "commit-changes"
	git config --global user.email "support@drone.io"
	git config --global user.name "Drone Server"
	git status 
	git add .
	git commit -m "add compiled and prefixed files" || { echo 'commit-changes' ; exit 1; }

}

get-dart-dependencies 
test-dart-sources
prefix-assets
dart-2-js
commit-changes


