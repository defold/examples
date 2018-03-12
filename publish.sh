#!/usr/bin/env bash
#

GSUTIL=".deps/google-cloud-sdk/bin/gsutil"
SHA1=$(curl -s http://d.defold.com/stable/info.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["sha1"]')
BOBURL="http://d.defold.com/archive/$SHA1/bob/bob.jar"
BOB=".deps/bob_$SHA1.jar"

if [ "$(uname)" == "Darwin" ]; then
    GCSDK="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-155.0.0-darwin-x86_64.tar.gz"
fi        

if [ ! -f $BOB ]; then
    mkdir -p .deps
    echo "Installing bob.jar ($SHA1)"
    curl $BOBURL -o $BOB
fi

if [ ! -f $GSUTIL ]; then
    mkdir -p .deps
    echo "Installing Google Cloud SDK..."
    curl $GCSDK | tar -xz -C .deps
fi

BUILDWEB="build/web"
BUILDHTML5="build/default/Defold-examples"

echo "Building web..."
gulp build

echo "Building HTML5 app..."
java -jar "$BOB" --debug --archive --platform js-web resolve distclean build bundle

echo "Publishing build..."
$GSUTIL -m rsync -rd "$BUILDWEB" gs://defold-examples
$GSUTIL -m rsync -rd "$BUILDHTML5" gs://defold-examples/app
$GSUTIL -m rsync -rd "assets/random_images" gs://defold-examples/random_images
