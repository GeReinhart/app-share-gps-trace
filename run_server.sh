#!/bin/bash

rm -rf out
mkdir out
cp -r web/* out

dart2js web/indexdart.dart -o out/indexdart.dart.js

dart out/server_dev.dart


