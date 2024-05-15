#!/bin/bash

DASHBOARDS=$(yq -r '.items[].url' data/dashboards/index.yaml | cut -d '/' -f 6)

echo "dashboard,container,label,count"
for yml in $DASHBOARDS; do
  dash=${yml%.yaml}

  yq -r ".items[0].items[] as \$p | \$p.items[] | [\"$dash\", \$p.title, .label, .count] | @csv" data/dashboards/$yml
done
