#!/bin/bash
# Regenerate Packages + Packages.gz and push to GitHub
cd "$(dirname "$0")"

echo "[*] Scanning packages..."
dpkg-scanpackages debs /dev/null 2>/dev/null > Packages

# If dpkg-scanpackages not available, use the manual Packages file
if [ ! -s Packages ]; then
  echo "[!] dpkg-scanpackages failed or not installed, keeping existing Packages file"
fi

echo "[*] Compressing..."
gzip -kf Packages

echo "[*] Committing..."
git add .
git commit -m "Update repo: $(date '+%Y-%m-%d %H:%M')"
git push

echo "[+] Done! Repo updated."
