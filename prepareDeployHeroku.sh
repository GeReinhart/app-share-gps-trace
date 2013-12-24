#!/bin/bash

pub upgrade
dart test/test_runner.dart

rm -f web/*.js
rm -f web/*.js.*



prefixFile=`date +"%Y%m%d%H%M%S"`

echo "prefix is $prefixFile"

clientDir="web/client"
clientFiles=`grep -r "main()" $clientDir   | grep -v packages |  awk -F":" '{print $1}' | awk -F"/" '{print $3}' `

for clientFile  in $clientFiles
do
    cp "$clientDir/$clientFile" "$clientDir/$prefixFile-$clientFile"
    dart2js "$clientDir/$prefixFile-$clientFile" -o "$clientDir/$prefixFile-$clientFile.js"
done
cp "web/assets/css/app-share-gps-trace.css" "web/assets/css/$prefixFile-app-share-gps-trace.css"


viewDir="web/rsp"
viewFiles=`grep -r "type=\"application/dart\"" "$viewDir" | grep -v packages | awk -F":" '{print $1}' `

for viewFile  in $viewFiles
do
   sed -i "s:src=\"/client/:src=\"/client/$prefixFile-:" "$viewFile"
done
sed -i "s:app-share-gps-trace.css:$prefixFile-app-share-gps-trace.css:" "web/rsp/templates/assetsimports.html"

git config --global user.email "support@drone.io"
git config --global user.name "Drone Server"
git status 

git add .
git commit -m "add compiled and prefixed files"

