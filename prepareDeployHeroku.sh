#!/bin/bash

pub upgrade

rm -f web/*.js
rm -f web/*.js.*

dart2js web/client/index.dart -o    web/client/index.dart.js
dart2js web/client/register.dart -o web/client/register.dart.js
dart2js web/client/login.dart -o web/client/login.dart.js
dart2js web/client/traceAnalysis.dart -o  web/client/traceAnalysis.dart.js

git config --global user.email "support@drone.io"
git config --global user.name "Drone Server"
git status 

git add web/client/*.dart.js
git add web/client/*.dart.js.deps
git add web/client/*.dart.js.map
git add web/client/*.dart.precompiled.js
git commit -m "add compiled files"

