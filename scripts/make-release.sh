ROOT=".build/insert_dylib.xcarchive/Products/"
PLATAFORMS=("iOS" "iOS Simulator")
BUILD_COMMIT=$(git log --oneline --abbrev=16 --pretty=format:"%h" -1)
NAME=insert_dylib.${BUILD_COMMIT}.zip
VERSION=1.0
REPO=exception7601/insert_dylib
ARCHIVE_NAME=insert_dylib
ARCHIVE_PATH=.build/insert_dylib.xcarchive
BIN_PATH=usr/local/bin/insert_dylib

ORIGIN=$(pwd)

set -e 
rm -rf $ROOT

xcodebuild \
  -scheme ${ARCHIVE_NAME} \
  -configuration Release \
  -sdk macosx \
  archive \
  -archivePath ${ARCHIVE_PATH}

cd "$ROOT"

# # Crie o arquivo zip
zip -rX "$NAME" "${BIN_PATH}"
mv "$NAME" "$ORIGIN"
cd "$ORIGIN"

# Upload Version in Github
SUM=$(swift package compute-checksum ${NAME} )
BUILD=$(date +%s) 
NEW_VERSION=${VERSION}.${BUILD}
echo $NEW_VERSION > version

git commit -m "new Version ${NEW_VERSION}"
git tag -s -a ${NEW_VERSION} -m "v${NEW_VERSION}"
git push origin HEAD --tags
gh release create ${NEW_VERSION} ${NAME} --notes "checksum \`${SUM}\`"
