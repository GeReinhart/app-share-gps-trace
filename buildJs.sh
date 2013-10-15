#!/bin/bash


rm -rf out
mkdir out
cp -r web/* out

dart2js web/client/index.dart -o out/client/index.dart.js

