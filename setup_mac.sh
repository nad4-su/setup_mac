#!/bin/bash

# =============================================================================
# Mac 초기 개발 환경 설정 스크립트
# 작성자: NAD4
# 설명: Homebrew, iTerm2, Oh My Zsh, 필수 앱 자동 설치 및 설정
# =============================================================================

set -e  # 에러 발생 시 스크립트 중단

# 스크립트 실행 위치 확인
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ITERM_SETTINGS_DIR="$SCRIPT_DIR/iterm2-settings"
STATS_SETTINGS_DIR="$SCRIPT_DIR/stats-settings"
ITERM_PROFILE_FILE="$ITERM_SETTINGS_DIR/profile.json"
STATS_PLIST_FILE="$STATS_SETTINGS_DIR/Stats.plist"

echo "🚀 Mac 초기 개발 환경 설정을 시작합니다..."
echo "📂 스크립트 위치: $SCRIPT_DIR"
echo ""

# =============================================================================
# 1. Homebrew 설치
# =============================================================================
if ! command -v brew &> /dev/null; then
  echo "🔧 Homebrew 설치 중..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Apple Silicon Mac의 경우 PATH 설정
  if [[ $(uname -m) == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "✅ Homebrew 이미 설치됨"
fi

echo "📦 Homebrew 업데이트 중..."
brew update

echo ""

# =============================================================================
# 2. iTerm2 설치
# =============================================================================
echo "📦 iTerm2 설치 중..."
if brew list --cask iterm2 &> /dev/null; then
  echo "✅ iTerm2 이미 설치됨"
else
  brew install --cask iterm2
  echo "✅ iTerm2 설치 완료"
fi

echo ""

# =============================================================================
# 3. Oh My Zsh 설치
# =============================================================================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "📦 Oh My Zsh 설치 중..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "✅ Oh My Zsh 설치 완료"
else
  echo "✅ Oh My Zsh 이미 설치됨"
fi

echo ""

# =============================================================================
# 4. ZSH 플러그인 설치
# =============================================================================
echo "🔌 ZSH 플러그인 설치 중..."

# zsh-syntax-highlighting
if brew list zsh-syntax-highlighting &> /dev/null; then
  echo "✅ zsh-syntax-highlighting 이미 설치됨"
else
  brew install zsh-syntax-highlighting
  echo "✅ zsh-syntax-highlighting 설치 완료"
fi

# zsh-autosuggestions
if brew list zsh-autosuggestions &> /dev/null; then
  echo "✅ zsh-autosuggestions 이미 설치됨"
else
  brew install zsh-autosuggestions
  echo "✅ zsh-autosuggestions 설치 완료"
fi

echo ""

# =============================================================================
# 5. D2Coding 폰트 설치
# =============================================================================
echo "🔤 D2Coding 폰트 설치 중..."

# D2Coding 일반 폰트
if brew list --cask font-d2coding &> /dev/null; then
  echo "✅ D2Coding 폰트 이미 설치됨"
else
  brew install --cask font-d2coding
  echo "✅ D2Coding 폰트 설치 완료"
fi

# D2Coding Nerd Font
if brew list --cask font-d2coding-nerd-font &> /dev/null; then
  echo "✅ D2Coding Nerd Font 이미 설치됨"
else
  brew install --cask font-d2coding-nerd-font
  echo "✅ D2Coding Nerd Font 설치 완료"
fi

echo ""

# =============================================================================
# 6. GUI 애플리케이션 설치
# =============================================================================
echo "🖥️ GUI 애플리케이션 설치 중..."

# 설치할 앱 목록
APPS=(
  "tunnelblick"
  "cursor"
  "notion"
  "discord"
  "iina"
  "telegram"
  "slack"
  "google-chrome"
  "stats"
)

for app in "${APPS[@]}"; do
  if brew list --cask "$app" &> /dev/null; then
    echo "✅ $app 이미 설치됨"
  else
    echo "📦 $app 설치 중..."
    brew install --cask "$app"
  fi
done

echo ""

# =============================================================================
# 7. .zshrc 설정
# =============================================================================
echo "🎨 ZSH 설정 파일 구성 중..."

# 백업 생성
if [ -f ~/.zshrc ]; then
  BACKUP_FILE="$HOME/.zshrc.backup_$(date +%Y%m%d_%H%M%S)"
  cp ~/.zshrc "$BACKUP_FILE"
  echo "✅ 기존 .zshrc 백업: $BACKUP_FILE"
fi

# 기존 NAD4 커스터마이징 제거 (중복 방지)
if [ -f ~/.zshrc ] && grep -q "# NAD4 Custom Prompt Config" ~/.zshrc; then
  echo "🧹 기존 NAD4 설정 제거 중..."
  sed -i '' '/# NAD4 Custom Prompt Config - START/,/# NAD4 Custom Prompt Config - END/d' ~/.zshrc
fi

# .zshrc 파일이 없으면 기본 템플릿 생성
if [ ! -f ~/.zshrc ]; then
  cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
fi

# ZSH_THEME 설정
if grep -q "^ZSH_THEME=" ~/.zshrc; then
  sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' ~/.zshrc
else
  echo 'ZSH_THEME="agnoster"' >> ~/.zshrc
fi

# 멀티라인 프롬프트 설정 추가
cat << 'EOF' >> ~/.zshrc

# NAD4 Custom Prompt Config - START
# agnoster 테마 멀티라인 프롬프트 커스터마이징

# 사용자@호스트명 숨기기
prompt_context() {}

# 디렉토리 표시 스타일
prompt_dir() {
  prompt_segment blue black '%~'
}

# 줄바꿈 처리
prompt_newline() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# 프롬프트 빌드 (멀티라인 적용)
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_aws
  prompt_context
  prompt_dir
  prompt_git
  prompt_bzr
  prompt_hg
  prompt_newline
  prompt_end
}
# NAD4 Custom Prompt Config - END

EOF

# ZSH 플러그인 source 추가 (중복 체크)
SYNTAX_LINE='source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
if ! grep -qxF "$SYNTAX_LINE" ~/.zshrc; then
  echo "$SYNTAX_LINE" >> ~/.zshrc
fi

SUGGEST_LINE='source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
if ! grep -qxF "$SUGGEST_LINE" ~/.zshrc; then
  echo "$SUGGEST_LINE" >> ~/.zshrc
fi

echo "✅ .zshrc 설정 완료"
echo ""

# =============================================================================
# 8. iTerm2 프로파일 설정
# =============================================================================
echo "⚙️ iTerm2 프로파일 설정 중..."

# iTerm2가 실행 중이면 종료 (정확한 프로세스 이름 사용)
if pgrep -x "iTerm2" > /dev/null; then
  echo "⚠️ iTerm2가 실행 중입니다. 종료합니다..."
  killall iTerm 2>/dev/null || killall iTerm2 2>/dev/null || true
  sleep 2
fi

# iTerm2 DynamicProfiles 디렉토리 생성
ITERM_DYNAMIC_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$ITERM_DYNAMIC_DIR"

# 프로파일 파일 확인
if [ -f "$ITERM_PROFILE_FILE" ]; then
  echo "✅ profile.json 발견"
  
  # DynamicProfile 형식으로 변환하여 복사
  cat > "$ITERM_DYNAMIC_DIR/NAD4Profile.json" << 'DYNAMIC_WRAPPER'
{
  "Profiles": [
DYNAMIC_WRAPPER
  
  # 기존 프로파일 내용 추가 (마지막 } 제거)
  cat "$ITERM_PROFILE_FILE" | sed '$ d' >> "$ITERM_DYNAMIC_DIR/NAD4Profile.json"
  
  # 래퍼 종료
  cat >> "$ITERM_DYNAMIC_DIR/NAD4Profile.json" << 'DYNAMIC_WRAPPER'
    }
  ]
}
DYNAMIC_WRAPPER
  
  echo "✅ iTerm2 Dynamic Profile 생성 완료"
  echo "   위치: $ITERM_DYNAMIC_DIR/NAD4Profile.json"
  
  # profile.json에서 GUID 추출
  PROFILE_GUID=$(grep -o '"Guid" : "[^"]*"' "$ITERM_PROFILE_FILE" | sed 's/"Guid" : "\(.*\)"/\1/')
  
  if [ -n "$PROFILE_GUID" ]; then
    echo "✅ 프로파일 GUID: $PROFILE_GUID"
    
    # iTerm2 환경설정에 기본 프로파일 GUID만 설정
    defaults write com.googlecode.iterm2 "Default Bookmark Guid" "$PROFILE_GUID"
    
    echo "✅ iTerm2 기본 프로파일 GUID 설정 완료"
  else
    echo "⚠️ 프로파일 GUID를 찾을 수 없습니다"
  fi
  
