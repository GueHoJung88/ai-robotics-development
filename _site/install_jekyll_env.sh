#!/bin/bash

set -e

echo "🚀 Jekyll 환경 자동 설치 시작합니다..."

# 📦 필수 의존성 설치
echo "📦 필수 의존성 설치 중..."
# sudo apt update
sudo apt install -y git curl libssl-dev libreadline-dev zlib1g-dev autoconf build-essential libyaml-dev libffi-dev libgdbm-dev

# 🔧 rbenv 설치
if [ ! -d "$HOME/.rbenv" ]; then
  echo "🔧 rbenv 설치 중..."
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  cd ~/.rbenv && src/configure && make -C src
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
  cd ~
else
  echo "✅ rbenv 이미 설치됨"
fi

# 👉 rbenv 즉시 사용을 위해 환경 적용
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$($HOME/.rbenv/bin/rbenv init -)"

# 🔧 ruby-build 설치
if [ ! -d "$HOME/.rbenv/plugins/ruby-build" ]; then
  echo "🔧 ruby-build 설치 중..."
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
else
  echo "✅ ruby-build 이미 설치됨"
fi

# 💎 Ruby 설치
RUBY_VERSION="3.3.0"
if ! rbenv versions | grep -q "$RUBY_VERSION"; then
  echo "💎 Ruby $RUBY_VERSION 설치 중..."
  rbenv install "$RUBY_VERSION"
fi

rbenv global "$RUBY_VERSION"
eval "$(rbenv init - bash)"

echo "💎 현재 Ruby 버전:"
ruby -v

# 📦 Bundler 설치 (최신 버전)
echo "📦 최신 Bundler 설치 중..."
gem install bundler
rbenv rehash

# 🧹 이전 lock 및 설정 제거
echo "🧹 기존 Gemfile.lock 및 .bundle 설정 제거 중..."
rm -f Gemfile.lock
rm -rf .bundle

# 📄 Gemfile 확인 및 생성
if [ ! -f "Gemfile" ]; then
  echo "📄 Gemfile 생성 중..."
  bundle init
  echo 'gem "jekyll"' >> Gemfile
  echo 'gem "minimal-mistakes-jekyll"' >> Gemfile
fi

# 📦 bundle install
echo "📦 bundle install 실행 중..."
bundle install

# ✅ 완료 안내
echo ""
echo "✅ Jekyll 환경 구축 완료!"
echo "👉 로컬 서버 실행:"
echo "   bundle exec jekyll serve"
