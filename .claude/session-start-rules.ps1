$ErrorActionPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Read-FileSafe($path) {
    if (Test-Path -LiteralPath $path) {
        try { return Get-Content -Raw -LiteralPath $path -Encoding UTF8 } catch { return "" }
    }
    return ""
}

$f1 = Read-FileSafe 'D:\mydocs\개발준수사항.txt'
$f2 = Read-FileSafe 'D:\dev\환경변수.txt'
$f3 = Read-FileSafe 'docs\지침.txt'

$ctx = @"
[자동 주입] 매 대화 시작 시 필수 문서 (SessionStart 훅으로 주입됨)

이 컨텍스트는 매 세션 시작 시 원본 파일에서 새로 읽어 주입된 것이다.
첫 응답 전에 추가로 Read 호출할 필요 없음. 단, 사용자가 '읽었냐' 물으면 읽었다고 답할 수 있음.
우선순위: docs/지침.txt > D:\mydocs\개발준수사항.txt

================================================================
[1] D:\mydocs\개발준수사항.txt
================================================================
$f1

================================================================
[2] D:\dev\환경변수.txt
================================================================
$f2

================================================================
[3] 현재 프로젝트 docs/지침.txt
================================================================
$f3
"@

$out = @{
    hookSpecificOutput = @{
        hookEventName = 'SessionStart'
        additionalContext = $ctx
    }
} | ConvertTo-Json -Compress -Depth 10

Write-Output $out
