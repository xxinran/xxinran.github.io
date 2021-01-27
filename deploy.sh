#!/bin/bash
DIR=`dirname $0`

# Generate blog
echo "Generate and deploy..."
hexo clean
hexo generate & hexo deploy
# hexo d -g

sleep 10

# Push hexo code
echo "Push hexo code"
git add .
current_date=`date "+%Y-%m-%d %H:%M:%S"`
git commit -m "Blog updated: $current_date"

sleep 2
git push -f origin hexo

echo "=====>Finish!<====="
