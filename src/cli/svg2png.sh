#!/bin/bash

convert -trim -background white -gravity center -resize 1264x944 -extent 1264x944 -gravity center -bordercolor white -border 8 $1 $2
