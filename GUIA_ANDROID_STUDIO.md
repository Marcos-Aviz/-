# 📱 GUIA COMPLETO: Gerar APK no Android Studio

## ⚡ Resumo Rápido (para quem já sabe)
```bash
npm install @capacitor/core @capacitor/cli
npx cap init "Avaliação de Alunos" com.avaliacao.alunos --web-dir dist
npx cap add android
npm run build
npx cap sync
npx cap open android
# Android Studio → Build → Build Bundle(s)/APK(s) → Build APK(s)
```

---

## 📋 PRÉ-REQUISITOS

### 1. Node.js (v18+)
- Baixe em: https://nodejs.org
- Verifique: `node -v` no terminal

### 2. Android Studio
- Baixe em: https://developer.android.com/studio
- Na instalação, marque:
  - ✅ Android SDK
  - ✅ Android SDK Platform
  - ✅ Android Virtual Device (AVD)

### 3. Java Development Kit (JDK 17+)
- O Android Studio geralmente já instala
- Verifique: `java -version`

### 4. Firebase (já configurado no código)
- Acesse: https://console.firebase.google.com
- Crie um projeto e configure o Firestore

---

## 🔥 PASSO 1: Configurar o Firebase

### 1.1 Criar Projeto no Firebase Console
1. Acesse https://console.firebase.google.com
2. Clique em **"Adicionar projeto"**
3. Nome: `avaliacao-alunos` (ou o que preferir)
4. Desative o Google Analytics (opcional)
5. Clique em **"Criar projeto"**

### 1.2 Criar App Web no Firebase
1. Na página inicial do projeto, clique no ícone **</>** (Web)
2. Nome do app: `Avaliação de Alunos`
3. **NÃO** marque "Firebase Hosting"
4. Clique em **"Registrar app"**
5. Copie as credenciais que aparecem:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSy...",
  authDomain: "seu-projeto.firebaseapp.com",
  projectId: "seu-projeto-id",
  storageBucket: "seu-projeto.firebasestorage.app",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abc123"
};
```

### 1.3 Criar o Firestore Database
1. No menu lateral, clique em **"Firestore Database"**
2. Clique em **"Criar banco de dados"**
3. Selecione **"Modo de teste"** (permite leitura/escrita por 30 dias)
4. Escolha a região mais próxima (ex: `southamerica-east1` para Brasil)
5. Clique em **"Ativar"**

### 1.4 Configurar Regras de Segurança
No Firestore, vá em **"Regras"** e cole:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```
> ⚠️ Isso é para desenvolvimento. Em produção, restrinja o acesso.

### 1.5 Colar as Credenciais no Código
Abra o arquivo `src/firebase/config.ts` e substitua:
```typescript
const firebaseConfig = {
  apiKey: "SUA_API_KEY_REAL",
  authDomain: "SEU_PROJETO.firebaseapp.com",
  projectId: "SEU_PROJETO_ID_REAL",
  storageBucket: "SEU_PROJETO.firebasestorage.app",
  messagingSenderId: "SEU_SENDER_ID_REAL",
  appId: "SEU_APP_ID_REAL"
};
```

---

## 📦 PASSO 2: Preparar o Projeto

### 2.1 Abra o Terminal na pasta do projeto
```bash
cd /caminho/para/o/projeto
```

### 2.2 Instale as dependências do projeto
```bash
npm install
```

### 2.3 Teste se o projeto roda
```bash
npm run dev
```
- Abra o navegador em `http://localhost:5173`
- Verifique se a lista de alunos aparece
- Teste adicionar uma observação para confirmar o Firebase

### 2.4 Faça o Build de produção
```bash
npm run build
```
- Isso cria a pasta `dist/` com o app otimizado

---

## 🔌 PASSO 3: Instalar o Capacitor

### 3.1 Instalar pacotes do Capacitor
```bash
npm install @capacitor/core @capacitor/cli
```

### 3.2 Inicializar o Capacitor
```bash
npx cap init "Avaliação de Alunos" com.avaliacao.alunos --web-dir dist
```
> Se já existir o arquivo `capacitor.config.ts`, ele vai perguntar se quer sobrescrever.
> Pode dizer **SIM** ou manter o existente (já está configurado).

### 3.3 Adicionar plataforma Android
```bash
npm install @capacitor/android
npx cap add android
```
> Isso cria a pasta `android/` com o projeto nativo.

### 3.4 Sincronizar o build com o Android
```bash
npm run build
npx cap sync
```

---

## 🤖 PASSO 4: Abrir no Android Studio

### 4.1 Abrir o projeto Android
```bash
npx cap open android
```
> Isso abre automaticamente o Android Studio com a pasta `android/`

### 4.2 Alternativa Manual
Se o comando acima não funcionar:
1. Abra o **Android Studio**
2. Clique em **"Open"**
3. Navegue até a pasta do projeto e selecione a pasta **`android`**
4. Clique em **"OK"**

### 4.3 Aguarde a sincronização do Gradle
- O Android Studio vai baixar dependências (pode demorar 5-10 min na primeira vez)
- Aguarde a barra de progresso inferior completar
- Se pedir para atualizar o Gradle, aceite

---

## 🏗️ PASSO 5: Gerar o APK

### 5.1 Build APK de Debug (para testar)
1. No Android Studio, vá em: **Build** → **Build Bundle(s)/APK(s)** → **Build APK(s)**
2. Aguarde a compilação (1-3 minutos)
3. Quando terminar, clique em **"locate"** na notificação que aparece
4. O APK está em: `android/app/build/outputs/apk/debug/app-debug.apk`

