#!/bin/bash

# =============================================================================
# Mac 초기 개발 환경 설정 스크립트
# 작성자: NAD4
# 설명: Homebrew, iTerm2, Oh My Zsh, Claude Code, Codex, VSCode, 필수 앱 자동 설치 및 설정
# =============================================================================

set -e  # 에러 발생 시 스크립트 중단

# 스크립트 실행 위치 확인
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="${HOME}/workspace"
CODEX_REPO_URL="https://github.com/nad4-su/codex.git"
CODEX_REPO_DIR="${WORKSPACE_ROOT}/codex"
ITERM_SETTINGS_DIR="$SCRIPT_DIR/iterm2-settings"
STATS_SETTINGS_DIR="$SCRIPT_DIR/stats-settings"
RECTANGLE_SETTINGS_DIR="$SCRIPT_DIR/rectangle-settings"
ITERM_PROFILE_FILE="$ITERM_SETTINGS_DIR/profile.json"
STATS_PLIST_FILE="$STATS_SETTINGS_DIR/Stats.plist"
RECTANGLE_PLIST_FILE="$RECTANGLE_SETTINGS_DIR/com.knollsoft.Rectangle.plist"
RECTANGLE_JSON_FILE="$RECTANGLE_SETTINGS_DIR/RectangleConfig.json"

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
  "visual-studio-code"
  "cursor"
  "notion"
  "discord"
  "iina"
  "telegram"
  "slack"
  "google-chrome"
  "stats"
  "rectangle"
  "appcleaner"
)

for app in "${APPS[@]}"; do
  if brew list --cask "$app" &> /dev/null; then
    echo "✅ $app 이미 설치됨"
  else
    echo "📦 $app 설치 중..."
    brew install --cask "$app" || echo "⚠️ $app 설치 실패. 나중에 수동으로 설치해주세요."
  fi
done

echo ""

# =============================================================================
# 7. Node.js, Claude Code CLI, Codex CLI 설치
# =============================================================================
echo "🤖 Node.js, Claude Code, Codex 설치 중..."

# Node.js
if brew list node &> /dev/null; then
  echo "✅ Node.js 이미 설치됨"
else
  brew install node || { echo "⚠️ Node.js 설치 실패"; }
  echo "✅ Node.js 설치 완료"
fi

# Claude Code CLI
if command -v claude &> /dev/null; then
  echo "✅ Claude Code CLI 이미 설치됨"
else
  npm install -g @anthropic-ai/claude-code || { echo "⚠️ Claude Code CLI 설치 실패. Node.js 설치를 확인해주세요."; }
  echo "✅ Claude Code CLI 설치 완료"
fi

# Codex CLI
if command -v codex &> /dev/null; then
  echo "✅ Codex CLI 이미 설치됨"
else
  npm install -g @openai/codex || { echo "⚠️ Codex CLI 설치 실패. Node.js 설치를 확인해주세요."; }
  echo "✅ Codex CLI 설치 완료"
fi

echo ""

# =============================================================================
# 8. VSCode 확장 설치
# =============================================================================
echo "🔌 VSCode 확장 설치 중..."

# VSCode code CLI 경로 확인
CODE_CMD=""
if command -v code &> /dev/null; then
  CODE_CMD="code"
