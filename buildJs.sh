#!/bin/bash


rm -rf out
mkdir out
cp -r web/* out

dart2js web/client/index.dart    -o out/client/index.dart.js
dart2js web/client/register.dart -o out/client/register.dart.js
dart2js web/client/login.dart -o out/client/login.dart.js
dart2js web/client/mock.dart -o out/client/mock.dart.js
dart2js web/client/traceAnalysis.dart -o  out/client/traceAnalysis.dart.js
