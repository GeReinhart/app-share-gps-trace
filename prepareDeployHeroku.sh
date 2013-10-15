#!/bin/bash

rm -f web/*.js
rm -f web/*.js.*

dart2js web/index.dart -o web/index.dart.js

git config --global user.email "support@drone.io"
git config --global user.name "Drone Server"
git status 

git add web/client/index.dart.*
git commit -m "add compiled files"

