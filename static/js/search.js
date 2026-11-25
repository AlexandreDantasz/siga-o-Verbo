/**
 * Siga o Verbo - Busca Instantânea e Filtro por Tópicos
 * Vanilla JS ultraleve - Zero dependências.
 * Respeita Heurística de Nielsen #1 (Feedback de status) e Lei de Fitts.
 */

(function () {
  const currentScript = document.currentScript;
  const searchIndexUrl = (currentScript && currentScript.dataset.indexUrl) || 'index.json';
  let searchIndex = [];
  let postsContainer = null;
  let defaultHtml = '';
  let statusText = null;

  async function loadSearchIndex() {
    try {
      const response = await fetch(searchIndexUrl);
      if (response.ok) {
        searchIndex = await response.json();
      }
    } catch (e) {
      console.warn('Não foi possível carregar o índice de busca local:', e);
    }
  }

  function renderResults(results, query) {
    if (!postsContainer) return;

    if (!query || query.trim() === '') {
      postsContainer.innerHTML = defaultHtml;
      if (statusText) statusText.textContent = '';
      return;
    }

    if (statusText) {
      statusText.textContent = `${results.length} reflexão(ões) encontrada(s) para "${query}"`;
    }

    if (results.length === 0) {
      postsContainer.innerHTML = `
        <div class="search-empty-state">
          <p class="empty-title">Nenhuma reflexão encontrada</p>
          <p class="empty-desc">Tente buscar por termos como "graça", "oração", "paz" ou "fé".</p>
          <button type="button" class="btn-clear-search" id="btn-reset-search">Limpar busca</button>
        </div>
      `;
      const resetBtn = document.getElementById('btn-reset-search');
      if (resetBtn) {
        resetBtn.addEventListener('click', clearSearch);
      }
      return;
    }

    const html = results.map(post => `
      <article class="post-card search-result-item">
        <div class="post-card-header-line">
          <svg class="post-glyph" viewBox="0 0 24 24">
            <path d="M12 2L15.09 8.26L22 9.27L17 14.14L18.18 21.02L12 17.77L5.82 21.02L7 14.14L2 9.27L8.91 8.26L12 2Z"/>
          </svg>
          <h3 class="post-card-title">
            <a href="${post.permalink}">${post.title}</a>
          </h3>
        </div>
        <div class="post-meta">
          <span>${post.date}</span>
          <span class="dot">•</span>
          <span>${post.readingTime} min de leitura</span>
        </div>
        <p class="post-card-summary">${post.summary}</p>
        <div class="post-card-footer">
          <a href="${post.permalink}" class="read-more-link">
            Ler reflexão completa
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
          </a>
        </div>
      </article>
    `).join('');

    postsContainer.innerHTML = html;
  }

  function handleSearch(query) {
    const term = (query || '').toLowerCase().trim();
    if (!term) {
      renderResults([], '');
      return;
    }

    const filtered = searchIndex.filter(post => {
      const matchTitle = (post.title || '').toLowerCase().includes(term);
      const matchSummary = (post.summary || '').toLowerCase().includes(term);
      const matchTags = (post.tags || []).some(t => t.toLowerCase().includes(term));
      return matchTitle || matchSummary || matchTags;
    });

    renderResults(filtered, query);
  }

  function clearSearch() {
    const input = document.getElementById('site-search-input');
    if (input) {
      input.value = '';
      input.focus();
    }
    renderResults([], '');
  }

  document.addEventListener('DOMContentLoaded', () => {
    postsContainer = document.getElementById('home-posts-list');
    if (postsContainer) {
      defaultHtml = postsContainer.innerHTML;
    }
    statusText = document.getElementById('search-status-feedback');

    const searchInput = document.getElementById('site-search-input');
    const reloadBtn = document.getElementById('search-reload-btn');

    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        handleSearch(e.target.value);
      });
    }

    if (reloadBtn) {
      reloadBtn.addEventListener('click', clearSearch);
    }

    // Filtros rápidos (+ Tópicos da coluna lateral)
    const topicLinks = document.querySelectorAll('.topic-tag-btn');
    topicLinks.forEach(btn => {
      btn.addEventListener('click', (e) => {
        e.preventDefault();
        const tag = btn.getAttribute('data-tag');
        if (searchInput && tag) {
          searchInput.value = tag;
          handleSearch(tag);
          searchInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
      });
    });

    loadSearchIndex();
  });
})();
