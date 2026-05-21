# 셋업 흐름 (Claude 자동 진행용 명세)

이 파일은 받는 학원의 Claude Code에게 11단계 자동 셋업을 진행하라고 알려주는 명세서입니다. 받는 분이 직접 읽을 필요는 없습니다 — Claude가 GitHub raw URL로 이 파일을 자동 다운로드해서 따라 합니다.

> Claude에게: 아래 11단계를 **순서대로**, **각 단계 완료 후 다음 단계로 진행**하세요. 단계 사이에 받는 분에게 진행 보고를 짧게 해주세요. 받는 분이 "잘 모르겠어요" 라고 답하면 추천 옵션을 다시 제시하고 다른 답변 선택지(예: Y/N, 1/2/3)를 명확히 보여주세요. 핵심 검증 단계(8번)에서 실패하면 절대 진행하지 말고 중단하세요.

---

## 1단계: 환경 점검

받는 분의 컴퓨터 환경을 자동 감지하고 받는 분에게 확인받습니다.

### Claude가 할 일

- OS 감지:
  - Windows: `$env:OS` 또는 `uname -s` 가 `MINGW*`, `CYGWIN*` 등
  - macOS: `uname -s` = `Darwin`
  - Linux: `uname -s` = `Linux`
- `git --version` 실행 → 설치 여부 확인
- 셸 종류 확인 (PowerShell·bash·zsh 등)

### 받는 분에게 보고

```
환경 점검 결과:
- OS: <감지된 OS>
- git: <설치됨 / 설치되지 않음>
- 셸: <감지된 셸>

이대로 진행할까요? (네/아니오)
```

### git이 설치되지 않은 경우

OS별 설치 안내:
- **Windows**: `winget install Git.Git` 또는 https://git-scm.com/download/win
- **macOS**: `brew install git` 또는 https://git-scm.com/download/mac
- **Linux**: `sudo apt install git` (Ubuntu) / `sudo dnf install git` (Fedora)

받는 분이 설치 완료 후 "설치했어요" 라고 답하면 `git --version` 재확인.

---

## 2단계: 명령어 폴더 위치 결정

받는 분이 git clone할 폴더 위치를 정합니다.

### Claude가 추천하는 위치

- **Windows**: `$env:USERPROFILE\notion-academy\` (예: `C:\Users\<본인>\notion-academy\`)
- **macOS·Linux**: `~/notion-academy/`

### 받는 분에게 묻기

```
명령어 폴더를 어디에 두실까요?

추천: <OS별 추천 경로>

1) 추천 위치로 설치 (네)
2) 다른 위치 직접 입력

번호로 답해주세요.
```

받는 분이 직접 입력 선택 시 절대경로 받기. 경로에 한글·공백 있어도 OK (큰따옴표로 감싸기).

---

## 3단계: 명령어 다운로드 (git clone)

위에서 정한 폴더에 git clone 실행.

### Claude가 실행

```bash
git clone https://github.com/set-octopuslab/notion-academy-claude-commands.git "<폴더 경로>"
```

성공 메시지 확인 후 받는 분에게 보고:

```
✓ 명령어 다운로드 완료
- 위치: <폴더 경로>
- 파일 수: 22개 명령어 + README + 사용가이드
```

---

## 4단계: ~/.claude/commands/ 에 명령어 .md 복사 (sync 스크립트 실행)

Claude Code의 슬래시 명령어는 `~/.claude/commands/` 안의 평면 구조 .md 파일만 인식합니다 (하위 폴더 미지원). repo 안의 .md 파일들을 그 위치로 복사해야 합니다.

### Claude가 실행

OS별 sync 스크립트:

- **Windows PowerShell**: `pwsh "<폴더 경로>\setup\sync-commands.ps1"` 또는 `powershell -File "<폴더 경로>\setup\sync-commands.ps1"`
- **macOS·Linux·Git Bash**: `bash "<폴더 경로>/setup/sync-commands.sh"`

스크립트는 repo의 .md 파일을 `~/.claude/commands/` 로 복사합니다.

### SessionStart hook 등록 (선택, 권장)

받는 분에게 묻기:

```
다음 세션부터 자동으로 명령어가 동기화되게 하려면 hook을 등록해야 합니다.
지금 등록할까요? (네/아니오 — 안 해도 수동 실행 가능)
```

네인 경우 `~/.claude/settings.json` 에 SessionStart hook 자동 추가 (백업 먼저).

---

## 5단계: 노션 MCP 활성화 확인

Claude Code의 노션 MCP가 활성화되어 있어야 명령어들이 노션 API 호출 가능합니다.

### Claude가 점검

`mcp__notionApi__API-get-self` 같은 가벼운 API 호출 시도. 응답이 정상이면 활성화됨.

### 활성화되지 않은 경우

받는 분에게 안내:

```
노션 MCP가 활성화되지 않았어요. 다음 단계를 진행해주세요:

