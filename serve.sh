#!/bin/bash
echo "🚀 카테고리 페이지 자동 생성 중..."
ruby scripts/generate_categories.rb

echo "🌀 Jekyll 서버 시작 중..."
bundle exec jekyll serve
