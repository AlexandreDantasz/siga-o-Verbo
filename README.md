# Siga o Verbo

> *"Lâmpada para os meus pés é tua palavra e luz para o meu caminho." — Salmos 119:105*

Um blog estático ultraleve e minimalista criado para compartilhar reflexões, testemunhos e a caminhada diária com Deus através do Verbo vivo. 

Construído sob uma arquitetura limpa, sem frameworks JavaScript pesados, gerando apenas **HTML/CSS estático puro** servido simultaneamente via **GitHub Pages** e em uma **VPS Ubuntu** com **Caddy Server** e certificado SSL que se renova 100% de forma automática.

---

## 📐 Fundamentos de Design e Usabilidade

O design do **Siga o Verbo** foi desenhado seguindo com rigor:

1. **Apple Human Interface Guidelines (HIG):**
   * **Tipografia limpa e hierarquia clara:** Pilha de fontes do sistema Apple (`-apple-system`, `SF Pro`, e `Charter` / `New York` para o corpo editorial dos artigos).
   * **Branco puro e respiração:** Layout arejado com margens generosas (grid de 8pt), sem distrações ou anúncios.
   * **Vibrancy & Blur:** Cabeçalho com transparência fluida e `backdrop-filter: blur(20px)`.
2. **Heurísticas de Nielsen:**
   * **Visibilidade do status do sistema:** Metadados claros em cada artigo (data, tempo estimado de leitura, autor e indicador do modo ativo).
   * **Controle e liberdade do usuário:** Navegação simples de retorno para artigos e página inicial.
   * **Reconhecimento em vez de lembrança:** Ícones intuitivos e títulos claros.
   * **Design minimalista:** Conteúdo em primeiro lugar (deferência ao texto).
   * **Recuperação de erros amigável:** Página 404 acolhedora com versículo bíblico e atalho para a home.
3. **Lei de Fitts:**
   * Todos os alvos de clique/toque (botões, seletores de tema, links de leitura) possuem área mínima de **44px × 44px**, garantindo conforto e precisão imediata em smartphones e desktops.
4. **Modos de Visualização:**
   * **Modo Claro (Apple White):** Fundo branco puro e cinzas refinados para leitura diurna de alta nitidez.
   * **Modo Papel (Warm Book):** Tom sépia acolhedor inspirado em páginas de livros físicos para descanso ocular.
   * **Modo Noturno (Apple Dark):** Preto profundo para leitura noturna confortável.
   * *Persistência automática em `localStorage` e atalho rápido de teclado (tecla `T`).*

---

## 📁 Estrutura do Projeto

```text
siga-o-verbo/
├── .github/
│   └── workflows/
│       └── deploy.yml          # CI/CD: build e deploy simultâneo (Pages + VPS)
├── archetypes/
│   └── posts.md                # Template para novos artigos
├── content/
│   ├── posts/                  # Artigos em Markdown
│   │   └── o-verbo-se-fez-carne.md
│   └── sobre.md                # Página Sobre
├── layouts/                    # Layouts HTML semânticos puros (sem dependências)
│   ├── _default/
│   │   ├── baseof.html
│   │   ├── list.html
│   │   └── single.html
│   ├── 404.html
│   └── index.html
├── static/                     # Arquivos estáticos servidos diretamente
│   ├── css/
│   │   └── style.css           # Design System em CSS puro
│   ├── js/
│   │   └── theme.js            # Controle dos 3 modos de visualização
│   └── images/
│       └── verbo-luz.svg       # Ilustrações e imagens
├── infra/
│   ├── Caddyfile               # Configuração do Caddy para VPS com SSL automático
│   └── setup-vps.sh            # Script de instalação automatizada no Ubuntu
├── hugo.toml                   # Configuração principal do blog
└── README.md
```

---

## 🌿 Fluxo Git & Branches

* **`develop`**: Branch padrão de trabalho. Utilize para rascunhar novos textos, testar imagens e layouts.
* **`main`**: Branch de produção estável. Ao mesclar alterações na `main`, a pipeline de CI/CD é acionada instantaneamente.

```bash
# Para escrever um novo artigo no develop:
git checkout develop

# Criar e editar seu post em content/posts/nome-do-post.md
git add .
git commit -m "feat: novo artigo sobre a oração"
git push origin develop

# Quando estiver pronto para publicar em produção:
git checkout main
git merge develop
git push origin main
```

---

## ✍️ Como Escrever Novos Posts

Crie um arquivo `.md` dentro de `content/posts/` (ex: `content/posts/meu-novo-post.md`):

```markdown
---
title: "Título do Seu Artigo"
date: 2026-11-24T10:00:00-03:00
draft: false
description: "Uma frase concisa que resume a reflexão."
author: "Alexandre"
image: "images/nome-da-sua-foto.jpg"
imageAlt: "Descrição da imagem para acessibilidade"
imageCaption: "Legenda opcional para a imagem"
tags: ["Oração", "Testemunho"]
---

Escreva seu texto normalmente em **Markdown**.

### Subtítulo

> "Versículo ou citação em destaque." — Referência

Parágrafo com reflexões e ensinamentos...
```

Para adicionar fotos e imagens, basta colocá-las em `static/images/` e referenciá-las como `images/nome-da-sua-foto.jpg`.

---

## 🚀 CI/CD & Deploy Duplo (GitHub Pages + VPS)

O workflow em [deploy.yml](file:///.github/workflows/deploy.yml) é acionado no push para a branch `main`:

1. **GitHub Pages (Ativo Imediatamente):**
   * Vá em **Settings** > **Pages** no seu repositório GitHub.
   * Em **Source**, selecione **GitHub Actions**.
   * O site estará acessível no seu endereço `https://<seu-usuario>.github.io/siga-o-verbo/`.

2. **VPS Ubuntu com Caddy (Pronto para quando ativar a VPS):**
   * No GitHub, acesse **Settings** > **Secrets and variables** > **Actions** e cadastre:
     * `VPS_HOST`: IP da sua VPS Ubuntu.
     * `VPS_SSH_KEY`: Chave privada SSH para sincronização segura.
     * `VPS_USER`: Usuário com acesso de escrita (ex: `deploy` ou `root`).
     * `VPS_TARGET_DIR`: Caminho na VPS (padrão `/var/www/siga-o-verbo`).
   * A pipeline executa o `rsync` sobre SSH e atualiza a VPS em segundos.

---

## 🌐 Configuração da VPS (Ubuntu + Caddy + SSL Automático)

Quando contratar a VPS Ubuntu:

1. **Instale o Caddy com o script:**
   ```bash
   bash infra/setup-vps.sh
   ```
2. **Copie o Caddyfile para o servidor:**
   ```bash
   sudo cp infra/Caddyfile /etc/caddy/Caddyfile
   ```
3. **Edite o domínio:**
   Substitua `seu-dominio.com.br` pelo domínio que você registrou.
4. **Recarregue o Caddy:**
   ```bash
   sudo systemctl reload caddy
   ```

> [!NOTE]
> O Caddy se conecta diretamente à Let's Encrypt / ZeroSSL, solicita o certificado SSL na primeira requisição e cuida de toda a renovação em background sem que você precise executar scripts adicionais.