1. Claude Code 설정 메뉴 열기 (Cmd+, on Mac, Ctrl+, on Windows)
2. MCP 섹션으로 이동
3. "notionApi" 활성화
4. Claude Code 재시작

완료되면 "활성화했어요" 라고 알려주세요.
```

---

## 6단계: 노션 Integration Secret 받기

받는 분에게 묻기:

```
노션 Integration Secret (ntn_xxx 으로 시작) 을 알려주세요.

발급 방법:
1. https://notion.so/profile/integrations 접속
2. "+ New integration" 클릭
3. 이름 입력 (예: "Claude 학원관리"), 워크스페이스 선택
4. "Submit" 클릭
5. 생성된 페이지에서 "Internal Integration Secret" 의 "Show" → 복사
6. 여기에 붙여넣기
```

받는 분이 입력한 토큰은 메모리에만 유지, 로그·파일에 출력 금지.

---

## 7단계: 노션 부모 페이지 URL 받기 + 권한 검증

받는 분에게 묻기:

```
복제한 학원관리 노션 부모 페이지 URL을 알려주세요.
(예: https://www.notion.so/내워크스페이스/학원관리-abcdef...)
```

URL에서 page_id 추출 (마지막 32자 hex).

### 권한 검증

`mcp__notionApi__API-retrieve-a-page` 로 그 페이지를 조회 시도.

- 성공: 다음 단계로
- 실패 (권한 없음): 받는 분에게 안내

```
이 페이지에 Integration 권한이 없는 것 같아요. 다음을 해주세요:

1. 노션에서 그 페이지로 이동
2. 우상단 ··· 메뉴 클릭
3. "연결" → 6단계에서 만든 Integration 선택

완료되면 "연결했어요" 라고 알려주세요.
```

---

## 8단계: 노션 템플릿 구조 검증 ⭐ 핵심

받는 분의 노션 템플릿이 옥토퍼스코딩 구조와 같은지 검증합니다. **이 단계는 강제 — 실패 시 절대 진행 금지**.

### Claude가 실행

`mcp__notionApi__API-post-search` 로 워크스페이스의 모든 데이터베이스 검색. 그 결과에서 다음 17개 DB를 title 기준으로 매칭:

| 키 | 예상 노션 DB 제목 |
|---|---|
| students | 학생 |
| parents | 학부모 |
| teachers | 선생님 |
| classes | 클래스관리 |
| regular_schedule | 정규수업 시간표 |
| makeup_schedule | 보강수업 시간표 |
| class_enrollments | 수강 등록 |
| lesson_results | 개인 수업결과 (또는 일일피드백) |
| lesson_plans | 수업계획·수업요약 |
| weekly_monthly_feedback | 주간 or 월간피드백 |
| monthly_tuition | 월간 수강료 |
| tuition_lines | 월간 수강료 데이터 |
| consultations_booking | 상담예약 |
| consultations | 상담결과 |
| academy_calendar | 학원 캘린더 |
| refunds | 환불 |
| supplies | 운영 물품구매 |
| boards | 게시판 |

### 매칭 결과 보고

```
DB 매칭 결과:
✓ 학생 → 매칭됨
✓ 학부모 → 매칭됨
...
✗ 환불 → 매칭 안 됨

매칭 17개 중 16개 성공, 1개 누락.
```

### 누락된 DB가 있으면 ⛔ 중단

```
이 노션 템플릿은 옥토퍼스코딩 학원관리 구조와 맞지 않아 설치할 수 없습니다.
누락된 DB: <목록>

해결 방법:
1. 옥토퍼스코딩의 학원관리 노션 템플릿을 다시 복제해주세요.
2. 또는 누락된 DB만 본인이 직접 만들어주세요 (단, 필드 구조도 일치해야 함).

다시 시도하려면 7단계부터 진행합니다. (네/취소)
```

받는 분이 누락된 DB 직접 만들겠다고 하면, 본 셋업은 중단하고 받는 분이 작업 후 다시 시작.

### 핵심 필드 점검 (선택, 매칭 성공한 DB에 한해)

매칭된 DB 각각에 `mcp__notionApi__API-retrieve-a-data-source` 호출해서 핵심 필드 존재 확인. 예:
- 학생 DB: `학생이름`, `등록현황`, `초,중,고`
- 수강 등록 DB: 수강료 패턴 자동 판별 필드

누락 필드가 있으면 경고만 띄우고 진행 (셋업은 가능, 일부 명령어가 동작 안 할 수 있음).

---

## 9단계: 학원 고유값 입력

받는 분에게 한 번에 묻기 (한 화면에 모두 표시):

```
학원 고유 정보를 입력해주세요. 모르거나 안 쓰면 "없음" 또는 빈 답변 OK.

1. 학원명 (예: 옥토퍼스코딩): _______
2. (선택) 학부모 안내 디스코드 웹훅 URL: _______
3. (선택) Claude 세션 저장 디스코드 웹훅 URL: _______
```

웹훅 URL 입력하지 않아도 셋업은 진행 가능. 디스코드 안 쓰면 `/일일피드백발송`, `/시간표변경`, `/상담예약`, `/상담기록`, `/휴강등록` 등 디스코드 의존 명령어만 영향.

---

## 10단계: config 파일 자동 작성

위 단계들에서 모은 값으로 `~/.claude/notion-academy-config.json` 자동 작성.

### 구조

```json
{
  "_comment": "학원 운영 자동화 설정 (Claude Code 노션 명령어용)",
  "_version": 5,
  "_workspace_root": "<노션 부모 페이지 ID>",

  "discord": {
    "parent_webhook": "<9단계 입력값 또는 빈 문자열>",
    "session_save_webhook": "<9단계 입력값 또는 빈 문자열>",
    "username": "학원관리"
  },

  "notion": {
    "api_token": "<6단계 토큰>",
    "data_sources": {
      "students": "<8단계 매칭된 ID>",
      "parents": "<8단계 매칭된 ID>",
      ...
      "boards": "<8단계 매칭된 ID>"
    },
    "boards_database_id": "<게시판 DB의 database_id>"
  },

  "academy": {
    "name": "<9단계 학원명>"
  },

  "tuition": {
    "_comment": "수강료 패턴: [초,중,고] + 정규수업 시간표 수 → 패턴 결정. /수강등록의 월수강료 추천값에 사용.",
    "patterns": {
      "초주1": { "월수강료": 200000, "월기준": 4, "회당단가": 50000, "할인버퍼": 0 },
      "초주2": { "월수강료": 350000, "월기준": 8, "회당단가": 50000, "할인버퍼": 1 },
      "중고주1": { "월수강료": 250000, "월기준": 4, "회당단가": 62500, "할인버퍼": 0 },
      "중고주2": { "월수강료": 400000, "월기준": 8, "회당단가": 50000, "할인버퍼": 0 }
    }
  }
}
```

저장 위치: **`~/.claude/notion-academy-config.json`** (모든 OS 공통, sync 안 되는 로컬 위치).

### 보안

- api_token, 웹훅 URL은 파일에만 저장하고 응답에 다시 출력하지 않음
- 파일 권한 가능하면 600으로 (Mac/Linux)

---

## 11단계: 검증 + 완료 안내

가벼운 read-only 호출로 셋업 검증.

### Claude가 실행

`mcp__notionApi__API-query-data-source` 로 학생 DB 첫 5개 row 조회 시도.

### 성공 시 받는 분에게 안내

```
✓ 셋업 완료!

다음을 시도해보세요:
1. /학생-신규등록 — 가상 학생 1명 등록해보기 (지웠다 다시 해도 됨)
2. /노션-게시판 — 게시판 글 작성 테스트

전체 명령어 22개 자세한 사용법:
<repo 경로>/가이드/사용가이드.html (브라우저로 열어보세요)

문제 생기면 Claude Code 창에 자연어로 물어보세요. 이 시스템과 명령어들을 모두 이해하고 있어서 함께 진단·해결해드립니다.
```

### 실패 시

API 응답의 에러 메시지 그대로 받는 분에게 보여주고, 가능한 원인 짚어주기:
- 401: api_token 잘못됨 → 6단계 재실행
- 404: data_source_id 잘못됨 → 8단계 재실행
- 403: Integration 권한 부족 → 7단계 재실행

---

## 종합 — Claude에게 강조

- **순서 엄격히**: 1 → 2 → 3 → ... → 11. 건너뛰지 마세요.
- **검증 단계 강제**: 8단계는 실패하면 무조건 중단. 누락 DB가 있는데 진행하면 받는 분 환경이 망가집니다.
- **민감값 보호**: api_token, 웹훅 URL을 응답·로그에 다시 출력하지 마세요. 파일에만 저장.
- **모르겠다 답변 처리**: 받는 분이 "잘 모르겠어요" 라고 답하면 추천 옵션을 다시 제시하고 명확한 선택지(번호 또는 Y/N)로 다시 물어보세요.
- **에러는 솔직히**: API 에러 메시지를 받는 분에게 그대로 보여주세요. 추정·번역하지 마세요.
- **셋업 중 중단**: 어느 단계에서든 받는 분이 "중단할게요" 라고 답하면 지금까지 작성된 임시 파일·폴더는 그대로 두고 종료. 다음 세션에서 재개 가능하게.
