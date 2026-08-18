document.addEventListener("DOMContentLoaded", () => {
  const highlights = document.querySelectorAll("div.highlight");

  highlights.forEach((wrapper) => {
    // Skip if parent is .language-plaintext.highlighter-rouge (outer wrapper)
    if (wrapper.parentElement.classList.contains("language-plaintext")) return;

    // Skip if this highlight doesn't contain a <pre> (top-level container)
    if (!wrapper.querySelector("pre")) return;

    // Avoid duplicates
    if (wrapper.querySelector(".copy-btn")) return;

    const button = document.createElement("button");
    button.className = "copy-btn";
    button.innerText = "Copy";

    wrapper.style.position = "relative";
    wrapper.insertBefore(button, wrapper.firstChild);

    button.addEventListener("click", () => {
      const codeBlock = wrapper.querySelector("pre code");
      if (!codeBlock) return;

      navigator.clipboard.writeText(codeBlock.innerText).then(() => {
        button.innerText = "Copied!";
        setTimeout(() => (button.innerText = "Copy"), 2000);
      });
    });
  });
});
