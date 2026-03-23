# 📱 GUIA COMPLETO — Sistema de Avaliação de Alunos no MIT App Inventor

## Este guia ensina PASSO A PASSO como criar o app no MIT App Inventor com Firebase

---

## 📋 ÍNDICE

1. [Configurar Firebase](#1-configurar-firebase)
2. [Criar Projeto no App Inventor](#2-criar-projeto-no-app-inventor)
3. [Tela 1 — Lista de Alunos](#3-tela-1--lista-de-alunos)
4. [Blocos da Tela 1](#4-blocos-da-tela-1)
5. [Tela 2 — Ficha do Aluno](#5-tela-2--ficha-do-aluno)
6. [Blocos da Tela 2](#6-blocos-da-tela-2)
7. [Tela 3 — Adicionar Observação](#7-tela-3--adicionar-observação)
8. [Blocos da Tela 3](#8-blocos-da-tela-3)
9. [Carregar Alunos no Firebase](#9-carregar-alunos-no-firebase)
10. [Gerar APK](#10-gerar-apk)
11. [Solução de Problemas](#11-solução-de-problemas)

---

## 1. CONFIGURAR FIREBASE

### 1.1 Criar projeto Firebase
1. Acesse: https://console.firebase.google.com
2. Clique em **"Adicionar projeto"**
3. Nome: `avaliacao-alunos`
4. Desative Google Analytics (opcional)
5. Clique **"Criar projeto"**

### 1.2 Criar Realtime Database
1. No menu lateral: **Build → Realtime Database**
2. Clique **"Criar banco de dados"**
3. Selecione a região (us-central1)
4. Selecione **"Iniciar no modo de teste"**
5. Clique **"Ativar"**

### 1.3 Copiar URL e Token
1. **URL do banco**: Fica no topo da página do Realtime Database
   - Exemplo: `https://avaliacao-alunos-xxxxx-default-rtdb.firebaseio.com/`
2. **Token do projeto**: 
   - Vá em ⚙️ Configurações → Contas de serviço → Chaves secretas do banco de dados
   - Clique "Mostrar" e copie a chave
   
> ⚠️ GUARDE essas duas informações! Vai precisar no App Inventor.

### 1.4 Carregar os Alunos no Firebase
1. No Realtime Database, clique nos 3 pontos ⋮ → **"Importar JSON"**
2. Crie um arquivo chamado `alunos.json` no seu computador com o conteúdo da seção 9 deste guia
3. Faça upload do arquivo

---

## 2. CRIAR PROJETO NO APP INVENTOR

1. Acesse: https://ai2.appinventor.mit.edu
2. Faça login com sua conta Google
3. Clique **"Start new project"**
4. Nome: `AvaliacaoAlunos`
5. Clique **"OK"**

---

## 3. TELA 1 — LISTA DE ALUNOS (Screen1)

### 3.1 Propriedades da Screen1
| Propriedade | Valor |
|-------------|-------|
| Title | Avaliação de Alunos |
| BackgroundColor | Branco |
| ScreenOrientation | Portrait |
| Scrollable | ✅ marcado |
| TitleVisible | true |
| Theme | Device Default |

### 3.2 Componentes (Designer) — ADICIONE NA ORDEM:

#### A) HorizontalArrangement1 (Barra de busca)
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| Height | Automatic |
| AlignVertical | Center |
| BackgroundColor | #1B5E20 (verde escuro) |
| Padding | 8 |

Dentro de HorizontalArrangement1, adicione:

##### → TextBox_Busca
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| Hint | 🔍 Buscar aluno... |
| FontSize | 16 |
| BackgroundColor | Branco |
| TextColor | Preto |

#### B) Label_Total
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| Text | Carregando alunos... |
| FontSize | 14 |
| TextColor | #666666 |
| TextAlignment | Center |
| Padding | 4 |

#### C) ListView_Alunos
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| Height | Fill parent |
| FontSize | 18 |
| TextColor | Preto |
| BackgroundColor | Branco |
| Selection | (vazio) |

#### D) Componentes NÃO VISÍVEIS (na paleta):

##### → FirebaseDB1 (Connectivity → FirebaseDB)
| Propriedade | Valor |
|-------------|-------|
| FirebaseURL | Cole a URL do seu Firebase |
| FirebaseToken | Cole o token do seu Firebase |
| ProjectBucket | /alunos |

##### → TinyDB1 (Storage → TinyDB)
(Usado para passar dados entre telas)

##### → Notifier1 (User Interface → Notifier)

##### → Clock_Init (Sensors → Clock)
| Propriedade | Valor |
|-------------|-------|
| TimerEnabled | true |
| TimerInterval | 500 |
| TimerAlwaysFires | false |

---

## 4. BLOCOS DA TELA 1

### 4.1 Variáveis globais
Crie estas variáveis (Variables → initialize global):

```
initialize global listaAlunos to → create empty list
initialize global listaFiltrada to → create empty list
initialize global listaNumeros to → create empty list
initialize global numerosFiltrados to → create empty list
```

### 4.2 Quando a tela inicializar
```
when Screen1.Initialize do
  set FirebaseDB1.ProjectBucket to "/alunos"
  call FirebaseDB1.GetValue
    tag = "lista"
    valueIfTagNotThere = "vazio"
```

### 4.3 Quando Firebase retornar valor
```
when FirebaseDB1.GotValue do
  if tag = "lista" then
    if value ≠ "vazio" then
      set global listaAlunos to → value
      call AtualizarLista
    else
      set Label_Total.Text to "Nenhum aluno encontrado. Importe os dados."
    end if
  end if
```

### 4.4 Procedimento AtualizarLista
Crie um procedimento (Procedures → to procedure):
```
to AtualizarLista do
  set global listaFiltrada to → create empty list
  set global numerosFiltrados to → create empty list
  
  // Pegar texto da busca
  local textoBusca = → call Text.Upcase(TextBox_Busca.Text)
  
  // Loop por cada item na listaAlunos
  for each item in global listaAlunos do
    // Cada item é uma lista [nome, numero]
    local nome = select list item(item, index 1)
    local numero = select list item(item, index 2)
    
    // Se busca vazia OU nome contém busca OU numero contém busca
    if textoBusca = "" 
       OR Text.Contains(call Text.Upcase(nome), textoBusca)
       OR Text.Contains(numero, TextBox_Busca.Text)
    then
      add items to list(global listaFiltrada, 
        join(numero, " - ", nome))
      add items to list(global numerosFiltrados, numero)
    end if
  end for
  
  set ListView_Alunos.Elements to → global listaFiltrada
  set Label_Total.Text to → join(length of list(global listaFiltrada), " alunos")
end procedure
```

### 4.5 Quando o texto da busca mudar
```
when TextBox_Busca.Changed do
  call AtualizarLista
```

### 4.6 Quando selecionar um aluno na lista
```
when ListView_Alunos.AfterPicking do
  // Pegar o índice selecionado
  local indice = ListView_Alunos.SelectionIndex
  local numero = select list item(global numerosFiltrados, indice)
  
  // Encontrar o nome do aluno
  local textoSelecionado = ListView_Alunos.Selection
  
  // Salvar no TinyDB para a próxima tela
  call TinyDB1.StoreValue
    tag = "alunoNumero"
    valueToStore = numero
  call TinyDB1.StoreValue
    tag = "alunoNome"  
    valueToStore = textoSelecionado
    
  // Abrir tela do aluno
  open another screen: screenName = "TelaAluno"
```

---

## 5. TELA 2 — FICHA DO ALUNO (TelaAluno)

### 5.1 Criar nova tela
1. No menu: **Add Screen...**
2. Nome: `TelaAluno`

### 5.2 Propriedades da TelaAluno
| Propriedade | Valor |
|-------------|-------|
| Title | Ficha do Aluno |
| BackgroundColor | #F5F5F5 |
| ScreenOrientation | Portrait |
| Scrollable | ✅ marcado |

### 5.3 Componentes:

#### A) VerticalArrangement_Header
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| Height | Automatic |
| BackgroundColor | #1B5E20 |
| AlignHorizontal | Center |
| Padding | 16 |

Dentro, adicione:

##### → Label_NomeAluno
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| FontSize | 22 |
| FontBold | ✅ |
| TextColor | Branco |
| TextAlignment | Center |
| Text | Nome do Aluno |

##### → Label_NumeroAluno
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| FontSize | 16 |
| TextColor | #C8E6C9 (verde claro) |
| TextAlignment | Center |
| Text | Nº 0000 |

#### B) HorizontalArrangement_Stats
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| Height | Automatic |
| AlignHorizontal | Center |
| Padding | 8 |

Dentro, adicione 3 labels:

##### → Label_Positivas
| Propriedade | Valor |
|-------------|-------|
| Width | 33% |
| FontSize | 16 |
| TextColor | #2E7D32 (verde) |
| TextAlignment | Center |
| Text | ✅ 0 |
| FontBold | ✅ |

##### → Label_Negativas
| Propriedade | Valor |
|-------------|-------|
| Width | 33% |
| FontSize | 16 |
| TextColor | #C62828 (vermelho) |
| TextAlignment | Center |
| Text | ⚠️ 0 |
| FontBold | ✅ |

##### → Label_TotalObs
| Propriedade | Valor |
|-------------|-------|
| Width | 33% |
| FontSize | 16 |
| TextColor | #333333 |
| TextAlignment | Center |
| Text | 📋 0 |
| FontBold | ✅ |

#### C) HorizontalArrangement_Filtros
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| Height | Automatic |
| AlignHorizontal | Center |
| Padding | 4 |

Dentro, adicione 3 botões:

##### → Button_Todas
| Propriedade | Valor |
|-------------|-------|
| Text | Todas |
| BackgroundColor | #1B5E20 |
| TextColor | Branco |
| FontSize | 14 |
| Shape | rounded |
| Width | 30% |

##### → Button_SoPositivas
| Propriedade | Valor |
|-------------|-------|
| Text | ✅ Positivas |
| BackgroundColor | #E8F5E9 |
| TextColor | #2E7D32 |
| FontSize | 14 |
| Shape | rounded |
| Width | 33% |

##### → Button_SoNegativas
| Propriedade | Valor |
|-------------|-------|
| Text | ⚠️ Negativas |
| BackgroundColor | #FFEBEE |
| TextColor | #C62828 |
| FontSize | 14 |
| Shape | rounded |
| Width | 33% |

#### D) ListView_Observacoes
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| Height | 300 pixels |
| FontSize | 14 |

#### E) HorizontalArrangement_Botoes (na parte inferior)
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| AlignHorizontal | Center |
| Padding | 8 |

Dentro, adicione:

##### → Button_Adicionar
| Propriedade | Valor |
|-------------|-------|
| Text | ➕ Adicionar Observação |
| BackgroundColor | #2E7D32 |
| TextColor | Branco |
| FontSize | 16 |
| FontBold | ✅ |
| Width | Fill parent |
| Shape | rounded |

##### → Button_Voltar
| Propriedade | Valor |
|-------------|-------|
| Text | ← Voltar |
| BackgroundColor | #757575 |
| TextColor | Branco |
| FontSize | 14 |
| Width | Fill parent |
| Shape | rounded |

#### F) Componentes NÃO VISÍVEIS:

##### → FirebaseDB2 (FirebaseDB)
| Propriedade | Valor |
|-------------|-------|
| FirebaseURL | (mesma URL do Firebase) |
| FirebaseToken | (mesmo token) |
| ProjectBucket | /observacoes |

##### → TinyDB2 (TinyDB)
##### → Notifier2 (Notifier)
##### → Clock1 (Clock) — para formatar datas

---

## 6. BLOCOS DA TELA 2

### 6.1 Variáveis globais
```
initialize global alunoNumero to → ""
initialize global alunoNome to → ""
initialize global observacoes to → create empty list
initialize global filtroAtual to → "todas"
initialize global obsExibidas to → create empty list
```

### 6.2 Quando a tela inicializar
```
when TelaAluno.Initialize do
  // Recuperar dados do TinyDB
  set global alunoNumero to → call TinyDB2.GetValue(tag="alunoNumero", valueIfTagNotThere="")
  set global alunoNome to → call TinyDB2.GetValue(tag="alunoNome", valueIfTagNotThere="")
  
  set Label_NomeAluno.Text to → global alunoNome
  set Label_NumeroAluno.Text to → join("Nº ", global alunoNumero)
  
  // Buscar observações do Firebase
  set FirebaseDB2.ProjectBucket to → join("/observacoes/", global alunoNumero)
  call FirebaseDB2.GetValue
    tag = "lista"
    valueIfTagNotThere = "vazio"
```

### 6.3 Quando Firebase retornar valor
```
when FirebaseDB2.GotValue do
  if value ≠ "vazio" then
    set global observacoes to → value
  else
    set global observacoes to → create empty list
  end if
  call AtualizarObservacoes
```

### 6.4 Procedimento AtualizarObservacoes
```
to AtualizarObservacoes do
  set global obsExibidas to → create empty list
  local contPositivas = 0
  local contNegativas = 0
  
  for each obs in global observacoes do
    // Cada obs é uma lista: [tipo, texto, data]
    // tipo: "positiva" ou "negativa"
    local tipo = select list item(obs, index 1)
    local texto = select list item(obs, index 2)
    local data = select list item(obs, index 3)
    
    if tipo = "positiva" then
      set contPositivas to → contPositivas + 1
    else
      set contNegativas to → contNegativas + 1
    end if
    
    // Aplicar filtro
    if global filtroAtual = "todas"
       OR (global filtroAtual = "positiva" AND tipo = "positiva")
       OR (global filtroAtual = "negativa" AND tipo = "negativa")
    then
      if tipo = "positiva" then
        add items to list(global obsExibidas, 
          join("✅ ", texto, " (", data, ")"))
      else
        add items to list(global obsExibidas, 
          join("⚠️ ", texto, " (", data, ")"))
      end if
    end if
  end for
  
  set ListView_Observacoes.Elements to → global obsExibidas
  set Label_Positivas.Text to → join("✅ ", contPositivas)
  set Label_Negativas.Text to → join("⚠️ ", contNegativas)
  set Label_TotalObs.Text to → join("📋 ", contPositivas + contNegativas)
end procedure
```

### 6.5 Botões de filtro
```
when Button_Todas.Click do
  set global filtroAtual to "todas"
  set Button_Todas.BackgroundColor to #1B5E20
  set Button_Todas.TextColor to Branco
  set Button_SoPositivas.BackgroundColor to #E8F5E9
  set Button_SoPositivas.TextColor to #2E7D32
  set Button_SoNegativas.BackgroundColor to #FFEBEE
  set Button_SoNegativas.TextColor to #C62828
  call AtualizarObservacoes

when Button_SoPositivas.Click do
  set global filtroAtual to "positiva"
  set Button_SoPositivas.BackgroundColor to #2E7D32
  set Button_SoPositivas.TextColor to Branco
  set Button_Todas.BackgroundColor to #E0E0E0
  set Button_Todas.TextColor to #333333
  set Button_SoNegativas.BackgroundColor to #FFEBEE
  set Button_SoNegativas.TextColor to #C62828
  call AtualizarObservacoes

when Button_SoNegativas.Click do
  set global filtroAtual to "negativa"
  set Button_SoNegativas.BackgroundColor to #C62828
  set Button_SoNegativas.TextColor to Branco
  set Button_Todas.BackgroundColor to #E0E0E0
  set Button_Todas.TextColor to #333333
  set Button_SoPositivas.BackgroundColor to #E8F5E9
  set Button_SoPositivas.TextColor to #2E7D32
  call AtualizarObservacoes
```

### 6.6 Botão Adicionar
```
when Button_Adicionar.Click do
  open another screen: screenName = "TelaAdicionarObs"
```

### 6.7 Botão Voltar
```
when Button_Voltar.Click do
  close screen
```

### 6.8 Quando voltar da tela de adicionar (recarregar dados)
```
when TelaAluno.OtherScreenClosed do
  // Recarregar observações
  set FirebaseDB2.ProjectBucket to → join("/observacoes/", global alunoNumero)
  call FirebaseDB2.GetValue
    tag = "lista"
    valueIfTagNotThere = "vazio"
```

### 6.9 Deletar observação (long press)
```
when ListView_Observacoes.AfterPicking do
  call Notifier2.ShowChooseDialog
    message = "Deseja excluir esta observação?"
    title = "Confirmar exclusão"
    button1Text = "Sim, excluir"
    button2Text = "Cancelar"
    cancelable = true

when Notifier2.AfterChoosing do
  if choice = "Sim, excluir" then
    local indice = ListView_Observacoes.SelectionIndex
    
    // Aplicar o filtro para encontrar o índice real
    // Se filtro = "todas", o índice é direto
    if global filtroAtual = "todas" then
      remove list item(global observacoes, index indice)
    else
      // Precisamos encontrar o item real na lista
      local contFiltrado = 0
      local indiceReal = 0
      for each i from 1 to length of list(global observacoes) do
        local obs = select list item(global observacoes, i)
        local tipo = select list item(obs, index 1)
        if global filtroAtual = "todas" OR tipo = global filtroAtual then
          set contFiltrado to contFiltrado + 1
          if contFiltrado = indice then
            set indiceReal to i
          end if
        end if
      end for
      if indiceReal > 0 then
        remove list item(global observacoes, index indiceReal)
      end if
    end if
    
    // Salvar no Firebase
    call FirebaseDB2.StoreValue
      tag = "lista"
      valueToStore = global observacoes
    
    call AtualizarObservacoes
    call Notifier2.ShowAlert(notice = "Observação excluída!")
  end if
```

---

## 7. TELA 3 — ADICIONAR OBSERVAÇÃO (TelaAdicionarObs)

### 7.1 Criar nova tela
1. **Add Screen...**
2. Nome: `TelaAdicionarObs`

### 7.2 Propriedades
| Propriedade | Valor |
|-------------|-------|
| Title | Nova Observação |
| BackgroundColor | #F5F5F5 |
| ScreenOrientation | Portrait |

### 7.3 Componentes:

#### A) VerticalArrangement_Header
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| BackgroundColor | #1B5E20 |
| Padding | 16 |
| AlignHorizontal | Center |

Dentro:

##### → Label_InfoAluno
| Propriedade | Valor |
|-------------|-------|
| FontSize | 18 |
| TextColor | Branco |
| FontBold | ✅ |
| TextAlignment | Center |
| Width | Fill parent |
| Text | Aluno |

#### B) Label_TipoTitulo
| Propriedade | Valor |
|-------------|-------|
| Text | Tipo da observação: |
| FontSize | 16 |
| FontBold | ✅ |
| Padding | 8 |

#### C) HorizontalArrangement_Tipo
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| AlignHorizontal | Center |
| Padding | 8 |

Dentro:

##### → Button_TipoPositiva
| Propriedade | Valor |
|-------------|-------|
| Text | ✅ Positiva |
| BackgroundColor | #2E7D32 |
| TextColor | Branco |
| FontSize | 16 |
| FontBold | ✅ |
| Width | 45% |
| Shape | rounded |

##### → Button_TipoNegativa
| Propriedade | Valor |
|-------------|-------|
| Text | ⚠️ Negativa |
| BackgroundColor | #E0E0E0 |
| TextColor | #666666 |
| FontSize | 16 |
| Width | 45% |
| Shape | rounded |

#### D) Label_DescTitulo
| Propriedade | Valor |
|-------------|-------|
| Text | Descrição: |
| FontSize | 16 |
| FontBold | ✅ |
| Padding | 8 |

#### E) TextBox_Descricao
| Propriedade | Valor |
|-------------|-------|
| Width | Fill parent |
| Hint | Descreva a observação... |
| FontSize | 16 |
| MultiLine | ✅ |
| Height | 150 pixels |

#### F) Button_Salvar
| Propriedade | Valor |
|-------------|-------|
| Text | 💾 Salvar Observação |
| BackgroundColor | #1B5E20 |
| TextColor | Branco |
| FontSize | 18 |
| FontBold | ✅ |
| Width | Fill parent |
| Shape | rounded |
| Padding | 16 |

#### G) Button_Cancelar
| Propriedade | Valor |
|-------------|-------|
| Text | Cancelar |
| BackgroundColor | #BDBDBD |
| TextColor | #333333 |
| FontSize | 16 |
| Width | Fill parent |
| Shape | rounded |

#### H) Componentes NÃO VISÍVEIS:
- **FirebaseDB3** (FirebaseDB) — mesma URL e token
- **TinyDB3** (TinyDB)
- **Notifier3** (Notifier)
- **Clock2** (Clock) — para pegar data/hora atual

---

## 8. BLOCOS DA TELA 3

### 8.1 Variáveis globais
```
initialize global tipoSelecionado to → "positiva"
initialize global alunoNumero to → ""
initialize global alunoNome to → ""
initialize global observacoesExistentes to → create empty list
```

### 8.2 Quando a tela inicializar
```
when TelaAdicionarObs.Initialize do
  set global alunoNumero to → call TinyDB3.GetValue(tag="alunoNumero", valueIfTagNotThere="")
  set global alunoNome to → call TinyDB3.GetValue(tag="alunoNome", valueIfTagNotThere="")
  
  set Label_InfoAluno.Text to → global alunoNome
  
  // Carregar observações existentes do Firebase
  set FirebaseDB3.ProjectBucket to → join("/observacoes/", global alunoNumero)
  call FirebaseDB3.GetValue
    tag = "lista"
    valueIfTagNotThere = "vazio"
```

### 8.3 Quando Firebase retornar valor
```
when FirebaseDB3.GotValue do
  if value ≠ "vazio" then
    set global observacoesExistentes to → value
  else
    set global observacoesExistentes to → create empty list
  end if
```

### 8.4 Botões de tipo
```
when Button_TipoPositiva.Click do
  set global tipoSelecionado to "positiva"
  set Button_TipoPositiva.BackgroundColor to #2E7D32
  set Button_TipoPositiva.TextColor to Branco
  set Button_TipoNegativa.BackgroundColor to #E0E0E0
  set Button_TipoNegativa.TextColor to #666666

when Button_TipoNegativa.Click do
  set global tipoSelecionado to "negativa"
  set Button_TipoNegativa.BackgroundColor to #C62828
  set Button_TipoNegativa.TextColor to Branco
  set Button_TipoPositiva.BackgroundColor to #E0E0E0
  set Button_TipoPositiva.TextColor to #666666
```

### 8.5 Botão Salvar
```
when Button_Salvar.Click do
  if TextBox_Descricao.Text = "" then
    call Notifier3.ShowAlert(notice = "Digite uma descrição!")
  else
    // Criar a observação como lista [tipo, texto, data]
    local dataHora = join(
      Clock2.FormatDate(Clock2.Now, "dd/MM/yyyy"),
      " ",
      Clock2.FormatDate(Clock2.Now, "HH:mm")
    )
    
    local novaObs = create a list(
      global tipoSelecionado,
      TextBox_Descricao.Text,
      dataHora
    )
    
    // Adicionar à lista existente
    add items to list(global observacoesExistentes, novaObs)
    
    // Salvar no Firebase
    set FirebaseDB3.ProjectBucket to → join("/observacoes/", global alunoNumero)
    call FirebaseDB3.StoreValue
      tag = "lista"
      valueToStore = global observacoesExistentes
    
    call Notifier3.ShowAlert(notice = "Observação salva com sucesso! ✅")
    
    // Fechar tela após 1 segundo
    close screen
  end if
```

### 8.6 Botão Cancelar
```
when Button_Cancelar.Click do
  close screen
```

---

## 9. CARREGAR ALUNOS NO FIREBASE

### Método 1: Importar JSON no Firebase Console

Crie um arquivo `alunos.json` com este conteúdo e importe no Firebase Realtime Database:

```json
{
  "alunos": {
    "lista": [
      ["MELO", "1001"],
      ["MORAES", "1002"],
      ["DANILO SILVA", "1003"],
      ["DIAS", "1004"],
      ["AMADEU", "1005"],
      ["MUNIZ", "1006"],
      ["LEONARDO", "1007"],
      ["CÂMARA", "1008"],
      ["SOUSA", "1009"],
      ["GUSTAVO SILVA", "1010"],
      ["LOPO", "1011"],
      ["JERONIMO", "1012"],
      ["NETO", "1013"],
      ["LUIS GUSTAVO", "1014"],
      ["ALEXANDRE SILVA", "1015"],
      ["BERNARDO GUIDICE", "1016"],
      ["DAMACENO", "1017"],
      ["SERAFIM", "1018"],
      ["MATOS", "1019"],
      ["JUCÁ", "1020"],
      ["VICTOR BATISTA", "1021"],
      ["ISIS IBIAPINA", "1022"],
      ["CLARA MESSIAS", "1023"],
      ["PORPORATTO", "1024"],
      ["CRISTOVAM", "1025"],
      ["MEDEIROS", "1026"],
      ["WEBSTER", "1027"],
      ["JOÃO CARVALHO", "1028"],
      ["DAVI", "1029"],
      ["LAURA IAGDA", "1030"],
      ["ROSEWELTE", "1031"],
      ["GUIMARÃES", "1032"],
      ["FALCÃO", "1033"],
      ["MAGNO", "1034"],
      ["BOTELHO", "1035"],
      ["WITOR SOUZA", "1036"],
      ["CAIO", "1037"],
      ["IGLEZIO", "1038"],
      ["LARCHER", "1039"],
      ["FREITAS", "1040"],
      ["ADRIANE REIS", "1041"],
      ["KAIO RYUUSEKI", "1042"],
      ["ALBUQUERQUE", "1043"],
      ["VICTOR SANTOS", "1044"],
      ["RANYA GARCIA", "1045"],
      ["COSTA", "1046"],
      ["PAULO TARSO", "1047"],
      ["GUILHERME LUCENA", "1048"],
      ["LIKOSKI", "1049"],
      ["BRAGA", "1050"],
      ["MOREL", "1051"],
      ["SAMUEL", "1052"],
      ["EMANUEL RIBEIRO", "1053"],
      ["NISHIDA", "1054"],
      ["CHAVES", "1055"],
      ["EMYLLI ACIOLI", "1056"],
      ["MAIRA SANCHES", "1057"],
      ["DAVI CAVALCANTE", "1058"],
      ["VIEIRA", "1059"],
      ["SAMPAIO JUNIOR", "1060"],
      ["HEITOR", "1061"],
      ["VIRGÍNIA FREIRE", "1062"],
      ["GUILHERME TOLEDO", "1063"],
      ["SILVA MOREIRA", "1064"],
      ["CLARA SARAIVA", "1065"],
      ["DINIZ", "1066"],
      ["ELLOA MONTENEGRO", "1067"],
      ["ABNER", "1068"],
      ["DAVI SOUSA", "1069"],
      ["BESSA", "1070"],
      ["PEDRO MENDONÇA", "1071"],
      ["YURI DIAS", "1072"],
      ["LOPES BRAGA", "1073"],
      ["ELIAS", "1074"],
      ["PORTO", "1075"],
      ["NOVAES", "1076"],
      ["MACHADO", "1077"],
      ["ROGER ARERO", "1078"],
      ["ARTHUR CARVALHO", "1079"],
      ["CARLOS ROBERTO", "1080"],
      ["FERNANDES", "1081"],
      ["GALARDO", "1082"],
      ["LUIZA FAZOLO", "1083"],
      ["TOSTES", "1084"],
      ["ISAAC FONSECA", "1085"],
      ["WLISSES", "1086"],
      ["ANDRADE", "1087"],
      ["EDUARDO CARVALHO", "1088"],
      ["MARQUES", "1089"],
      ["BORGES", "1090"],
      ["LARA AVILA", "1091"],
      ["LUCAS", "1092"],
      ["LINDOLFO", "1093"],
      ["KAUANE LEAL", "1094"],
      ["WEKERLIN", "1095"],
      ["JOÃO ALVES", "1096"],
      ["ESTRELA", "1097"],
      ["MARCELO", "1098"],
      ["NÍCOLAS", "1099"],
      ["PABLO", "1100"],
      ["SANT'ANNA", "1101"],
      ["NATÃ", "1102"],
      ["SOARES", "1103"],
      ["EDUARDA VIEIRA", "1104"],
      ["LASSECK", "1105"],
      ["CORREA", "1106"],
      ["FABRÍCIO COSTA", "1107"],
      ["DELGADO", "1108"],
      ["PEDRO NOGUEIRA", "1109"],
      ["OKIDA", "1110"],
      ["MIRELLY ALMEIDA", "1111"],
      ["GABRIEL LINS", "1112"],
      ["OTÁVIO SOUZA", "1113"],
      ["RODRIGO ARAÚJO", "1114"],
      ["KOPKE", "1115"],
      ["OLIVEIRA JÚNIOR", "1116"],
      ["PIERRE", "1117"],
      ["DAVI TAVARES", "1118"],
      ["RUTH FARIAS", "1119"],
      ["GUEDES", "1120"],
      ["OTACÍLIO", "1121"],
      ["KEVYN DIAS", "1122"],
      ["MÁRCIO", "1123"],
      ["ESTHER SILVA", "1124"],
      ["EVANGELISTA", "1125"],
      ["MOURA", "1126"],
      ["LETÍCIA COSTA", "1127"],
      ["CAUÃ COSTA", "1128"],
      ["RAFAEL ARAÚJO", "1129"],
      ["GOUVEIA", "1130"],
      ["JAUBERT SANTOS", "1131"],
      ["MOUTINHO", "1132"],
      ["JOÃO FERREIRA", "1133"],
      ["LUIZA NASCIMENTO", "1134"],
      ["CAMILA BARACHO", "1135"],
      ["JUAN", "1136"],
      ["VASTI", "1137"],
      ["DANIEL SOARES", "1138"],
      ["ANTONIO", "1139"],
      ["GILBER", "1140"],
      ["GAVA", "1141"],
      ["VINÍCIUS DE MORAES", "1142"],
      ["ALLANA SILVA", "1143"],
      ["LUCAS CARVALHO", "1144"],
      ["KAIKY IZAQUE", "1145"],
      ["TAINA SAMPAIO", "1146"],
      ["ALFREDO", "1147"],
      ["SOPHIA SILVA", "1148"],
      ["VITOR ANDREI", "1149"],
      ["DAVID MOURA", "1150"],
      ["GIOVANNA BACELLAR", "1151"],
      ["MONTENEGRO", "1152"],
      ["NASCIMENTO", "1153"],
      ["MAYMONE", "1154"],
      ["GIOVANNA APOLARO", "1155"],
      ["GIBRAN", "1156"],
      ["ANDREW", "1157"],
      ["MARIA CORDEIRO", "1158"],
      ["HENRIQUE VALÉRIO", "1159"],
      ["JANSEN", "1160"],
      ["FORTE", "1161"],
      ["FELIPE PORTO", "1162"],
      ["PIQUET", "1163"],
      ["GUSTAVO SOUSA", "1164"],
      ["ROSA", "1165"],
      ["SADRAC CUTRIM", "1166"],
      ["JÚNIOR", "1167"],
      ["HERIKSON", "1168"],
      ["CRAVID", "1169"],
      ["QUARESMA", "1170"],
      ["BODRICH", "1171"],
      ["PRINCE", "1172"]
    ]
  }
}
```

### Método 2: Criar Tela de Carga Inicial (mais fácil)

Se preferir, crie uma **Tela auxiliar** chamada `TelaCarregar` com um único botão.

Blocos:
```
when Button_Carregar.Click do
  set FirebaseDB.ProjectBucket to "/alunos"
  
  local lista = create empty list
  
  // Adicionar todos os alunos
  add items to list(lista, create a list("MELO", "1001"))
  add items to list(lista, create a list("MORAES", "1002"))
  add items to list(lista, create a list("DANILO SILVA", "1003"))
  // ... (repetir para todos os 172 alunos)
  add items to list(lista, create a list("PRINCE", "1172"))
  
  call FirebaseDB.StoreValue
    tag = "lista"
    valueToStore = lista
  
  call Notifier.ShowAlert(notice = "172 alunos carregados com sucesso!")
```

> 💡 **DICA**: O método 1 (importar JSON) é MUITO mais rápido e fácil!

---

## 10. GERAR APK

### 10.1 Testar no celular (antes de gerar APK)
1. No App Inventor, vá em **Connect → AI Companion**
2. Instale o app **MIT AI2 Companion** no seu celular (Google Play Store)
3. Escaneie o QR Code ou digite o código

### 10.2 Gerar APK
1. No App Inventor, vá em **Build → Android App (.apk)**
2. Aguarde a compilação (pode levar 1-3 minutos)
3. Quando terminar:
   - **Opção A**: Escaneie o QR Code para baixar direto no celular
   - **Opção B**: Clique no link para baixar no computador
4. No celular, abra o arquivo `.apk` para instalar
5. Se pedir permissão de "fontes desconhecidas", autorize

### 10.3 Gerar AAB (para Google Play Store)
1. **Build → Android App Bundle (.aab)**
2. Este formato é necessário para publicar na Play Store

---

## 11. SOLUÇÃO DE PROBLEMAS

### "Firebase não conecta"
- Verifique se a URL termina com `/`
- Verifique se o token está correto
- Confirme que o banco está em "modo de teste"

### "Lista de alunos vazia"
- Verifique se importou o JSON corretamente
- O ProjectBucket deve ser `/alunos` na Screen1

### "Observações não salvam"
- O ProjectBucket deve ser `/observacoes/NUMERO_DO_ALUNO`
- Verifique a conexão com internet

### "App lento com muitos alunos"
- Normal em listas grandes no App Inventor
- A busca ajuda a filtrar rapidamente

### "Erro ao importar JSON"
- Certifique-se que o JSON está válido
- Use https://jsonlint.com para validar

---

## 📐 ESTRUTURA DO FIREBASE (como ficam os dados)

```
avaliacao-alunos/
├── alunos/
│   └── lista: [
│       ["MELO", "1001"],
│       ["MORAES", "1002"],
│       ...
│   ]
└── observacoes/
    ├── 1001/
    │   └── lista: [
    │       ["positiva", "Bom desempenho na prova", "15/01/2025 14:30"],
    │       ["negativa", "Faltou ao treinamento", "16/01/2025 08:00"]
    │   ]
    ├── 1002/
    │   └── lista: [...]
    └── ...
```

---

## 🎨 RESUMO DAS TELAS

| Tela | Função |
|------|--------|
| **Screen1** | Lista de alunos com busca |
| **TelaAluno** | Ficha do aluno com observações, filtros, estatísticas |
| **TelaAdicionarObs** | Formulário para adicionar nova observação |
| **TelaCarregar** *(opcional)* | Botão para carregar os 172 alunos no Firebase |

---

## ✅ CHECKLIST FINAL

- [ ] Projeto Firebase criado
- [ ] Realtime Database ativado (modo teste)
- [ ] URL e Token copiados
- [ ] JSON dos alunos importado
- [ ] Screen1 criada com todos os componentes
- [ ] TelaAluno criada com todos os componentes
- [ ] TelaAdicionarObs criada com todos os componentes
- [ ] Todos os blocos montados
- [ ] Testado via AI Companion
- [ ] APK gerado e instalado

---

**Feito com 💚 para o sistema de avaliação de alunos**
