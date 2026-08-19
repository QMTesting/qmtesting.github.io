document.addEventListener("DOMContentLoaded", () => {
  // Only target highlight boxes inside blog posts
  const highlights = document.querySelectorAll(".post .highlight");

  highlights.forEach((wrapper) => {
    // Skip if already has a button
    if (wrapper.querySelector(".copy-btn")) return;

    const button = document.createElement("button");
    button.className = "copy-btn";
    button.innerText = "Copy";

    // Ensure button stays inside the highlight box
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
