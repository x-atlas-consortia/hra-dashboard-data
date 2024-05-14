#!/bin/bash

convert -trim -background white -gravity center -resize 832x630 -extent 832x630 -gravity center -bordercolor white -border 8 $1 $2
