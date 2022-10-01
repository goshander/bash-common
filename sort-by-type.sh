#!/bin/bash

echo "create directories..."
mkdir torrents
mkdir documents
mkdir music
mkdir images
mkdir videos
mkdir archives
mkdir applications

echo "move torrents..."
mv *.torrent torrents

echo "move docs..."
mv *.docx documents
mv *.doc documents
mv *.pdf documents
mv *.xls documents
mv *.txt documents
mv *.xls documents
mv *.xlsx documents
mv *.csv documents
mv *.odt documents
mv *.psd documents
mv *.ppt documents
mv *.pptx documents

echo "move music..."
mv *.mp3 music
mv *.ogg music
mv *.wav music

echo "move images..."
mv *.jpg images
mv *.jpeg images
mv *.png images
mv *.bmp imagess
mv *.gif images
mv *.svg images

echo "move videos..."
mv *.mp4 videos
mv *.wmv videos
mv *.avi videos
mv *.mkv videos

echo "move archives..."
mv *.7z archives
mv *.rar archives
mv *.zip archives
mv *.gz archives
mv *.bz2 archives

echo "move apps..."
mv *.exe applications
mv *.msi applications
mv *.deb applications
mv *.apk applications
