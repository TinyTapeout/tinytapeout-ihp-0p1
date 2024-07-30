#!/usr/bin/env bash

DRC_FILE=$1

if [ -z "$DRC_FILE" ]; then
    echo "Usage: $0 <filename.lyrdb>"
    exit 1
fi

if [ ! -f "$DRC_FILE" ]; then
    echo "DRC file not found: $DRC_FILE"
    exit 1
fi

if [[ "$DRC_FILE" =~ "raw" ]]; then
    echo "Warning: running DRC without seal ring and fill, some issues are expected"
    echo ""
fi

DRC_COUNT=$(xmllint --xpath 'count(//item)' $DRC_FILE)

if [ "$DRC_COUNT" -eq 0 ]; then
    echo "## DRC clean"
    echo ""
    echo "No DRC issues found"
    exit 0
fi

CATEGORIES=$(xmllint --xpath '/report-database/categories' $DRC_FILE)

function category_description() {
    local category=$1
    echo $CATEGORIES | xmllint --xpath "//category[name/text()='$category']/description/text()" - | cut -d " " -f 2-
}

echo "## DRC issues found: $DRC_COUNT"
echo ""
echo "| Category | Count | Description |"
echo "| --- | --- | --- |"
xmllint --xpath '//item/category/text()' $DRC_FILE | tr ' ' '\n' | sort | uniq -c | (
    while read count category; do 
        category=$(echo $category | sed -E "s/^'|'\$//g")
        echo "| $category | $count | $(category_description $category) |"
    done
)
