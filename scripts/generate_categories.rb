#!/usr/bin/env ruby
require 'fileutils'
require 'yaml'

# ✅ 사이드바 카테고리 설정 파일 읽기
sidebar_config = YAML.load_file('_data/sidebar-category.yml')

# ✅ 생성될 디렉토리
output_dir = "_pages/categories"
FileUtils.mkdir_p(output_dir)

# ✅ 모든 카테고리 수집
categories = []
sidebar_config['entries'].each do |section|
  section['children'].each do |child|
    # URL에서 카테고리 이름 추출
    category = child['url'].split('/').last.gsub('#', '')
    categories << category unless category.empty?
  end
end

# ✅ 카테고리 페이지 생성
categories.each do |category|
  filename = "#{output_dir}/#{category}.md"
  unless File.exist?(filename)
    File.open(filename, "w") do |file|
      file.puts <<~MARKDOWN
        ---
        title: "#{category.split('-').map(&:capitalize).join(' ')} Posts"
        layout: category
        permalink: /categories/#{category}/
        taxonomy: #{category}
        ---
      MARKDOWN
    end
    puts "✅ Created: #{filename}"
  else
    puts "⚠️ Already exists: #{filename}"
  end
end

puts "\n📊 Generated #{categories.length} category pages"
