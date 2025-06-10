#!/bin/bash

echo "🚀 Mac 초기 개발 환경 설정을 시작합니다..."

# Homebrew 설치
if ! command -v brew &> /dev/null; then
  echo "🔧 Homebrew 설치 중..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "✅ Homebrew 이미 설치됨"
fi

brew update

# Nerd Fonts tap 추가
echo "🔠 Nerd Fonts tap 추가..."
brew tap homebrew/cask-fonts

# iTerm2 설치
echo "📦 iTerm2 설치..."
brew install --cask iterm2

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "📦 Oh My Zsh 설치..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# ZSH 테마 및 멀티라인 프롬프트 설정
echo "🎨 ZSH 테마 및 프롬프트 설정..."
sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' ~/.zshrc

cat << 'EOF' >> ~/.zshrc

# agnoster 멀티라인 프롬프트
prompt_context() {}
prompt_dir() {
  prompt_segment blue black '%~'
}
prompt_newline() {
  echo "\n$(print_prompt)"
}
precmd() {
  prompt_newline
}
EOF

# zsh plugins
echo "🔌 zsh 플러그인 설치..."
brew install zsh-syntax-highlighting
echo "source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

brew install zsh-autosuggestions
echo "source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

# GUI 앱 설치
echo "🖥️ GUI 앱 설치 중..."
brew install --cask tunnelblick
brew install --cask cursor
brew install --cask notion
brew install --cask discord
brew install --cask iina
brew install --cask kakao-talk
brew install --cask telegram
brew install --cask slack
brew install --cask google-chrome

# D2Coding Nerd Font 설치
echo "🔤 D2Coding Nerd Font 설치..."
brew install --cask font-d2coding-nerd-font

# iTerm2 기본 폰트 설정 (D2Coding Nerd Font 14pt)
echo "⚙️ iTerm2 기본 폰트 설정 (D2Coding Nerd Font 14)..."
defaults write com.googlecode.iterm2 "New Bookmarks" -array-add \
  '<dict>
    <key>Normal Font</key>
    <string>D2Coding Nerd Font 14</string>
    <key>name</key>
    <string>Default</string>
  </dict>'

# zsh 적용
echo "🔁 zsh 설정 적용 중..."
source ~/.zshrc

echo ""
echo "🎉 모든 Mac 초기 설정이 완료되었습니다!"
echo "💡 iTerm2 > Settings > Profiles > Text 탭에서 폰트가 'D2Coding Nerd Font'로 설정되었는지 확인하세요."
