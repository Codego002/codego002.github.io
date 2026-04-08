#!/bin/bash
# Regenerate Packages + Packages.gz and push to GitHub
cd "$(dirname "$0")"

echo "[*] Using manual Packages file (do not overwrite with dpkg-scanpackages)"
if [ ! -s Packages ]; then
  echo "[!] Packages file is empty or missing — cannot continue"
  exit 1
fi

echo "[*] Compressing..."
rm -f Packages.gz Packages.bz2
gzip -k Packages
bzip2 -k Packages

echo "[*] Generating Release..."
P_SIZE=$(wc -c < Packages)
GZ_SIZE=$(wc -c < Packages.gz)
BZ2_SIZE=$(wc -c < Packages.bz2)
P_MD5=$(md5sum Packages | cut -d' ' -f1)
GZ_MD5=$(md5sum Packages.gz | cut -d' ' -f1)
BZ2_MD5=$(md5sum Packages.bz2 | cut -d' ' -f1)
P_SHA256=$(sha256sum Packages | cut -d' ' -f1)
GZ_SHA256=$(sha256sum Packages.gz | cut -d' ' -f1)
BZ2_SHA256=$(sha256sum Packages.bz2 | cut -d' ' -f1)
DATE=$(date -u "+%a, %d %b %Y %H:%M:%S UTC")
cat > Release << EOF
Origin: CodeGo Tweaks
Label: CodeGo Tweaks
Suite: stable
Version: 1.0
Codename: ios
Architectures: iphoneos-arm64
Components: main
Description: CodeGo's iOS Tweaks & Apps Repository
Date: $DATE
MD5Sum:
 $P_MD5 $P_SIZE Packages
 $GZ_MD5 $GZ_SIZE Packages.gz
 $BZ2_MD5 $BZ2_SIZE Packages.bz2
SHA256:
 $P_SHA256 $P_SIZE Packages
 $GZ_SHA256 $GZ_SIZE Packages.gz
 $BZ2_SHA256 $BZ2_SIZE Packages.bz2
EOF

echo "[*] Committing..."
git add .
git commit -m "Update repo: $(date '+%Y-%m-%d %H:%M')"
git push

echo "[+] Done! Repo updated."
