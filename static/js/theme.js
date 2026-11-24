/**
 * Siga o Verbo - Theme & View Mode Controller
 * Suporta: Light (Branco Clean Apple) | Paper (Leitura Acolhedora) | Dark (Noturno OLED)
 * Princípios: Nielsen #1 (Visibilidade de status), Nielsen #7 (Atalho de teclado 'T')
 */

(function () {
  const THEMES = ['light', 'paper', 'dark'];
  const THEME_LABELS = {
    light: 'Modo Claro (Branco)',
    paper: 'Modo Papel (Leitura Suave)',
    dark: 'Modo Noturno (Escuro)'
  };

  function getSavedTheme() {
    const saved = localStorage.getItem('siga-o-verbo-theme');
    if (saved && THEMES.includes(saved)) {
      return saved;
    }
    // Respeita preferência do sistema se não houver preferência salva
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      return 'dark';
    }
    return 'light';
  }

  function applyTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('siga-o-verbo-theme', theme);
    updateButton(theme);
  }

  function updateButton(theme) {
    const btn = document.getElementById('theme-toggle-btn');
    if (!btn) return;
    
    const nextThemeIndex = (THEMES.indexOf(theme) + 1) % THEMES.length;
    const nextTheme = THEMES[nextThemeIndex];
    const label = `Modo atual: ${THEME_LABELS[theme]}. Clique para alternar para ${THEME_LABELS[nextTheme]} (ou pressione 'T')`;
    
    btn.setAttribute('aria-label', label);
    btn.setAttribute('title', label);

    // Ícones dinâmicos de acordo com o tema
    const iconSun = btn.querySelector('.icon-sun');
    const iconBook = btn.querySelector('.icon-book');
    const iconMoon = btn.querySelector('.icon-moon');

    if (iconSun && iconBook && iconMoon) {
      iconSun.style.display = theme === 'light' ? 'block' : 'none';
      iconBook.style.display = theme === 'paper' ? 'block' : 'none';
      iconMoon.style.display = theme === 'dark' ? 'block' : 'none';
    }
  }

  function cycleTheme() {
    const current = document.documentElement.getAttribute('data-theme') || 'light';
    const nextIndex = (THEMES.indexOf(current) + 1) % THEMES.length;
    applyTheme(THEMES[nextIndex]);
  }

  // Inicializa tema antes da renderização completa para evitar flash (FOUC)
  const initialTheme = getSavedTheme();
  document.documentElement.setAttribute('data-theme', initialTheme);

  document.addEventListener('DOMContentLoaded', function () {
    const btn = document.getElementById('theme-toggle-btn');
    if (btn) {
      btn.addEventListener('click', cycleTheme);
      updateButton(initialTheme);
    }

    // Heurística de Nielsen #7: Atalho 'T' para alternar temas
    document.addEventListener('keydown', function (e) {
      if (e.key.toLowerCase() === 't' && !['INPUT', 'TEXTAREA'].includes(document.activeElement.tagName)) {
        cycleTheme();
      }
    });
  });
})();
