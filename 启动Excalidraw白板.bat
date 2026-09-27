@echo off
setlocal
chcp 936 >nul 2>&1
title Excalidraw 白板 - 启动器

set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "BUILD=%ROOT%\build"

set "PORT=8080"
if not "%~1"=="" set "PORT=%~1"
set "URL=http://127.0.0.1:%PORT%/"

cls
echo ============================================================
echo              Excalidraw 白板   -   一键启动
echo ============================================================
echo    项目目录 : %ROOT%
echo    访问地址 : %URL%
echo ============================================================
echo.

REM ---------------- 定位 Python ----------------
set "PY="
if exist "C:\Users\Administrator\.workbuddy\binaries\python\versions\3.13.12\python.exe" set "PY=C:\Users\Administrator\.workbuddy\binaries\python\versions\3.13.12\python.exe"
if not defined PY if exist "C:\Users\Administrator\AppData\Local\Programs\Python\Python311\python.exe" set "PY=C:\Users\Administrator\AppData\Local\Programs\Python\Python311\python.exe"
if not defined PY for %%P in (python.exe) do if not defined PY set "PY=%%~$PATH:P"

if not defined PY (
  echo    [错误] 找不到 Python，请先安装 Python 3。
  echo           或右键编辑本文件，手动修改 Python 路径那一行。
  echo.
  if not defined NOPAUSE pause
  exit /b 1
)
if not exist "%BUILD%" (
  echo    [错误] 找不到应用目录：%BUILD%
  echo.
  if not defined NOPAUSE pause
  exit /b 1
)
echo    [环境] Python : %PY%
echo.

REM ---------------- 端口是否已在监听 ----------------
call :ISLISTENING
if "%LISTENING%"=="1" (
  echo    [提示] 服务已经在运行了，无需重复启动。
  goto :OPENURL
)

REM ---------------- 启动服务 ----------------
echo    [1/2] 正在启动本地服务 ...
start "Excalidraw-%PORT%" /min "%PY%" -m http.server %PORT% --bind 127.0.0.1 --directory "%BUILD%"

echo    [2/2] 等待服务就绪 ...
set /a _w=0
:WAITLOOP
set /a _w+=1
call :ISLISTENING
if "%LISTENING%"=="1" goto :OPENURL
if %_w% GEQ 30 goto :TIMEOUT
ping -n 2 127.0.0.1 >nul 2>&1
goto :WAITLOOP

:OPENURL
echo.
if defined NOBROWSER (
  echo    [完成] 服务已就绪（测试模式：未打开浏览器）
) else (
  start "" "%URL%"
  echo    [完成] 浏览器已打开。若没弹出，请手动访问：%URL%
)
echo.
echo    ------------------------------------------------------------
echo     停止服务：关掉任务栏里那个最小化的 "Excalidraw-%PORT%" 窗口
echo    ------------------------------------------------------------
echo.
if not defined NOPAUSE pause
exit /b 0

:TIMEOUT
echo.
echo    [警告] 等待超时，服务可能没启动成功。
echo           可以手动执行下面这条命令看看报错：
echo           "%PY%" -m http.server %PORT% --bind 127.0.0.1 --directory "%BUILD%"
echo.
if not defined NOPAUSE pause
exit /b 1

REM ---------------- 子过程：检测端口 ----------------
:ISLISTENING
set "LISTENING=0"
netstat -ano | findstr /r /c:":%PORT% .*LISTENING" >nul 2>&1
if not errorlevel 1 set "LISTENING=1"
exit /b 0
