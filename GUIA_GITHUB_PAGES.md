# 🌐 Como Publicar no GitHub Pages — Guia Passo a Passo

## 📋 Pré-requisitos

- Uma conta no GitHub (grátis): https://github.com/signup
- Git instalado no computador: https://git-scm.com/downloads

---

## 🚀 PASSO A PASSO

### PASSO 1: Criar conta no GitHub (se não tiver)

1. Acesse https://github.com/signup
2. Crie sua conta gratuitamente

---

### PASSO 2: Instalar o Git no computador

1. Baixe em https://git-scm.com/downloads
2. Instale com as opções padrão
3. Abra o terminal (Prompt de Comando no Windows) e configure:

```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu-email@exemplo.com"
```

---

### PASSO 3: Criar um repositório no GitHub

1. Acesse https://github.com/new
2. Preencha:
   - **Repository name:** `avaliacao-alunos`
   - **Description:** `Sistema de Avaliação de Alunos`
   - **Visibility:** Public ✅ (precisa ser público para GitHub Pages grátis)
   - **NÃO** marque "Add a README file"
3. Clique em **"Create repository"**
4. **Copie a URL** que aparece (algo como `https://github.com/SEU-USUARIO/avaliacao-alunos.git`)

---

### PASSO 4: Preparar os arquivos no seu computador

1. Copie a pasta do projeto para seu computador
2. Abra o terminal na pasta do projeto
3. Execute os comandos:

```bash
# Inicializar o Git
git init

# Adicionar todos os arquivos
git add .

# Criar o primeiro commit
git commit -m "Sistema de Avaliação de Alunos"

# Renomear branch para main
git branch -M main

# Conectar ao repositório do GitHub (troque pela SUA URL)
git remote add origin https://github.com/SEU-USUARIO/avaliacao-alunos.git

# Enviar os arquivos para o GitHub
git push -u origin main
```

> ⚠️ **Substitua** `SEU-USUARIO` pelo seu nome de usuário do GitHub!

---

### PASSO 5: Ativar GitHub Pages

1. No GitHub, acesse seu repositório
2. Clique em **Settings** (⚙️ engrenagem)
3. No menu lateral, clique em **Pages**
4. Em **Source**, selecione **GitHub Actions**
5. **Pronto!** O deploy será feito automaticamente

---

### PASSO 6: Aguardar o deploy

1. Vá na aba **Actions** do seu repositório
2. Você verá o workflow "Deploy to GitHub Pages" rodando
3. Aguarde ficar com ✅ verde (geralmente 1-3 minutos)
4. O site estará disponível em:

```
https://SEU-USUARIO.github.io/avaliacao-alunos/
```

---

## 🎉 PRONTO! Seu site está no ar!

Compartilhe o link com qualquer pessoa. O site funciona em qualquer celular ou computador!

---

## 📱 Acessando pelo celular

1. Abra o navegador do celular (Chrome, Safari, etc.)
2. Acesse `https://SEU-USUARIO.github.io/avaliacao-alunos/`
3. **Dica:** Adicione à tela inicial:
   - **Android:** Menu (⋮) → "Adicionar à tela inicial"
   - **iPhone:** Botão compartilhar (↑) → "Adicionar à Tela de Início"

---

## 🔄 Como atualizar o site

Sempre que fizer alterações nos arquivos:

```bash
git add .
git commit -m "Descrição da alteração"
git push
```

O GitHub Pages atualizará automaticamente em 1-3 minutos.

---

## 🔥 Opcional: Ativar Firebase (sincronização na nuvem)

Se quiser que os dados sejam salvos na nuvem (e não apenas no navegador local):

### 1. Criar projeto Firebase
1. Acesse https://console.firebase.google.com
2. Clique em "Adicionar projeto"
3. Nome: "avaliacao-alunos"
4. Desative Google Analytics (opcional)
5. Clique em "Criar projeto"

### 2. Criar Firestore Database
1. No painel, clique em **Firestore Database**
2. Clique em **"Criar banco de dados"**
3. Selecione **"Iniciar no modo de teste"**
4. Escolha a região: `southamerica-east1` (São Paulo)
5. Clique em **"Ativar"**

### 3. Pegar credenciais
1. Clique na engrenagem ⚙️ → **"Configurações do projeto"**
2. Em "Seus apps", clique no ícone **</>** (Web)
3. Nome: "avaliacao-alunos"
4. Clique em "Registrar app"
5. **Copie os dados** do `firebaseConfig`

### 4. Configurar no projeto
1. Abra o arquivo `src/firebase/config.ts`
2. Substitua os valores de exemplo pelas suas credenciais reais:

```typescript
const firebaseConfig = {
  apiKey: "SUA-API-KEY-AQUI",
  authDomain: "seu-projeto.firebaseapp.com",
  projectId: "seu-projeto",
  storageBucket: "seu-projeto.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abc123"
};
```

### 5. Atualizar o site
```bash
git add .
git commit -m "Configurar Firebase"
git push
```

---

## ❓ Problemas comuns

### "Page not found" (404)
- Verifique se ativou GitHub Pages em Settings → Pages → Source: GitHub Actions
- Aguarde 1-3 minutos para o deploy completar

### O workflow falhou (❌ vermelho)
- Vá em Actions → clique no workflow → veja o erro
- Geralmente é problema de dependência — tente novamente

### Os dados não aparecem entre dispositivos
- Sem Firebase: dados ficam salvos apenas no navegador local de cada dispositivo
- Com Firebase: dados sincronizam entre todos os dispositivos automaticamente

### Como colocar domínio próprio?
1. Settings → Pages → Custom domain
2. Digite seu domínio (ex: `avaliacao.seusite.com`)
3. Configure o DNS no seu provedor de domínio

---

## 📊 Resumo

| Item | Detalhe |
|------|---------|
| **URL do site** | `https://SEU-USUARIO.github.io/avaliacao-alunos/` |
| **Custo** | Grátis |
| **Limite de tamanho** | 1 GB por repositório |
| **HTTPS** | Sim, automático |
| **Domínio próprio** | Suportado |
| **Atualização** | Automática a cada `git push` |
| **Armazenamento** | localStorage (local) ou Firebase (nuvem) |
