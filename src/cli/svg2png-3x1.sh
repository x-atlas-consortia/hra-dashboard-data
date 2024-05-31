#!/bin/bash

# 1280x426
convert -trim -background white -gravity center -resize 1264x410 -extent 1264x410 -gravity center -bordercolor white -border 8 $1 $2
