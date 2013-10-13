#!/bin/bash

rm -rf out
mkdir out
cp -r web/* out

dart2js web/index.dart -o out/index.dart.js

