#!/bin/bash

echo "╔══════════════════════════════════════════════════════╗"
echo "║  📱 Setup Android - Avaliação de Alunos             ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js não encontrado! Instale em: https://nodejs.org"
    exit 1
fi
echo "✅ Node.js: $(node -v)"

# Verificar npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm não encontrado!"
    exit 1
fi
echo "✅ npm: $(npm -v)"

echo ""
echo "📦 1/6 — Instalando dependências..."
npm install

echo ""
echo "📦 2/6 — Instalando Capacitor..."
npm install @capacitor/core @capacitor/cli @capacitor/android

echo ""
echo "🔧 3/6 — Inicializando Capacitor..."
npx cap init "Avaliação de Alunos" com.avaliacao.alunos --web-dir dist 2>/dev/null || echo "   (Capacitor já inicializado)"

echo ""
echo "🤖 4/6 — Adicionando plataforma Android..."
npx cap add android 2>/dev/null || echo "   (Android já adicionado)"

echo ""
echo "🏗️  5/6 — Build do projeto..."
npm run build

echo ""
echo "🔄 6/6 — Sincronizando com Android..."
npx cap sync android

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ PRONTO!                                         ║"
echo "║                                                      ║"
echo "║  Agora execute:                                      ║"
echo "║    npx cap open android                              ║"
echo "║                                                      ║"
echo "║  No Android Studio:                                  ║"
echo "║    Build → Build Bundle(s)/APK(s) → Build APK(s)    ║"
echo "╚══════════════════════════════════════════════════════╝"
