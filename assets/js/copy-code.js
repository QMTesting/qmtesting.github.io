document.addEventListener("DOMContentLoaded", () => {
  const highlights = document.querySelectorAll("div.highlight");

  highlights.forEach((wrapper) => {
    // Skip if parent is .language-plaintext.highlighter-rouge
    if (wrapper.parentElement.classList.contains("language-plaintext")) return;

    if (wrapper.querySelector(".copy-btn")) return;

    const button = document.createElement("button");
    button.className = "copy-btn";
    button.innerText = "Copy";

    const highlightBox = wrapper.querySelector(".highlight");
    if (highlightBox) highlightBox.style.position = "relative";

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
