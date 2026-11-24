<#
.SYNOPSIS
    Siga o Verbo CLI - Gerenciador interativo e elegante de reflexões e artigos.
.DESCRIPTION
    Permite criar novos posts em draft, listar publicações e gerenciar o blog com visual inspirado no agy.
.EXAMPLE
    .\verbo.ps1
    .\verbo.ps1 novo
    .\verbo.ps1 listar
#>

[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [ValidateSet("novo", "listar", "ajuda", "")]
    [string]$Comando = "novo",

    [Parameter(Position = 1)]
    [string]$TituloParam = "",

    [Parameter()]
    [string]$Descricao = "",

    [Parameter()]
    [string]$Tags = "",

    [Parameter()]
    [switch]$ProntoParaPublicar
)

# Habilita codificação UTF-8 para exibição correta de caracteres
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$DIVIDER = "─" * 62
$ESC = [char]27
$C_RESET   = "$ESC[0m"
$C_BOLD    = "$ESC[1m"
$C_DIM     = "$ESC[2m"
$C_ITALIC  = "$ESC[3m"
$C_CYAN    = "$ESC[38;2;0;113;227m"     # Apple Accent Blue
$C_SOFTCYAN= "$ESC[38;2;64;164;255m"   # Soft Blue
$C_GREEN   = "$ESC[38;2;52;199;89m"     # Apple Green
$C_YELLOW  = "$ESC[38;2;255;159;10m"   # Warm Gold
$C_GRAY    = "$ESC[38;2;142;142;147m"  # Neutral Gray
$C_WHITE   = "$ESC[38;2;245;245;247m"  # Clean White
$C_MUTED   = "$ESC[38;2;99;99;102m"    # Deep Muted Gray

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "  ${C_CYAN}${C_BOLD}┌──────────────────────────────────────────────────────────────┐${C_RESET}"
    Write-Host "  ${C_CYAN}${C_BOLD}│${C_RESET}    ${C_WHITE}${C_BOLD}✦  S I G A   O   V E R B O${C_RESET}   ${C_MUTED}${C_ITALIC}• vida e reflexão em Deus${C_RESET}    ${C_CYAN}${C_BOLD}│${C_RESET}"
    Write-Host "  ${C_CYAN}${C_BOLD}└──────────────────────────────────────────────────────────────┘${C_RESET}"
    Write-Host "  ${C_MUTED}${C_ITALIC}""Tua palavra é lâmpada para os meus pés e luz para o meu caminho.""${C_RESET}"
    Write-Host ""
}

function ConvertTo-Slug {
    param ([string]$Texto)
    $normalized = $Texto.Normalize([Text.NormalizationForm]::FormD)
    $clean = ($normalized -replace '\p{M}', '').ToLower()
    $clean = $clean -replace '[^a-z0-9\s-]', ''
    $clean = $clean -replace '\s+', '-'
    $clean = $clean -replace '-+', '-'
    return $clean.Trim('-')
}

