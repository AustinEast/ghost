#!/bin/sh
rm -f ghost.zip
zip -r ghost.zip ghost *.html *.md *.json *.hxml run.n
haxelib submit ghost.zip $HAXELIB_PWD --always