else
  echo "⚠️ $ITERM_PROFILE_FILE 파일을 찾을 수 없습니다."
fi

# iTerm2 재시작 (번들 ID 사용)
echo "🔄 iTerm2 시작 중..."
sleep 1

# iTerm2 실행 (여러 방법 시도)
if [ -d "/Applications/iTerm.app" ]; then
  open -a /Applications/iTerm.app
  echo "✅ iTerm2 시작 완료"
elif command -v open &> /dev/null; then
  open -b com.googlecode.iterm2 2>/dev/null || \
  open /Applications/iTerm.app 2>/dev/null || \
  echo "⚠️ iTerm2를 수동으로 실행해주세요"
else
  echo "⚠️ iTerm2를 수동으로 실행해주세요"
fi

echo ""

# =============================================================================
# 9. Stats 앱 설정
# =============================================================================
echo "📊 Stats 앱 설정 중..."

if brew list --cask stats &> /dev/null; then
  echo "✅ Stats 설치됨"
  
  # Stats가 실행 중이면 종료
  if pgrep -x "Stats" > /dev/null; then
    echo "⚠️ Stats가 실행 중입니다. Stats를 종료합니다..."
    killall Stats 2>/dev/null || true
    sleep 2
  fi
  
  # Stats 설정 파일 확인
  if [ -f "$STATS_PLIST_FILE" ]; then
    echo "✅ Stats.plist 발견"
    
    # Stats 설정 파일 백업
    STATS_PREF_FILE="$HOME/Library/Preferences/eu.exelban.Stats.plist"
    if [ -f "$STATS_PREF_FILE" ]; then
      STATS_BACKUP="$STATS_PREF_FILE.backup_$(date +%Y%m%d_%H%M%S)"
      cp "$STATS_PREF_FILE" "$STATS_BACKUP"
      echo "✅ 기존 Stats 설정 백업: $STATS_BACKUP"
    fi
    
    # 새 설정 적용
    cp "$STATS_PLIST_FILE" "$STATS_PREF_FILE"
    echo "✅ Stats 설정 적용 완료"
    
    # 설정 파일 권한 설정
    chmod 644 "$STATS_PREF_FILE"
    
    # Stats 재시작
    echo "🔄 Stats 재시작 중..."
    sleep 1
    open -a Stats
    echo "✅ Stats 시작 완료"
    
  else
    echo "⚠️ $STATS_PLIST_FILE 파일을 찾을 수 없습니다."
    echo "   Stats를 실행하고 수동으로 설정해주세요."
  fi
  