### 5.2 Build APK de Release (para distribuir)
1. Vá em: **Build** → **Generate Signed Bundle/APK**
2. Selecione **"APK"** → **Next**
3. Crie um **Key Store** (primeira vez):
   - Clique em **"Create new..."**
   - Escolha um local e nome para o arquivo `.jks`
   - Defina uma senha (ANOTE! Não pode recuperar)
   - Preencha pelo menos o campo **"First and Last Name"**
   - Clique em **"OK"**
4. Preencha as senhas do Key Store
5. Selecione **"release"** como Build Variant
6. Marque **"V1 (Jar Signature)"** e **"V2 (Full APK Signature)"**
7. Clique em **"Finish"**
8. O APK está em: `android/app/build/outputs/apk/release/app-release.apk`

---

## 📲 PASSO 6: Instalar no Celular

### Opção A: Cabo USB
1. No celular, ative **"Opções do desenvolvedor"**:
   - Configurações → Sobre o telefone → Toque 7x no "Número da versão"
2. Ative **"Depuração USB"**
3. Conecte o cabo USB
4. Copie o APK para o celular
5. Abra o gerenciador de arquivos e instale

### Opção B: Bluetooth/WhatsApp/Email
1. Envie o arquivo `.apk` por qualquer meio
2. No celular, abra o arquivo
3. Permita "Instalar de fontes desconhecidas" se solicitado

### Opção C: Rodar direto pelo Android Studio
1. Conecte o celular via USB (com Depuração USB ativada)
2. No Android Studio, clique no botão ▶️ **Run**
3. Selecione seu dispositivo
4. O app instala e abre automaticamente!

---

## 🧪 PASSO 7: Testar no Emulador (Opcional)

### 7.1 Criar um dispositivo virtual
1. No Android Studio: **Tools** → **Device Manager**
2. Clique em **"Create Device"**
3. Selecione **"Pixel 6"** (ou outro) → **Next**
4. Baixe uma imagem do sistema (ex: API 34) → **Next**
5. Clique em **"Finish"**

### 7.2 Rodar no emulador
1. Clique no botão ▶️ **Run**
2. Selecione o emulador criado
3. O app abre no emulador!

---

## 🛠️ DICAS E SOLUÇÃO DE PROBLEMAS

### Erro: "SDK location not found"
Crie um arquivo `android/local.properties` com:
```
sdk.dir=/Users/SEU_USUARIO/Library/Android/sdk  (Mac)
sdk.dir=C\:\\Users\\SEU_USUARIO\\AppData\\Local\\Android\\Sdk  (Windows)
```

### Erro: "Gradle sync failed"
- File → Invalidate Caches → Restart
- Ou: delete a pasta `android/.gradle` e sincronize novamente

### App aparece com tela branca
- Verifique se fez `npm run build` antes de `npx cap sync`
- A pasta `dist/` precisa existir com os arquivos

### Firebase não conecta no emulador
- O emulador precisa de internet
- Verifique se as credenciais do Firebase estão corretas

### Atualizar o app após mudanças no código
```bash
npm run build
npx cap sync
```
Depois, faça Build APK novamente no Android Studio.

---

## 📁 ESTRUTURA FINAL DO PROJETO

```
projeto/
├── android/                    ← Projeto Android (gerado pelo Capacitor)
│   ├── app/
│   │   ├── build/
│   │   │   └── outputs/
│   │   │       └── apk/
│   │   │           └── debug/
│   │   │               └── app-debug.apk  ← SEU APK!
│   │   └── src/
│   └── build.gradle
├── dist/                       ← Build de produção (web)
├── src/                        ← Código-fonte
│   ├── firebase/config.ts      ← Credenciais Firebase (EDITAR!)
│   ├── db/database.ts          ← Operações Firestore
│   ├── hooks/useObservations.ts
│   ├── data/students.ts        ← Lista dos 172 alunos
│   ├── App.tsx                 ← Interface principal
│   ├── main.tsx
│   └── index.css
├── capacitor.config.ts         ← Configuração do Capacitor
├── package.json
├── vite.config.ts
└── index.html
```

---

## ✅ CHECKLIST FINAL

- [ ] Node.js instalado (v18+)
- [ ] Android Studio instalado com SDK
- [ ] Projeto Firebase criado
- [ ] Firestore Database criado (modo teste)
- [ ] Credenciais coladas em `src/firebase/config.ts`
- [ ] `npm install` executado
- [ ] `npm run build` executado com sucesso
- [ ] Capacitor instalado (`@capacitor/core`, `@capacitor/cli`, `@capacitor/android`)
- [ ] `npx cap init` executado
- [ ] `npx cap add android` executado
- [ ] `npx cap sync` executado
- [ ] Android Studio aberto com a pasta `android/`
- [ ] Build APK gerado com sucesso
- [ ] APK instalado no celular

---

## 📞 Comandos Rápidos de Referência

```bash
# Desenvolvimento
npm run dev                    # Rodar localmente no navegador

# Build
npm run build                  # Gerar build de produção

# Capacitor
npx cap sync                   # Sincronizar build com Android
npx cap open android           # Abrir no Android Studio
npx cap run android            # Build + instalar no dispositivo conectado

# Tudo de uma vez (após mudanças)
npm run build && npx cap sync && npx cap open android
```

---

**Pronto! Com este guia você consegue gerar o APK e instalar no celular! 🎉📱**
