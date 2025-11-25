#!/bin/bash

# =============================================================================
# 현재 설정을 Git 저장소로 저장하는 스크립트
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ITERM_SETTINGS_DIR="$SCRIPT_DIR/iterm2-settings"
STATS_SETTINGS_DIR="$SCRIPT_DIR/stats-settings"

echo "📦 현재 설정을 저장합니다..."
echo ""

# iTerm2 프로파일 저장 안내
echo "📝 iTerm2 프로파일 저장:"
echo "   1. iTerm2 > Settings > Profiles"
echo "   2. 'nad4-profile' 선택"
echo "   3. Other Actions... > Save Profile as JSON"
echo "   4. 파일명: profile.json"
echo "   5. 위치: $ITERM_SETTINGS_DIR/"
echo ""
read -p "iTerm2 프로파일을 저장했으면 Enter를 누르세요..." -r

# iTerm2 프로파일 확인
if [ -f "$ITERM_SETTINGS_DIR/profile.json" ]; then
  echo "✅ iTerm2 프로파일 발견"
  git add "$ITERM_SETTINGS_DIR/profile.json"
else
  echo "⚠️ iTerm2 프로파일을 찾을 수 없습니다"
fi

echo ""

# Stats 설정 저장
if [ -f "$HOME/Library/Preferences/eu.exelban.Stats.plist" ]; then
  echo "📊 Stats 설정 저장 중..."
  cp "$HOME/Library/Preferences/eu.exelban.Stats.plist" \
     "$STATS_SETTINGS_DIR/Stats.plist"
  echo "✅ Stats 설정 저장 완료"
  git add "$STATS_SETTINGS_DIR/Stats.plist"
else
  echo "⚠️ Stats 설정 파일을 찾을 수 없습니다"
fi

echo ""

# Git 상태 확인
cd "$SCRIPT_DIR"
echo "📂 변경된 파일:"
git status --short

echo ""
echo "💾 Git 커밋을 진행하시겠습니까?"
read -p "커밋 메시지를 입력하세요 (Enter로 건너뛰기): " commit_msg

if [ -n "$commit_msg" ]; then
  git commit -m "$commit_msg"
  echo "✅ 커밋 완료"
  
  read -p "원격 저장소에 푸시하시겠습니까? (y/N): " push_confirm
  if [[ "$push_confirm" =~ ^[Yy]$ ]]; then
    git push
    echo "✅ 푸시 완료"
  fi
else
  echo "ℹ️ 커밋하지 않고 종료합니다"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 설정 저장 완료"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