else
  echo "⚠️ Stats가 설치되지 않았습니다."
fi

echo ""

# =============================================================================
# 완료 메시지
# =============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Mac 초기 개발 환경 설정이 완료되었습니다!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 다음 단계:"
echo ""
echo "  1️⃣  iTerm2 실행 확인"
echo "     → iTerm이 자동으로 열렸는지 확인"
echo "     → 열리지 않았다면: Spotlight (⌘Space) → 'iTerm' 검색"
echo ""
echo "  2️⃣  iTerm2에서 프로파일 설정 (필수 - 30초):"
echo "     ┌──────────────────────────────────────────┐"
echo "     │ iTerm2 > Settings (⌘,)                  │"
echo "     │ → Profiles 탭                            │"
echo "     │ → 왼쪽에서 'nad4-profile' 선택           │"
echo "     │ → 하단 'Other Actions...' 클릭           │"
echo "     │ → 'Set as Default' 선택                  │"
echo "     └──────────────────────────────────────────┘"
echo ""
echo "  3️⃣  새 창 열어서 프로파일 확인 (⌘N)"
echo "     ✓ 어두운 배경 (#1F1F1F)"
echo "     ✓ D2Coding 13pt 폰트"
echo "     ✓ 하단 Status Bar (CPU, Memory, Network, Battery, Host)"
echo "     ✓ 100 columns × 25 rows"
echo ""
echo "  4️⃣  ZSH 테마 확인 (새 터미널에서):"
echo "     echo \$ZSH_THEME  # → agnoster"
echo "     type build_prompt  # → function 확인"
echo ""
echo "  5️⃣  Stats 메뉴바 위젯 확인"
echo "     → 메뉴바 오른쪽에 시스템 모니터 표시"
echo ""
echo "💡 참고:"
echo "   - Dynamic Profile: ✅ 생성 완료"
echo "   - 기본 GUID 설정: ✅ 완료"
echo "   - Stats 설정: ✅ 적용 완료"
echo "   - 최종 단계: 2단계 프로파일 설정만 진행하면 끝!"
echo ""
echo "🔧 문제 발생 시:"
echo "   - iTerm2가 실행 안 되면: Spotlight에서 'iTerm' 검색 후 실행"
echo "   - 프로파일 목록에 nad4-profile 없으면:"
echo "     Settings > Profiles > Other Actions > Import JSON"
echo "     → iterm2-settings/profile.json 선택"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
