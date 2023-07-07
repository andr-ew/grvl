#!/bin/bash

mkdir build
cd ..
zip -r grvl/build/complete-source-code.zip grvl/ -x "grvl/.git/*" "grvl/lib/lib-grvl/doc/*" "grvl/lib/doc/*" "grvl/build.sh" "grvl/build/*"