function New-VerboPost {
    param (
        [string]$TituloPreenchido,
        [string]$DescricaoPreenchida,
        [string]$TagsPreenchidas,
        [switch]$PublicarDireto
    )

    Show-Banner

    Write-Host "  ${C_SOFTCYAN}${C_BOLD}[+] Criar Nova Reflexão${C_RESET} ${C_MUTED}(Draft / Publicação)${C_RESET}"
    Write-Host "  ${C_MUTED}$DIVIDER${C_RESET}"
    Write-Host ""

    # 1. Título
    $titulo = $TituloPreenchido
    while ([string]::IsNullOrWhiteSpace($titulo)) {
        Write-Host "  ${C_WHITE}${C_BOLD}Título da Reflexão:${C_RESET}"
        Write-Host "  ${C_CYAN}> ${C_RESET}" -NoNewline
        $titulo = Read-Host
        if ([string]::IsNullOrWhiteSpace($titulo)) {
            Write-Host "  ${C_YELLOW}! Por favor, informe um título inspirador.${C_RESET}"
        }
    }

    # 2. Slug
    $defaultSlug = ConvertTo-Slug $titulo
    if ([string]::IsNullOrWhiteSpace($TituloPreenchido)) {
        Write-Host ""
        Write-Host "  ${C_WHITE}${C_BOLD}Identificador do arquivo (slug):${C_RESET} ${C_MUTED}(Enter para aceitar)${C_RESET}"
        Write-Host "  ${C_MUTED}Sugestão: $defaultSlug${C_RESET}"
        Write-Host "  ${C_CYAN}> ${C_RESET}" -NoNewline
        $inputSlug = Read-Host
        $slug = if ([string]::IsNullOrWhiteSpace($inputSlug)) { $defaultSlug } else { ConvertTo-Slug $inputSlug }
    } else {
        $slug = $defaultSlug
    }

    # 3. Descrição / Resumo
    $descricao = $DescricaoPreenchida
    if ([string]::IsNullOrWhiteSpace($descricao)) {
        Write-Host ""
        Write-Host "  ${C_WHITE}${C_BOLD}Resumo conciso:${C_RESET} ${C_MUTED}(exibido na busca e na página inicial)${C_RESET}"
        Write-Host "  ${C_CYAN}> ${C_RESET}" -NoNewline
        $descricao = Read-Host
        if ([string]::IsNullOrWhiteSpace($descricao)) {
            $descricao = "Reflexão sobre como cultivar uma caminhada diária e autêntica com Deus."
        }
    }

    # 4. Tags / Temas
    $tagsInput = $TagsPreenchidas
    if ([string]::IsNullOrWhiteSpace($tagsInput)) {
        Write-Host ""
        Write-Host "  ${C_WHITE}${C_BOLD}Tópicos / Tags:${C_RESET} ${C_MUTED}(separados por vírgula. Ex: Oração, Fé, Quietude)${C_RESET}"
        Write-Host "  ${C_CYAN}> ${C_RESET}" -NoNewline
        $tagsInput = Read-Host
    }
    if ([string]::IsNullOrWhiteSpace($tagsInput)) {
        $tagsList = @("Reflexão", "Fé")
    } else {
        $tagsList = ($tagsInput -split ',') | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    }
    $tagsFormatted = ($tagsList | ForEach-Object { """$_""" }) -join ", "

    # 5. Modo de Rascunho (Draft)
    if ($PublicarDireto) {
        $isDraft = "false"
    } elseif ([Console]::IsInputRedirected) {
        $isDraft = "true"
    } else {
        Write-Host ""
        Write-Host "  ${C_WHITE}${C_BOLD}Status inicial:${C_RESET}"
        Write-Host "    ${C_BOLD}[1]${C_RESET} ${C_YELLOW}Rascunho (draft: true)${C_RESET}  ${C_MUTED}- Salvo localmente para você lapidar${C_RESET}"
        Write-Host "    ${C_BOLD}[2]${C_RESET} ${C_GREEN}Pronto para publicar (draft: false)${C_RESET}"
        Write-Host "  ${C_CYAN}> Escolha [1 ou 2, padrão 1]: ${C_RESET}" -NoNewline
        $statusChoice = Read-Host
        $isDraft = if ($statusChoice -eq "2") { "false" } else { "true" }
    }

    # 6. Data ISO 8601
    $dataAtual = (Get-Date).ToString("yyyy-MM-ddTHH:mm:sszzz")

    # Caminho de Destino
    $postsDir = Join-Path $PSScriptRoot "content\posts"
    if (-not (Test-Path $postsDir)) {
        New-Item -ItemType Directory -Path $postsDir -Force | Out-Null
    }
    $arquivoDestino = Join-Path $postsDir "$slug.md"

    if (Test-Path $arquivoDestino) {
        Write-Host ""
        Write-Host "  ${C_YELLOW}! O arquivo '$slug.md' já existe em content/posts/.${C_RESET}"
        Write-Host "  ${C_YELLOW}  Deseja sobrescrever? (s/N): ${C_RESET}" -NoNewline
        $sobrescrever = Read-Host
        if ($sobrescrever -ne "s" -and $sobrescrever -ne "S") {
            Write-Host "  ${C_MUTED}Operação cancelada.${C_RESET}"
            return
        }
    }

    # Template do Post com boas práticas editoriais
    $conteudoPost = @"
---
title: "$titulo"
date: $dataAtual
draft: $isDraft
description: "$descricao"
author: "Alexandre"
image: "images/zen-banner.svg"
imageAlt: "Banner sereno para $titulo"
imageCaption: "Aquietai-vos e sabei que Eu sou Deus."
tags: [$tagsFormatted]
---

> "Escreva aqui um versículo-chave ou uma citação que serviu de inspiração para esta reflexão."
> <cite>— Livro 0:0</cite>

Comece aqui a sua reflexão com tranquilidade e clareza...

---

## 1. O que o Senhor nos ensina hoje?

Compartilhe como essa mensagem se aplica à sua vida prática e aos desafios cotidianos:

- **Primeiro ponto:** Reflexão sobre a oração e a escuta.
- **Segundo ponto:** A prática da fé em tempos de incerteza.
- **Terceiro ponto:** A serenidade que nasce da confiança em Deus.

---

## Conclusão e Oração

Termine seu artigo com uma palavra de ânimo ou uma breve oração para o leitor:

*Senhor, guia os nossos passos e firma o nosso coração na Tua verdade. Em nome de Jesus, amém.*
"@

    # Salva o arquivo em UTF-8
    $conteudoPost | Set-Content -Path $arquivoDestino -Encoding UTF8

    # Animação sutil de feedback
    Write-Host ""
    Write-Host "  ${C_MUTED}Compilando estrutura...${C_RESET}"
    Start-Sleep -Milliseconds 250

    # Resumo Final em Card Estilizado
    Write-Host ""
    Write-Host "  ${C_GREEN}${C_BOLD}✔ Reflexão criada com sucesso!${C_RESET}"
    Write-Host "  ${C_MUTED}$DIVIDER${C_RESET}"
    Write-Host "  ${C_WHITE}${C_BOLD}Arquivo:${C_RESET}    ${C_CYAN}content\posts\$slug.md${C_RESET}"
    Write-Host "  ${C_WHITE}${C_BOLD}Título:${C_RESET}     ${C_WHITE}$titulo${C_RESET}"
    Write-Host "  ${C_WHITE}${C_BOLD}Status:${C_RESET}     $(if ($isDraft -eq 'true') { "${C_YELLOW}● Rascunho (draft)${C_RESET}" } else { "${C_GREEN}● Pronto para ir ao ar${C_RESET}" })"
    Write-Host "  ${C_WHITE}${C_BOLD}Tópicos:${C_RESET}    ${C_MUTED}[$tagsFormatted]${C_RESET}"
    Write-Host "  ${C_MUTED}$DIVIDER${C_RESET}"
    Write-Host ""
    Write-Host "  ${C_SOFTCYAN}${C_BOLD}Próximo passo:${C_RESET} Abra o arquivo para escrever sua mensagem:"
    Write-Host "  ${C_MUTED}code content\posts\$slug.md${C_RESET}"
    Write-Host ""
}