elif [ -f "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
  CODE_CMD="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
fi

if [ -n "$CODE_CMD" ]; then
  # Claude for VSCode 확장 설치
  if "$CODE_CMD" --install-extension anthropic.claude-code 2>/dev/null; then
    echo "✅ Claude for VSCode 확장 설치 완료"
  else
    echo "⚠️ Claude 확장 자동 설치 실패"
    echo "   VSCode에서 수동 설치: Extensions (⌘⇧X) → 'Claude' 검색"
  fi

  # OpenAI VSCode 확장 설치
  if "$CODE_CMD" --install-extension openai.chatgpt 2>/dev/null; then
    echo "✅ OpenAI VSCode 확장 설치 완료"
  else
    echo "⚠️ OpenAI VSCode 확장 자동 설치 실패"
    echo "   VSCode에서 수동 설치: Extensions (⌘⇧X) → 'OpenAI' 또는 'ChatGPT' 검색"
  fi
else
  echo "⚠️ VSCode code 명령을 찾을 수 없습니다."
  echo "   VSCode 실행 후: ⌘⇧P → 'Shell Command: Install code command in PATH'"
  echo "   이후 Extensions에서 'Claude' 및 'OpenAI' 확장을 수동 설치해주세요."
fi

echo ""

# =============================================================================
# 9. 공유 Codex 저장소 및 bootstrap 설정
# =============================================================================
echo "🤖 Codex 공유 설정 저장소 구성 중..."

mkdir -p "$WORKSPACE_ROOT"

if [ -d "$CODEX_REPO_DIR/.git" ]; then
  echo "✅ codex 저장소 이미 존재: $CODEX_REPO_DIR"
else
  echo "📦 codex 저장소 clone 중..."
  git clone "$CODEX_REPO_URL" "$CODEX_REPO_DIR" || {
    echo "⚠️ codex 저장소 clone 실패"
    echo "   수동 실행: git clone $CODEX_REPO_URL $CODEX_REPO_DIR"
  }
fi

if [ -x "$CODEX_REPO_DIR/scripts/bootstrap-codex.sh" ]; then
  echo "🚀 codex bootstrap 실행 중..."
  bash "$CODEX_REPO_DIR/scripts/bootstrap-codex.sh" "$WORKSPACE_ROOT" || {
    echo "⚠️ codex bootstrap 실패"
    echo "   수동 실행: bash $CODEX_REPO_DIR/scripts/bootstrap-codex.sh $WORKSPACE_ROOT"
  }
else
  echo "⚠️ bootstrap-codex.sh를 찾을 수 없습니다."
fi

echo ""

# =============================================================================
# 10. .zshrc 설정
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

# Homebrew PATH 설정 확인 및 추가
if ! grep -q "brew shellenv" ~/.zshrc; then
  echo "🔧 Homebrew PATH 설정 추가..."
  
  if [[ $(uname -m) == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    echo "✅ Homebrew PATH 설정 추가 (Apple Silicon)"
  else
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
    echo "✅ Homebrew PATH 설정 추가 (Intel)"
  fi
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

# ZSH 플러그인 source 추가 (중복 체크, Apple Silicon/Intel 자동 감지)
BREW_PREFIX="$(brew --prefix)"

SYNTAX_LINE="source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if ! grep -q "zsh-syntax-highlighting.zsh" ~/.zshrc; then
  echo "$SYNTAX_LINE" >> ~/.zshrc
fi

SUGGEST_LINE="source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
if ! grep -q "zsh-autosuggestions.zsh" ~/.zshrc; then
  echo "$SUGGEST_LINE" >> ~/.zshrc
fi

echo "✅ .zshrc 설정 완료"
echo ""

# =============================================================================
# 11. iTerm2 프로파일 설정
# =============================================================================
echo "⚙️ iTerm2 프로파일 설정 중..."

# iTerm2가 실행 중이면 종료
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
  
  # DynamicProfile 형식으로 변환하여 복사 (profile.json을 Profiles 배열로 래핑)
  {
    echo '{"Profiles": ['
    cat "$ITERM_PROFILE_FILE"
    echo ']}'
  } > "$ITERM_DYNAMIC_DIR/NAD4Profile.json"
  
  echo "✅ iTerm2 Dynamic Profile 생성 완료"
  echo "   위치: $ITERM_DYNAMIC_DIR/NAD4Profile.json"
  
  # profile.json에서 GUID 추출 (공백 유무 무관)
  PROFILE_GUID=$(grep -o '"Guid"[[:space:]]*:[[:space:]]*"[^"]*"' "$ITERM_PROFILE_FILE" | head -1 | sed 's/.*:.*"\([^"]*\)"/\1/')
  
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

# iTerm2 재시작
echo "🔄 iTerm2 시작 중..."
sleep 1
if open -a iTerm 2>/dev/null; then
  echo "✅ iTerm2 시작 완료"
else
  echo "⚠️ iTerm2를 수동으로 실행해주세요"
fi

echo ""

# =============================================================================
# 12. Stats 앱 설정
# =============================================================================
echo "📊 Stats 앱 설정 중..."

# Stats 설치 확인 (파일 시스템 기반)
if [ -d "/Applications/Stats.app" ]; then
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
# 13. Rectangle 앱 설정
# =============================================================================
echo "📐 Rectangle 앱 설정 중..."

# Rectangle 설치 확인 (파일 시스템 기반)
if [ -d "/Applications/Rectangle.app" ]; then
  echo "✅ Rectangle 설치됨"
  
  # Rectangle이 실행 중이면 종료
  if pgrep -x "Rectangle" > /dev/null; then
    echo "⚠️ Rectangle이 실행 중입니다. Rectangle을 종료합니다..."
    killall Rectangle 2>/dev/null || true
    sleep 2
  fi
  
  # Rectangle 설정 파일 확인 (plist 우선, JSON 폴백)
  RECTANGLE_PREF_FILE="$HOME/Library/Preferences/com.knollsoft.Rectangle.plist"

  if [ -f "$RECTANGLE_PLIST_FILE" ] || [ -f "$RECTANGLE_JSON_FILE" ]; then
    # 기존 설정 백업
    if [ -f "$RECTANGLE_PREF_FILE" ]; then
      RECTANGLE_BACKUP="$RECTANGLE_PREF_FILE.backup_$(date +%Y%m%d_%H%M%S)"
      cp "$RECTANGLE_PREF_FILE" "$RECTANGLE_BACKUP"
      echo "✅ 기존 Rectangle 설정 백업: $RECTANGLE_BACKUP"
    fi

    if [ -f "$RECTANGLE_PLIST_FILE" ]; then
      # plist 파일이 있으면 직접 복사
      echo "✅ Rectangle.plist 발견"
      cp "$RECTANGLE_PLIST_FILE" "$RECTANGLE_PREF_FILE"
      chmod 644 "$RECTANGLE_PREF_FILE"
      echo "✅ Rectangle 설정 적용 완료 (plist)"
    elif [ -f "$RECTANGLE_JSON_FILE" ]; then
      # JSON 파일만 있으면 plutil로 변환 후 적용
      echo "✅ RectangleConfig.json 발견"
      if plutil -convert binary1 -o "$RECTANGLE_PREF_FILE" "$RECTANGLE_JSON_FILE" 2>/dev/null; then
        chmod 644 "$RECTANGLE_PREF_FILE"
        echo "✅ Rectangle 설정 적용 완료 (JSON → plist 변환)"
      else
        echo "⚠️ JSON 변환 실패. Rectangle을 실행 후 수동으로 설정을 import 해주세요."
        echo "   Rectangle > Preferences > Import (${RECTANGLE_JSON_FILE})"
      fi
    fi

    # Rectangle 재시작
    echo "🔄 Rectangle 재시작 중..."
    sleep 1
    open -a Rectangle
    echo "✅ Rectangle 시작 완료"

  else
    echo "⚠️ Rectangle 설정 파일을 찾을 수 없습니다."
    echo "   Rectangle을 실행하고 설정을 구성해주세요."
    open -a Rectangle
    sleep 3
    echo "✅ Rectangle 초기 실행 완료"
  fi
  
else
  echo "⚠️ Rectangle이 설치되지 않았습니다."
  echo "   brew install --cask rectangle 명령으로 수동 설치하세요."
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
echo "     ✓ 어두운 배경"
echo "     ✓ D2Coding 폰트"
echo "     ✓ 하단 Status Bar (CPU, Memory 등)"
echo ""
echo "  4️⃣  ZSH 테마 확인 (새 터미널에서):"
echo "     echo \$ZSH_THEME  # → agnoster"
echo "     type build_prompt  # → function 확인"
echo ""
echo "  5️⃣  Stats 메뉴바 위젯 확인"
echo ""
echo "  6️⃣  Rectangle 윈도우 관리 설정 (선택사항 - 3분):"
echo "     a. System Settings > Privacy & Security > Accessibility"
echo "        → Rectangle 체크 (필수)"
echo "     b. Rectangle Preferences (⌘,)"
echo "        → 키보드 단축키 확인/변경"
echo ""
echo "     기본 단축키:"
echo "        ⌃⌥→ : 오른쪽 절반    ⌃⌥← : 왼쪽 절반"
echo "        ⌃⌥↑ : 최대화         ⌃⌥↓ : 하단 정렬"
echo "        ⌃⌥F : 전체 화면      ⌃⌥C : 가운데"
echo ""
echo "  7️⃣  Claude Code 확인:"
echo "     claude --version  # → 버전 확인"
echo "     claude            # → Claude Code 실행"
echo "     ※ 최초 실행 시 API 키 설정 필요"
echo ""
echo "  8️⃣  Codex 확인:"
echo "     codex --version   # → Codex CLI 버전 확인"
echo "     codex             # → 최초 실행 시 로그인 진행"
echo ""
echo "  9️⃣  Codex 공유 환경 확인:"
echo "     ls -l ~/workspace/AGENTS.md"
echo "     ls ~/.codex/skills | grep harness-diagnostics"
echo "     ls ~/.codex/skills | grep gstack-review"
echo "     ※ 필요 시: bash ~/workspace/codex/scripts/update-vendor.sh"
echo ""
echo "  🔟  VSCode 확장 확인:"
echo "     VSCode 실행 → Extensions (⌘⇧X)"
echo "     → 'Claude' 설치 확인"
echo "     → 'OpenAI / ChatGPT' 설치 확인"
echo ""
echo "  1️⃣1️⃣  AppCleaner 사용법:"
echo "     - Applications 폴더에서 AppCleaner 실행"
echo "     - 앱 삭제 시 관련 파일까지 자동 정리"
echo "     - 추천: Dock에 추가하여 사용"
echo ""
echo "💡 설치된 앱 목록:"
echo "   ✅ iTerm2 (터미널)"
echo "   ✅ VSCode + Claude 확장"
echo "   ✅ Claude Code CLI"
echo "   ✅ Codex CLI"
echo "   ✅ VSCode OpenAI 확장"
echo "   ✅ Shared Codex workspace bootstrap"
echo "   ✅ Stats (시스템 모니터)"
echo "   ✅ Rectangle (윈도우 관리)"
echo "   ✅ AppCleaner (앱 제거 도구)"
echo "   ✅ Cursor, Notion, Discord, Slack"
echo "   ✅ IINA, Telegram, Chrome"
echo "   ✅ Tunnelblick (VPN)"
echo ""
echo "🔧 문제 발생 시:"
echo "   - brew 명령어 오류: 새 터미널 열기"
echo "   - iTerm2 프로파일 없음: profile.json 확인"
echo "   - Rectangle/Stats 설정 오류: 수동 설정"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
