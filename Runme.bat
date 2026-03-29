@echo off
:: 设置字符集为 UTF-8，解决中文乱码
chcp 65001 >nul
setlocal enabledelayedexpansion

set "OUTPUT_FILE=index.html"
set "TITLE=Instant-HTML 工具箱导航"

echo 正在扫描文件夹并生成导航页面...

:: 开始写入 HTML 头部
echo ^<!DOCTYPE html^> > "%OUTPUT_FILE%"
echo ^<html lang="zh-CN"^> >> "%OUTPUT_FILE%"
echo ^<head^> >> "%OUTPUT_FILE%"
echo     ^<meta charset="UTF-8"^> >> "%OUTPUT_FILE%"
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^> >> "%OUTPUT_FILE%"
echo     ^<title^>%TITLE%^</title^> >> "%OUTPUT_FILE%"
echo     ^<style^> >> "%OUTPUT_FILE%"
echo         :root { --primary-color: #4a90e2; --bg-color: #f5f7fa; --card-bg: #ffffff; --text-color: #333333; --shadow: 0 4px 6px rgba(0,0,0,0.1); } >> "%OUTPUT_FILE%"
echo         body { font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif; background-color: var(--bg-color); color: var(--text-color); margin: 0; display: flex; flex-direction: column; height: 100vh; overflow: hidden; } >> "%OUTPUT_FILE%"
echo         header { background-color: var(--card-bg); padding: 0.8rem 1.5rem; box-shadow: var(--shadow); display: flex; justify-content: space-between; align-items: center; z-index: 100; border-bottom: 1px solid #eee; } >> "%OUTPUT_FILE%"
echo         .logo-area { display: flex; align-items: center; gap: 1rem; } >> "%OUTPUT_FILE%"
echo         h1 { margin: 0; font-size: 1.3rem; color: var(--primary-color); } >> "%OUTPUT_FILE%"
echo         #toggle-btn { background: #eee; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; font-size: 14px; transition: background 0.3s; } >> "%OUTPUT_FILE%"
echo         #toggle-btn:hover { background: #ddd; } >> "%OUTPUT_FILE%"
echo         main { display: flex; flex: 1; overflow: hidden; position: relative; } >> "%OUTPUT_FILE%"
echo         #sidebar { width: 280px; background-color: var(--card-bg); border-right: 1px solid #e0e0e0; overflow-y: auto; padding: 1rem; transition: transform 0.3s ease, margin-left 0.3s ease; flex-shrink: 0; } >> "%OUTPUT_FILE%"
echo         #sidebar.hidden { margin-left: -280px; transform: translateX(-100%%); } >> "%OUTPUT_FILE%"
echo         #content { flex: 1; padding: 0; background-color: #f0f2f5; display: flex; flex-direction: column; position: relative; } >> "%OUTPUT_FILE%"
echo         iframe { width: 100%%; height: 100%%; border: none; background-color: white; } >> "%OUTPUT_FILE%"
echo         .folder-group { margin-bottom: 1.2rem; } >> "%OUTPUT_FILE%"
echo         .folder-name { font-weight: bold; color: #888; font-size: 0.8rem; text-transform: uppercase; margin-bottom: 0.5rem; padding-bottom: 3px; border-bottom: 1px solid #f0f0f0; letter-spacing: 1px; } >> "%OUTPUT_FILE%"
echo         .tool-link { display: block; padding: 8px 12px; margin-bottom: 4px; text-decoration: none; color: var(--text-color); border-radius: 6px; transition: all 0.2s; font-size: 0.9rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; } >> "%OUTPUT_FILE%"
echo         .tool-link:hover { background-color: #f0f7ff; color: var(--primary-color); } >> "%OUTPUT_FILE%"
echo         .tool-link.active { background-color: var(--primary-color); color: white; box-shadow: 0 2px 4px rgba(74,144,226,0.3); } >> "%OUTPUT_FILE%"
echo         .search-box { width: 100%%; padding: 8px 12px; margin-bottom: 1rem; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; outline: none; transition: border-color 0.3s; } >> "%OUTPUT_FILE%"
echo         .search-box:focus { border-color: var(--primary-color); } >> "%OUTPUT_FILE%"
echo         .empty-state { display: flex; justify-content: center; align-items: center; height: 100%%; flex-direction: column; color: #aaa; text-align: center; } >> "%OUTPUT_FILE%"
echo         .empty-state h2 { margin-bottom: 10px; color: #888; } >> "%OUTPUT_FILE%"
echo     ^</style^> >> "%OUTPUT_FILE%"
echo ^</head^> >> "%OUTPUT_FILE%"
echo ^<body^> >> "%OUTPUT_FILE%"
echo     ^<header^> >> "%OUTPUT_FILE%"
echo         ^<div class="logo-area"^> >> "%OUTPUT_FILE%"
echo             ^<button id="toggle-btn" title="隐藏/显示侧边栏"^>☰ 菜单^</button^> >> "%OUTPUT_FILE%"
echo             ^<h1^>🛠️ %TITLE%^</h1^> >> "%OUTPUT_FILE%"
echo         ^</div^> >> "%OUTPUT_FILE%"
echo         ^<div id="file-count" style="font-size: 0.9rem; color: #666;"^>正在扫描...^</div^> >> "%OUTPUT_FILE%"
echo     ^</header^> >> "%OUTPUT_FILE%"
echo     ^<main^> >> "%OUTPUT_FILE%"
echo         ^<div id="sidebar"^> >> "%OUTPUT_FILE%"
echo             ^<input type="text" class="search-box" placeholder="🔍 搜索工具..." id="search"^> >> "%OUTPUT_FILE%"
echo             ^<div id="tool-list"^> >> "%OUTPUT_FILE%"

:: 核心：扫描所有子文件夹
for /d %%D in (*) do (
    set "FOLDER_HAS_FILES=0"
    :: 检查文件夹里是否有 HTML 文件
    for %%F in ("%%D\*.html") do (
        set "FOLDER_HAS_FILES=1"
    )
    
    if "!FOLDER_HAS_FILES!"=="1" (
        echo         ^<div class="folder-group"^> >> "%OUTPUT_FILE%"
        echo             ^<div class="folder-name"^>%%D^</div^> >> "%OUTPUT_FILE%"
        for %%F in ("%%D\*.html") do (
            set "FILE_NAME=%%~nxF"
            set "DISPLAY_NAME=%%~nF"
            :: 将反斜杠替换为正斜杠，并处理可能的空格（虽然 HTML 本身支持空格）
            set "FILE_PATH=%%D/!FILE_NAME!"
            echo             ^<a href="#" class="tool-link" data-path="!FILE_PATH!"^>!DISPLAY_NAME!^</a^> >> "%OUTPUT_FILE%"
        )
        echo         ^</div^> >> "%OUTPUT_FILE%"
    )
)

:: 写入 HTML 尾部和 JS 交互
echo             ^</div^> >> "%OUTPUT_FILE%"
echo         ^</div^> >> "%OUTPUT_FILE%"
echo         ^<div id="content"^> >> "%OUTPUT_FILE%"
echo             ^<div id="welcome" class="empty-state"^> >> "%OUTPUT_FILE%"
echo                 ^<h2^>欢迎使用 HTML 工具箱^</h2^> >> "%OUTPUT_FILE%"
echo                 ^<p^>从左侧菜单选择一个工具开始使用吧^</p^> >> "%OUTPUT_FILE%"
echo                 ^<p style="font-size: 0.8rem; margin-top: 20px;"^>提示：点击左上角“菜单”按钮可隐藏侧栏^</p^> >> "%OUTPUT_FILE%"
echo             ^</div^> >> "%OUTPUT_FILE%"
echo             ^<iframe id="tool-frame" style="display: none;"^>^</iframe^> >> "%OUTPUT_FILE%"
echo         ^</div^> >> "%OUTPUT_FILE%"
echo     ^</main^> >> "%OUTPUT_FILE%"
echo     ^<script^> >> "%OUTPUT_FILE%"
echo         const toolLinks = document.querySelectorAll('.tool-link'); >> "%OUTPUT_FILE%"
echo         const toolFrame = document.getElementById('tool-frame'); >> "%OUTPUT_FILE%"
echo         const welcome = document.getElementById('welcome'); >> "%OUTPUT_FILE%"
echo         const searchInput = document.getElementById('search'); >> "%OUTPUT_FILE%"
echo         const fileCount = document.getElementById('file-count'); >> "%OUTPUT_FILE%"
echo         const sidebar = document.getElementById('sidebar'); >> "%OUTPUT_FILE%"
echo         const toggleBtn = document.getElementById('toggle-btn'); >> "%OUTPUT_FILE%"
echo         fileCount.textContent = "共找到 " + toolLinks.length + " 个工具"; >> "%OUTPUT_FILE%"
echo         toggleBtn.onclick = function() { >> "%OUTPUT_FILE%"
echo             sidebar.classList.toggle('hidden'); >> "%OUTPUT_FILE%"
echo         }; >> "%OUTPUT_FILE%"
echo         toolLinks.forEach(function(link) { >> "%OUTPUT_FILE%"
echo             link.onclick = function(e) { >> "%OUTPUT_FILE%"
echo                 e.preventDefault(); >> "%OUTPUT_FILE%"
echo                 toolLinks.forEach(function(l) { l.classList.remove('active'); }); >> "%OUTPUT_FILE%"
echo                 link.classList.add('active'); >> "%OUTPUT_FILE%"
echo                 welcome.style.display = 'none'; >> "%OUTPUT_FILE%"
echo                 toolFrame.style.display = 'block'; >> "%OUTPUT_FILE%"
echo                 toolFrame.src = link.getAttribute('data-path'); >> "%OUTPUT_FILE%"
echo             }; >> "%OUTPUT_FILE%"
echo         }); >> "%OUTPUT_FILE%"
echo         searchInput.oninput = function(e) { >> "%OUTPUT_FILE%"
echo             const filter = e.target.value.toLowerCase(); >> "%OUTPUT_FILE%"
echo             let visibleCount = 0; >> "%OUTPUT_FILE%"
echo             document.querySelectorAll('.folder-group').forEach(function(group) { >> "%OUTPUT_FILE%"
echo                 let groupHasVisible = false; >> "%OUTPUT_FILE%"
echo                 group.querySelectorAll('.tool-link').forEach(function(link) { >> "%OUTPUT_FILE%"
echo                     const text = link.textContent.toLowerCase(); >> "%OUTPUT_FILE%"
echo                     if (text.indexOf(filter) !== -1) { >> "%OUTPUT_FILE%"
echo                         link.style.display = 'block'; >> "%OUTPUT_FILE%"
echo                         groupHasVisible = true; >> "%OUTPUT_FILE%"
echo                         visibleCount++; >> "%OUTPUT_FILE%"
echo                     } else { >> "%OUTPUT_FILE%"
echo                         link.style.display = 'none'; >> "%OUTPUT_FILE%"
echo                     } >> "%OUTPUT_FILE%"
echo                 }); >> "%OUTPUT_FILE%"
echo                 group.style.display = groupHasVisible ? 'block' : 'none'; >> "%OUTPUT_FILE%"
echo             }); >> "%OUTPUT_FILE%"
echo             fileCount.textContent = "匹配到 " + visibleCount + " 个工具"; >> "%OUTPUT_FILE%"
echo         }; >> "%OUTPUT_FILE%"
echo     ^</script^> >> "%OUTPUT_FILE%"
echo ^</body^> >> "%OUTPUT_FILE%"
echo ^</html^> >> "%OUTPUT_FILE%"

echo 生成成功！
echo 正在打开导航页面...
:: 使用 start 直接打开文件，不带中文提示命令，避免编码错误
start "" "%OUTPUT_FILE%"
exit
