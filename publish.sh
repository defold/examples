#!/usr/bin/env bash
#

BOB=".deps/bob.jar"
GSUTIL=".deps/google-cloud-sdk/bin/gsutil"
BOBURL="http://d.defold.com/archive/298b7ce75a1386a26124061dbccfa822df9bc982/bob/bob.jar"

if [ "$(uname)" == "Darwin" ]; then
    GCSDK="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-155.0.0-darwin-x86_64.tar.gz"
fi        

if [ ! -f $BOB ]; then
    mkdir -p .deps
    echo "Installing bob.jar"
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

# Remove zero size png that makes bob choke.
rm .deps/google-cloud-sdk/platform/gsutil/third_party/httplib2/ref/img2.png

echo "Building HTML5 app..."
java -jar "$BOB" --debug --archive --platform js-web resolve distclean build bundle

echo "Publishing build..."
$GSUTIL -m rsync -rd "$BUILDWEB" gs://defold-examples
$GSUTIL -m rsync -rd "$BUILDHTML5" gs://defold-examples/app
