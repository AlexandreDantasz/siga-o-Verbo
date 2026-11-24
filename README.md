# Siga o Verbo

> *"Lâmpada para os meus pés é tua palavra e luz para o meu caminho." — Salmos 119:105*

Um blog estático ultraleve e contemplativo, desenhado com estética predominantemente branca e minimalista, para registrar e compartilhar a caminhada de fé diária com Deus, testemunhos e reflexões bíblicas.

Construído sob uma arquitetura pura e sem dependências pesadas, gerando apenas **HTML5 semântico, CSS puro e imagens estáticas** servidas simultaneamente pelo **GitHub Pages** e em uma **VPS Ubuntu** com **Caddy Server** e certificado SSL 100% automático.

---

## 📑 Índice da Documentação

1. [Fundamentos de Design & UX (Nielsen, Apple HIG, Fitts)](#-fundamentos-de-design--ux)
2. [Estrutura da Home (Baseada no Wireframe)](#-estrutura-da-home-inspirada-no-protótipo)
3. [Pesquisa Instantânea Reativa](#-pesquisa-instantânea-reativa)
4. [CLI Interativa Siga o Verbo (`verbo.ps1`)](#-cli-interativa-siga-o-verbo-verbops1)
5. [Como os Posts são Registrados e Escritos](#-como-os-posts-são-registrados-e-escritos)
6. [Fluxo Git & Estratégia de Branches](#-fluxo-git--estratégia-de-branches)
7. [Automação CI/CD (GitHub Actions)](#-automação-cicd-github-actions)
8. [Hospedagem na VPS (Ubuntu + Caddy + SSL Automático)](#-hospedagem-na-vps-ubuntu--caddy--ssl-automático)
9. [Mapa de Arquivos do Projeto](#-mapa-de-arquivos-do-projeto)

---

## 🎨 Fundamentos de Design & UX

### 1. Heurísticas de Nielsen
* **Visibilidade do Status (#1):** Metadados em cada texto (tempo estimado de leitura, data amigável, autor e tags). Na busca, indicação em tempo real de *"X reflexões encontradas"*. O botão de tema reflete o status atual e o próximo via `title` e `aria-label`.
* **Correspondência com o Mundo Real (#2):** Ícones sutis e metáforas editoriais (livro aberto, luz, sol, lua, pergaminho).
* **Controle e Liberdade do Usuário (#3):** Botão para limpar a busca, links para retornar ao feed em todos os artigos e alternância livre entre modos visuais.
* **Consistência e Padrões (#4):** Escala tipográfica uniforme, paleta em variáveis CSS e grid de espaçamento modular de 8pt.
* **Design Estético e Minimalista (#8):** Foco total no Verbo e na leitura serena, sem poluição de anúncios ou pop-ups.
* **Prevenção e Recuperação de Erros (#9):** Página [404.html](file:///C:/Users/alexa/OneDrive/Documentos/codes/siga-o-verbo/layouts/404.html) acolhedora com versículo bíblico e retorno direto à home.

### 2. Apple Human Interface Guidelines (HIG)
* **Tipografia Nativa:** Pilha nativa Apple (`-apple-system`, `SF Pro`) na interface e serifas editoriais consagradas (`Charter`, `New York`, `Georgia`) no corpo dos artigos para leitura relaxante.
* **Branco Puro & Vibrancy:** Superfícies translúcidas com `backdrop-filter: blur(20px)` na barra superior e nos selos. Paleta clara de alto contraste sem cansar a visão.
* **Largura Ótima de Leitura:** Textos limitados a 720px de largura máxima (65 a 75 caracteres por linha, padrão editorial).

### 3. Lei de Fitts
* Todos os elementos interativos (botões de abas, links de navegação, campo de busca, botão de recarregar e botão de tema) possuem dimensões mínimas de **44px × 44px**.

### 4. Modos de Visualização (3 Modos)
* **Modo Claro (Apple White):** Branco puro para alta claridade diurna.
* **Modo Papel (Warm Book):** Tom sépia suave inspirado em livros impressos (`#FAF7F2`) para descanso ocular.
* **Modo Noturno (Apple Dark):** Preto profundo para leitura noturna confortável.
* *Persistência em `localStorage`, detecção automática de `prefers-color-scheme` e atalho rápido de teclado (tecla `T`).*

---

## 🖼️ Estrutura da Home (Inspirada no Protótipo)

O layout da página inicial reflete a estética de janela de sistema contemplativa:
* **Janela com Abas e Controles:** Borda arredondada suave, abas (*Início*, *Artigos*, *Sobre*, *Recomendações*) e controles de janela.
* **Barra de Endereço & Busca:** Símbolo do Verbo à esquerda, campo de pesquisa central e botão de recarregar/limpar à direita.
* **Banner Zen com Selo Central:** Ilustração vetorial [zen-banner.svg](file:///C:/Users/alexa/OneDrive/Documentos/codes/siga-o-verbo/static/images/zen-banner.svg) com o selo translúcido `siga o verbo.`.
* **Coluna da Esquerda (Sidebar):**
  * *Palavra do Dia* (Salmos 46:10).
  * *Temas & Passagens* (Botões com marcadores `+` que filtram instantaneamente a lista de artigos).
  * *Sobre o Projeto* (Missão e visão do blog).
* **Coluna da Direita (Conteúdo Principal):**
  * *Card do Autor* com avatar, dados chave-valor (*Autor: Alexandre*, *Missão*, *Fundamento*) e links rápidos.
  * *Card de Recomendações Recentes* em scrollbox suave com leituras sugeridas.
  * *Feed de Artigos Recentes* com ícone do Verbo, títulos em caixa-alta e resumos.

---

## ⚡ Pesquisa Instantânea Reativa

O script [search.js](file:///C:/Users/alexa/OneDrive/Documentos/codes/siga-o-verbo/static/js/search.js) (< 2 KB, Vanilla JS puro) funciona em tempo real:
1. Durante o build, o Hugo gera o índice estático [index.json](file:///C:/Users/alexa/OneDrive/Documentos/codes/siga-o-verbo/layouts/_default/index.json).
2. O JavaScript filtra na memória do navegador conforme o leitor digita.
3. Clicar nas tags com marcador `+` na barra lateral preenche automaticamente o campo e filtra os posts.

---

## 💻 CLI Interativa Siga o Verbo (`verbo.ps1`)

Uma CLI em PowerShell criada para facilitar o fluxo de escrita com visual moderno inspirado no `agy`:

```powershell
# Iniciar o assistente interativo para criar novo artigo
.\verbo.ps1

# Listar todos os artigos cadastrados e seus status (DRAFT ou PUBLISHED)
.\verbo.ps1 listar

# Criar artigo direto em uma única linha de comando (One-liner)
.\verbo.ps1 novo -TituloParam "O Silêncio da Manhã" -Descricao "Iniciando o dia em oração." -Tags "Oração, Manhã"

# Ver a tela de ajuda
.\verbo.ps1 ajuda
```

---

## ✍️ Como os Posts são Registrados e Escritos

Cada artigo é um arquivo `.md` em `content/posts/` com cabeçalho (Frontmatter):

```markdown
---
title: "Título do Seu Artigo"
date: 2026-11-24T10:00:00-03:00
draft: true                               # Mude para false para publicar
description: "Uma breve descrição sobre a reflexão."
author: "Alexandre"
image: "images/zen-banner.svg"
imageAlt: "Descrição da imagem"
imageCaption: "Legenda opcional"
tags: ["Oração", "Fé"]
---

> "Versículo bíblico em destaque." — Referência

Escreva seu texto aqui livremente em Markdown...
```

---

## 🌿 Fluxo Git & Estratégia de Branches

* **`develop`**: Branch de rascunhos e desenvolvimento. Utilize para rascunhar novos textos e testar layouts.
* **`main`**: Branch de produção. O push na `main` dispara o build e o deploy automaticamente.

```bash
# Trabalhando em um novo texto no develop:
git checkout develop
.\verbo.ps1
git add .
git commit -m "feat: rascunho de novo artigo"
git push origin develop

# Publicando em produção:
git checkout main
git merge develop
git push origin main
```

---

## 🚀 Automação CI/CD (GitHub Actions)

Configurada em [.github/workflows/deploy.yml](file:///C:/Users/alexa/OneDrive/Documentos/codes/siga-o-verbo/.github/workflows/deploy.yml):

1. **GitHub Pages (Ativo e Gratuito):** No seu repositório no GitHub, acesse **Settings** > **Pages** e selecione **GitHub Actions**. O blog é publicado automaticamente.
2. **VPS Ubuntu (Automático via Rsync):** Se os segredos `VPS_HOST` e `VPS_SSH_KEY` estiverem configurados no repositório, o GitHub sincroniza os arquivos compilados diretamente na sua VPS via SSH.

---

## 🌐 Hospedagem na VPS (Ubuntu + Caddy + SSL Automático)

Quando você contratar sua VPS Ubuntu:

1. **Instale o Caddy com o script:**
   ```bash
   bash infra/setup-vps.sh
   ```
2. **Copie o [Caddyfile](file:///C:/Users/alexa/OneDrive/Documentos/codes/siga-o-verbo/infra/Caddyfile):**
   ```bash
   sudo cp infra/Caddyfile /etc/caddy/Caddyfile
   ```
3. **Edite o domínio e recarregue o servidor:**
   ```bash
   sudo nano /etc/caddy/Caddyfile
   sudo systemctl reload caddy
   ```

> [!NOTE]
> O **Caddy** obtém e renova o certificado SSL (Let's Encrypt / ZeroSSL) automaticamente no próprio processo. Não é necessário Certbot ou agendamentos cron.

---

## 📁 Mapa de Arquivos do Projeto

```text
siga-o-verbo/
├── .github/
│   └── workflows/
│       └── deploy.yml          # CI/CD: build e deploy duplo (Pages + VPS)
├── archetypes/
│   └── posts.md                # Template para novos artigos
├── content/
│   ├── posts/                  # Artigos em Markdown
│   │   ├── o-verbo-se-fez-carne.md
│   │   ├── a-quietude-e-o-lugar-secreto.md
│   │   └── o-descanso-do-coracao.md
│   └── sobre.md                # Página Sobre
├── layouts/                    # Layouts HTML5 puros
│   ├── _default/
│   │   ├── baseof.html         # Base com cabeçalho e alternador de modos
│   │   ├── list.html           # Listagem de artigos
│   │   ├── single.html         # Visualização editorial do artigo
│   │   └── index.json          # Gerador do índice da busca
│   ├── 404.html                # Página 404 acolhedora
│   └── index.html              # Home page window/cards do wireframe
├── static/                     # Assets estáticos servidos diretamente
│   ├── css/
│   │   └── style.css           # Design System (variáveis CSS e tipografia)
│   ├── js/
│   │   ├── theme.js            # Alternador de 3 modos de visualização (tecla T)
│   │   └── search.js           # Mecanismo de busca instantânea reativo
│   └── images/
│       ├── zen-banner.svg      # Ilustração serena do hero
│       └── verbo-luz.svg       # Ilustração do Verbo
├── infra/
│   ├── Caddyfile               # Configuração do Caddy com SSL automático
│   └── setup-vps.sh            # Script de instalação na VPS Ubuntu
├── hugo.toml                   # Configurações do blog
├── verbo.ps1                   # CLI interativa para criar posts e listar status
└── README.md                   # Documentação completa do projeto
```
