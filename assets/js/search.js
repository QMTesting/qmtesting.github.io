document.addEventListener("DOMContentLoaded", function () {
  const params = new URLSearchParams(window.location.search);
  const query = params.get("q");

  if (query) {
    // Display the search query
    const queryTitle = document.getElementById("search-query-title");
    queryTitle.textContent = `Search results for: "${query}"`;

    // Fetch and filter posts
    fetch("/search.json")
      .then(response => response.json())
      .then(data => {
        const resultsContainer = document.getElementById("search-results");
        const lowerQuery = query.toLowerCase();

        const results = data.filter(post =>
          post.title.toLowerCase().includes(lowerQuery) ||
          post.content.toLowerCase().includes(lowerQuery) ||
          (post.tags && post.tags.join(" ").toLowerCase().includes(lowerQuery)) ||
          (post.categories && post.categories.join(" ").toLowerCase().includes(lowerQuery))
        );

        if (results.length === 0) {
          resultsContainer.innerHTML = "<p>No results found.</p>";
          return;
        }

        resultsContainer.innerHTML = results.map(post => `
          <div class="post-card">
            <a href="${post.url}">
              <img src="${post.image}" alt="${post.title}" />
              <h3>${post.title}</h3>
            </a>
          </div>
        `).join("");
      });
  }
});

