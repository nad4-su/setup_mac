# NAD4 Mac 초기 설정 스크립트

Mac 개발 환경을 자동으로 설정하는 스크립트입니다.

## 📦 설치 항목

### 유틸리티
- **Stats**: 시스템 모니터 (CPU, Memory, Network 등)
- **Rectangle**: 윈도우 관리 (무료 Magnet 대안)
- **AppCleaner**: 앱 완전 삭제 도구

### 개발 도구
- Homebrew
- iTerm2
- Oh My Zsh
- zsh-syntax-highlighting
- zsh-autosuggestions
- Cursor (에디터)

### 폰트
- D2Coding
- D2Coding Nerd Font

### 애플리케이션
- Notion
- Discord
- Slack
- Google Chrome
- Telegram
- IINA (동영상 플레이어)
- Tunnelblick (VPN)


## 🚀 사용 방법

### 초기 설치
```bash
# 1. 저장소 클론
cd ~/workspace
git clone <repository-url> nad4

# 2. 스크립트 실행
cd nad4/setup_mac
chmod +x setup_mac.sh
./setup_mac.sh
```

### 다른 Mac에서 설정 동기화
```bash
# 1. 저장소 클론
cd ~/workspace
git clone <repository-url> nad4

# 2. 스크립트 실행 (기존 설정 적용)
cd nad4/setup_mac
chmod +x setup_mac.sh
./setup_mac.sh
```

## 📁 프로젝트 구조
```
setup_mac/
├── setup_mac.sh              # 메인 설치 스크립트
├── save_configs.sh           # 설정 저장 스크립트
├── iterm2-settings/
│   └── profile.json          # iTerm2 프로파일
├── stats-settings/
│   └── Stats.plist           # Stats 설정
├── rectangle-settings/
│   └── com.knollsoft.Rectangle.plist
└── README.md                 # 이 파일
```

## ⚙️ 설정 내용

### iTerm2 프로파일
- **이름**: nad4-profile
- **폰트**: D2Coding 13pt
- **색상**: 다크 테마
- **Status Bar**: CPU, 메모리, 네트워크, 배터리, 호스트명
- **크기**: 100 columns × 25 rows

### ZSH 테마
- **테마**: agnoster (멀티라인)
- **플러그인**: syntax-highlighting, autosuggestions

### Stats 설정
- 자동으로 사용자 정의 설정 적용
- 메뉴바 위젯 자동 구성
- Launch at login 자동 설정

## 🔄 설정 업데이트

### 간편한 방법 (save_configs.sh 사용)
```bash
cd ~/workspace/nad4/setup_mac

# 1. Stats에서 원하는 설정 변경
# 2. iTerm2에서 프로파일 수정 (선택사항)

# 3. 설정 저장 스크립트 실행
./save_configs.sh
```

### 수동 방법

#### iTerm2 프로파일 변경 사항 저장
```bash
# 1. iTerm2에서 프로파일 수정 후 Export
# iTerm2 > Settings > Profiles > Other Actions... > Save Profile as JSON

# 2. 파일을 저장소로 이동
cd ~/workspace/nad4/setup_mac
mv ~/Downloads/nad4-profile.json iterm2-settings/profile.json

# 3. Git 커밋
git add iterm2-settings/profile.json
git commit -m "Update iTerm2 profile"
git push
```

#### Stats 설정 변경 사항 저장
```bash
# 1. Stats에서 원하는 설정 변경
# Settings에서 위젯, 색상, 업데이트 간격 등 조정

# 2. 설정 파일 저장소로 복사
cd ~/workspace/nad4/setup_mac
cp ~/Library/Preferences/eu.exelban.Stats.plist stats-settings/Stats.plist

# 3. Git 커밋
git add stats-settings/Stats.plist
git commit -m "Update Stats configuration"
git push
```

## 📋 설치 후 체크리스트

### iTerm2 설정
- [ ] iTerm2 > Settings > Profiles
- [ ] 'nad4-profile' 선택
- [ ] Other Actions... > Set as Default
- [ ] 새 창 열어서 설정 확인

### Stats 설정
- [ ] 메뉴바에서 Stats 위젯 표시 확인
- [ ] Settings > General > Launch at login 확인
- [ ] CPU, Memory 등 위젯 정상 작동 확인

### ZSH 확인
- [ ] 새 터미널에서 `echo $ZSH_THEME` → agnoster
- [ ] `type build_prompt` → 함수 정의 확인
- [ ] 프롬프트 2줄로 표시 확인
- [ ] Syntax highlighting 작동 확인
- [ ] Autosuggestions 작동 확인

## 🛠️ 문제 해결

### iTerm2 프로파일이 적용되지 않는 경우
```bash
# 1. 프로파일 파일 확인
ls -la ~/Library/Application\ Support/iTerm2/DynamicProfiles/

# 2. iTerm2 재시작
killall iTerm2
open -a iTerm2
```

### Stats 설정이 적용되지 않는 경우
```bash
# 1. Stats 완전 종료
killall Stats

# 2. 설정 파일 재적용
cd ~/workspace/nad4/setup_mac
cp stats-settings/Stats.plist ~/Library/Preferences/eu.exelban.Stats.plist

# 3. Stats 재시작
open -a Stats
```

### ZSH 테마 에러
```bash
# 백업에서 복원
cp ~/.zshrc.backup_YYYYMMDD_HHMMSS ~/.zshrc
exec zsh
```

### 폰트가 표시되지 않는 경우
```bash
# 폰트 재설치
brew reinstall --cask font-d2coding
brew reinstall --cask font-d2coding-nerd-font

# 폰트 캐시 삭제
sudo atsutil databases -remove
```

## 📦 설정 백업 및 복원

### 전체 설정 백업
```bash
cd ~/workspace/nad4/setup_mac
./save_configs.sh
```

### 전체 설정 복원
```bash
cd ~/workspace/nad4/setup_mac

# Git에서 최신 설정 가져오기
git pull

# 스크립트 실행 (자동으로 모든 설정 복원)
./setup_mac.sh
```

## 📚 참고 자료

- [Homebrew](https://brew.sh/)
- [iTerm2](https://iterm2.com/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Stats](https://github.com/exelban/stats)
- [D2Coding Font](https://github.com/naver/d2codingfont)

## 💡 팁

### 빠른 설정 동기화
```bash
# 다른 Mac에서 5분 안에 모든 설정 복원
cd ~/workspace
git clone <repository-url> nad4
cd nad4/setup_mac
chmod +x setup_mac.sh
./setup_mac.sh

# 완료! iTerm2 재시작하면 모든 설정 적용됨
```

### 정기적인 설정 백업
```bash
# crontab으로 자동 백업 (선택사항)
crontab -e

# 매주 일요일 오후 6시에 설정 백업
0 18 * * 0 cd ~/workspace/nad4/setup_mac && cp ~/Library/Preferences/eu.exelban.Stats.plist stats-settings/Stats.plist && git add . && git commit -m "Auto backup: $(date)" && git push
```

## 📝 라이선스

MIT License
