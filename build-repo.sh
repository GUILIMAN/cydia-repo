#!/bin/bash
# Rebuilds the Cydia repo metadata (Packages, Packages.gz, Packages.bz2, Release).
#
#   Usage:  ./build-repo.sh https://YOUR-USERNAME.github.io/REPO-NAME/
#
# Run this once with your real GitHub Pages URL before pushing (and again any
# time you add/remove a .deb in ./debs or change a depiction page).
set -euo pipefail

BASE_URL="${1:?Usage: ./build-repo.sh https://YOUR-USERNAME.github.io/REPO-NAME/}"
BASE_URL="${BASE_URL%/}/"
cd "$(dirname "$0")"

ORIGIN="Unrestricted Cable Repo"
LABEL="$ORIGIN"
VERSION="1.0"

PACKAGES=Packages
: > "$PACKAGES"

for deb in debs/*.deb; do
    [ -e "$deb" ] || { echo "no debs found in ./debs"; exit 1; }
    pkg="$(dpkg-deb -f "$deb" Package)"
    {
        echo "Package: $(dpkg-deb -f "$deb" Package)"
        name="$(dpkg-deb -f "$deb" Name)";        [ -n "$name" ] && echo "Name: $name"
        echo "Version: $(dpkg-deb -f "$deb" Version)"
        echo "Architecture: $(dpkg-deb -f "$deb" Architecture)"
        echo "Description: $(dpkg-deb -f "$deb" Description)"
        echo "Section: $(dpkg-deb -f "$deb" Section)"
        depends="$(dpkg-deb -f "$deb" Depends)";  [ -n "$depends" ] && echo "Depends: $depends"
        author="$(dpkg-deb -f "$deb" Author)";    [ -n "$author" ] && echo "Author: $author"
        maint="$(dpkg-deb -f "$deb" Maintainer)"; [ -n "$maint" ] && echo "Maintainer: $maint"
        echo "Depiction: ${BASE_URL}depictions/${pkg}.html"
        echo "Icon: ${BASE_URL}icon.png"
        echo "Filename: $deb"
        echo "Size: $(stat -c%s "$deb")"
        echo "MD5sum: $(md5sum "$deb" | cut -d' ' -f1)"
        echo "SHA1: $(sha1sum "$deb" | cut -d' ' -f1)"
        echo "SHA256: $(sha256sum "$deb" | cut -d' ' -f1)"
        echo ""
    } >> "$PACKAGES"
done

gzip -9c  "$PACKAGES" > Packages.gz
bzip2 -9c "$PACKAGES" > Packages.bz2

{
    echo "Origin: $ORIGIN"
    echo "Label: $LABEL"
    echo "Suite: stable"
    echo "Codename: stable"
    echo "Version: $VERSION"
    echo "Architectures: iphoneos-arm"
    echo "Components: main"
    echo "Description: Personal repo — Unrestricted Cable (MFi certification bypass for iOS 8/9)"
    echo "Icons: ${BASE_URL}CydiaIcon.png"
    echo ""
    echo "MD5Sum:"
    for f in "$PACKAGES" Packages.gz Packages.bz2; do
        printf ' %s %8d %s\n' "$(md5sum "$f" | cut -d' ' -f1)" "$(stat -c%s "$f")" "$f"
    done
    echo ""
    echo "SHA1:"
    for f in "$PACKAGES" Packages.gz Packages.bz2; do
        printf ' %s %8d %s\n' "$(sha1sum "$f" | cut -d' ' -f1)" "$(stat -c%s "$f")" "$f"
    done
    echo ""
    echo "SHA256:"
    for f in "$PACKAGES" Packages.gz Packages.bz2; do
        printf ' %s %8d %s\n' "$(sha256sum "$f" | cut -d' ' -f1)" "$(stat -c%s "$f")" "$f"
    done
} > Release

echo "Repo metadata built for: $BASE_URL"
echo "  Packages ($(grep -c '^Package:' "$PACKAGES") package), Packages.gz, Packages.bz2, Release"
