@echo off
chcp 65001 >nul 2>&1

echo ╔══════════════════════════════════════════════════════╗
echo ║  📱 Setup Android - Avaliação de Alunos             ║
echo ╚══════════════════════════════════════════════════════╝
echo.

REM Verificar Node.js
where node >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Node.js nao encontrado! Instale em: https://nodejs.org
    pause
    exit /b 1
)
echo ✅ Node.js encontrado

REM Verificar npm
where npm >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ npm nao encontrado!
    pause
    exit /b 1
)
echo ✅ npm encontrado

echo.
echo 📦 1/6 — Instalando dependencias...
call npm install

echo.
echo 📦 2/6 — Instalando Capacitor...
call npm install @capacitor/core @capacitor/cli @capacitor/android

echo.
echo 🔧 3/6 — Inicializando Capacitor...
call npx cap init "Avaliação de Alunos" com.avaliacao.alunos --web-dir dist 2>nul
if %ERRORLEVEL% NEQ 0 echo    (Capacitor ja inicializado)

echo.
echo 🤖 4/6 — Adicionando plataforma Android...
call npx cap add android 2>nul
if %ERRORLEVEL% NEQ 0 echo    (Android ja adicionado)

echo.
echo 🏗️  5/6 — Build do projeto...
call npm run build

echo.
echo 🔄 6/6 — Sincronizando com Android...
call npx cap sync android

echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║  ✅ PRONTO!                                         ║
echo ║                                                      ║
echo ║  Agora execute no terminal:                          ║
echo ║    npx cap open android                              ║
echo ║                                                      ║
echo ║  No Android Studio:                                  ║
echo ║    Build → Build Bundle(s)/APK(s) → Build APK(s)    ║
echo ╚══════════════════════════════════════════════════════╝
echo.
pause