function List-VerboPosts {
    Show-Banner
    Write-Host "  ${C_SOFTCYAN}${C_BOLD}[=] Reflexões e Artigos Registrados${C_RESET}"
    Write-Host "  ${C_MUTED}$DIVIDER${C_RESET}"
    Write-Host ""

    $postsDir = Join-Path $PSScriptRoot "content\posts"
    if (-not (Test-Path $postsDir)) {
        Write-Host "  ${C_YELLOW}  Nenhum artigo encontrado em content/posts/.${C_RESET}"
        return
    }

    $files = Get-ChildItem -Path $postsDir -Filter "*.md"
    if ($files.Count -eq 0) {
        Write-Host "  ${C_YELLOW}  Nenhum artigo cadastrado ainda.${C_RESET}"
        return
    }

    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        $title = if ($content -match 'title:\s*"(.*?)"') { $matches[1] } else { $file.BaseName }
        $draft = if ($content -match 'draft:\s*(true|false)') { $matches[1] } else { "unknown" }
        $date  = if ($content -match 'date:\s*(.*?)\r?\n') { $matches[1] } else { "-" }

        $statusBadge = if ($draft -eq "true") {
            "${C_YELLOW}[DRAFT]${C_RESET}"
        } else {
            "${C_GREEN}[PUBLISHED]${C_RESET}"
        }

        Write-Host "  $statusBadge ${C_WHITE}${C_BOLD}$title${C_RESET}"
        Write-Host "    ${C_MUTED}Arquivo: content\posts\$($file.Name) • Data: $date${C_RESET}"
        Write-Host ""
    }
}

function Show-Help {
    Show-Banner
    Write-Host "  ${C_SOFTCYAN}${C_BOLD}Como usar a CLI Siga o Verbo:${C_RESET}"
    Write-Host ""
    Write-Host "    ${C_CYAN}.\verbo.ps1${C_RESET}              Inicia o assistente interativo para criar novo post"
    Write-Host "    ${C_CYAN}.\verbo.ps1 novo${C_RESET}         Cria um novo post guiado passo a passo"
    Write-Host "    ${C_CYAN}.\verbo.ps1 listar${C_RESET}       Lista todos os artigos existentes e seus status"
    Write-Host "    ${C_CYAN}.\verbo.ps1 ajuda${C_RESET}        Exibe esta tela de instruções"
    Write-Host ""
}

# Roteador de Comandos
switch ($Comando.ToLower()) {
    "listar" { List-VerboPosts }
    "ajuda"  { Show-Help }
    default  { 
        New-VerboPost -TituloPreenchido $TituloParam `
                      -DescricaoPreenchida $Descricao `
                      -TagsPreenchidas $Tags `
                      -PublicarDireto:$ProntoParaPublicar 
    }
}
