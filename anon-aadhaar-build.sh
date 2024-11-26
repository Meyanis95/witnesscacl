#!/bin/bash

DEVELOPMENT_TEAM=""

# cp ../circuits/build/proof_of_passport_cpp/proof_of_passport.cpp witnesscalc/src
# cp ../circuits/build/proof_of_passport_cpp/proof_of_passport.dat witnesscalc/src

# cd ./src
# # This adds the namespace to the circuit file as described in the README
# last_include=$(grep -n '#include' anon-aadhaar.cpp | tail -1 | cut -d: -f1)
# if [[ "$OSTYPE" == "darwin"* ]]; then
#   # macOS requires an empty string with the -i flag and handles backslashes differently
#   sed -i "" "${last_include}a\\
# namespace CIRCUIT_NAME {" anon-aadhaar.cpp
# else
#   # Linux
#   sed -i "${last_include}a \\nnamespace CIRCUIT_NAME {" anon-aadhaar.cpp
# fi
# echo "}" >> anon-aadhaar.cpp

# cd ../../..
# git submodule init
# git submodule update

# cd app/witnesscalc
./build_gmp.sh ios
make ios

cd build_witnesscalc_ios
xcodebuild -project witnesscalc.xcodeproj \
           -scheme aadhaar-verifier \
           -sdk iphoneos \
           -configuration Release \
           DEVELOPMENT_TEAM=$DEVELOPMENT_TEAM \
           ARCHS="arm64" \
           -destination 'generic/platform=iOS' \
           PRODUCT_BUNDLE_IDENTIFIER=org.anonaadhaar.witnesscalc \
           build

           xcodebuild -project witnesscalc.xcodeproj \
           -scheme aadhaar_verifier
           -sdk iphoneos \
           -configuration Release \
           ARCHS="arm64" \
           -destination 'generic/platform=iOS' \
           build
# cd ../..
# cp witnesscalc/build_witnesscalc_ios/src/Release-iphoneos/libwitnesscalc_proof_of_passport.a ios
# mkdir -p ios/ProofOfPassport/Assets.xcassets/proof_of_passport.dat.dataset
# mkdir -p ios/ProofOfPassport/Assets.xcassets/proof_of_passport.zkey.dataset
# cp witnesscalc/src/proof_of_passport.dat ios/ProofOfPassport/Assets.xcassets/proof_of_passport.dat.dataset/proof_of_passport.dat
# cp ../circuits/build/proof_of_passport.zkey ios/ProofOfPassport/Assets.xcassets/proof_of_passport.zkey.dataset/proof_of_passport.zkey