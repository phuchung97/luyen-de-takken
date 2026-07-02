# serve.ps1 — Server test local bằng PowerShell HttpListener (không cần Python/Node)
# Chạy:  powershell -ExecutionPolicy Bypass -File serve.ps1
# Mở:    http://localhost:8080   —   Ctrl+C để dừng

$port = 8080
$root = $PSScriptRoot

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "takken-drill dang chay tai http://localhost:$port (Ctrl+C de dung)" -ForegroundColor Cyan

$mime = @{
  ".html" = "text/html; charset=utf-8"
  ".json" = "application/json; charset=utf-8"
  ".css"  = "text/css; charset=utf-8"
  ".js"   = "application/javascript; charset=utf-8"
  ".svg"  = "image/svg+xml"
  ".png"  = "image/png"
  ".ico"  = "image/x-icon"
}

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    try {
      $rel = $ctx.Request.Url.LocalPath.TrimStart("/")
      if ([string]::IsNullOrEmpty($rel)) { $rel = "index.html" }
      $path = Join-Path $root $rel

      if (Test-Path $path -PathType Leaf) {
        $ext = [System.IO.Path]::GetExtension($path).ToLower()
        $ctype = $mime[$ext]; if (-not $ctype) { $ctype = "application/octet-stream" }
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $ctx.Response.ContentType = $ctype
        $ctx.Response.Headers.Add("Cache-Control", "no-cache")
        if ($ctx.Request.HttpMethod -eq "HEAD") {
          $ctx.Response.ContentLength64 = $bytes.Length
        } else {
          $ctx.Response.ContentLength64 = $bytes.Length
          $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
        }
      } else {
        $ctx.Response.StatusCode = 404
        if ($ctx.Request.HttpMethod -ne "HEAD") {
          $msg = [System.Text.Encoding]::UTF8.GetBytes("404 - $rel")
          $ctx.Response.ContentLength64 = $msg.Length
          $ctx.Response.OutputStream.Write($msg, 0, $msg.Length)
        }
      }
    } catch {
      # 1 request lỗi không được làm chết server
      try { $ctx.Response.StatusCode = 500 } catch {}
    } finally {
      try { $ctx.Response.OutputStream.Close() } catch {}
    }
  }
} finally {
  $listener.Stop()
}
