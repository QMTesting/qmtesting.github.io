document.addEventListener("DOMContentLoaded", function () {
  const params = new URLSearchParams(window.location.search);
  const query = params.get("q");

  if (query) {
    fetch("/search.json")
      .then(response => response.json())
      .then(data => {
        const resultsContainer = document.getElementById("search-results");
        const results = data.filter(post =>
          post.title.toLowerCase().includes(query.toLowerCase()) ||
          post.content.toLowerCase().includes(query.toLowerCase())
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
