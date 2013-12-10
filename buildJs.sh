#!/bin/bash


rm -rf out
mkdir out
cp -r web/* out

dart2js web/client/index.dart    -o out/client/index.dart.js
dart2js web/client/register.dart -o out/client/register.dart.js
dart2js web/client/login.dart -o out/client/login.dart.js
dart2js web/client/traceAnalysis.dart -o  out/client/traceAnalysis.dart.js
dart2js web/client/traceAddForm.dart -o  out/client/traceAddForm.dart.js
dart2js web/client/traceSearch.dart -o  out/client/traceSearch.dart.js
dart2js web/client/largeDisplay.dart -o  out/client/largeDisplay.dart.js

