#!/bin/bash

# This script creates a new newsletter post in the _posts directory

# Usage: ./make_new_newsletter_post.sh "Issue Month Year" path/to/newsletter/folder asset/storage/path
# Expects the following files in the newsletter folder:
# - draft.md - A markdown file containing all text (will be echoed into blog post body)
# - *.pdf - A single PDF file (will be copied to asset/storage/path)
# - assets - A directory of relevant assets (will be copied to asset/storage/path)

# show help if no arguments are given
if [ -z "$1" ]; then
    echo "Usage: ./make_new_newsletter_post.sh \"Issue Month Year\" <path/to/newsletter/folder> <asset/storage/path"
    echo "Example: ./make_new_newsletter_post.sh \"August 2026\" newsletter_source/newsletter/issues/2026-08 newsletter/2026-08"
    exit 1
fi

issue_name=$1
newsletter_source_folder=$2
destination_assets_folder=assets/$3
draft_file=$newsletter_source_folder/draft.md
source_assets_folder=$newsletter_source_folder/assets
date=$(date +%F)
title="Colorado Mesh Monthly $issue_name"

# find the first PDF file (hopefully the ONLY PDF file)
source_pdf_file=$(find "$newsletter_source_folder" -name '*.pdf' | head -n 1)

# copy all assets from source to destination
mkdir -p "$destination_assets_folder" || true
cp -r "$source_assets_folder" "$destination_assets_folder"
cp "$source_pdf_file" "$destination_assets_folder/"

destination_pdf_file=$(find "$destination_assets_folder" -name '*.pdf' | head -n 1)

# lowercase the title name for file name
file_name=$(echo "$title" | tr '[:upper:]' '[:lower:]')

# replace spaces with dashes in the file name
file_name_dashed="${file_name// /-}"

# remove any non-alphanumeric characters from the file name
file_name_dashed=$(echo "$file_name_dashed" | tr -cd '[:alnum:]-')

# create the file
path=_posts/$date-$file_name_dashed.md
touch "$path"

# populate the file header
echo "---
layout: post
title: \"$title\"
date: $date
description: FILL THIS OUT
tags: []
---

">> "$path"

# populate the file with the newsletter draft contents
cat "$draft_file" >> "$path"

# append the standard footer
echo "

### Prefer a hard copy?

Read the full issue below, print it out and share it with your friends!

<a href=\"https://blog.coloradomesh.org/$destination_pdf_file\">Download the full issue (PDF)</a>
" >> "$path"

# add the file to git
# git add "$path"

# open the file in nano
nano "$path"
