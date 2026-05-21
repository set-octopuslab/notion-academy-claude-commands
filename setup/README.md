# setup/

명령어 .md 파일들을 `~/.claude/commands/` 로 복사하는 sync 스크립트입니다.

## 자동 실행 (Claude Code SessionStart hook)

`~/.claude/settings.json` 에 SessionStart hook 등록:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [
          { "type": "command", "command": "bash <repo-경로>/setup/sync-commands.sh" }
        ]
      }
    ]
  }
}
```

(Windows PowerShell 사용자는 `sync-commands.ps1` 로)

## 수동 실행 (테스트용)

```bash
bash setup/sync-commands.sh
```

또는 PowerShell:

```powershell
pwsh setup/sync-commands.ps1
```
