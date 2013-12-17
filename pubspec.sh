#!/bin/bash

# Need to copy real libraries directories in to packages directory AND commit them
# to be able to 

CACHE=/home/reinhart/.pub-cache/hosted/pub.dartlang.org
PACKAGES=packages

if  [ -d "$2" ]; then
   CACHE=$1
   PACKAGES=$2
fi


copyFromCache(){
  libName=$1
  libVersion=$2 
  rm -rf $PACKAGES/$libName
  cp -r $CACHE/$libName-$libVersion/lib $PACKAGES
  mv $PACKAGES/lib $PACKAGES/$libName
  
}


copyFromCache "args" "0.9.0"
copyFromCache "bootjack" "0.6.1+7"
copyFromCache "browser" "0.9.0"
copyFromCache "bson" "0.1.15"
copyFromCache "crypto" "0.9.0"
copyFromCache "dquery" "0.5.3+5"
copyFromCache "http_server" "0.9.0"
copyFromCache "js" "0.2.0"
copyFromCache "logging" "0.9.0"
copyFromCache "mime" "0.9.0"
copyFromCache "mongo_dart" "0.1.35"
copyFromCache "mongo_dart_query" "0.1.11"
copyFromCache "path" "0.9.0"
copyFromCache "rikulo_commons" "1.0.0"
copyFromCache "rikulo_security" "0.6.1"
copyFromCache "stack_trace" "0.9.0"
copyFromCache "stream" "1.0.0"
copyFromCache "unittest" "0.9.0"
copyFromCache "unmodifiable_collection" "0.9.0"
copyFromCache "petitparser" "1.0.0"


