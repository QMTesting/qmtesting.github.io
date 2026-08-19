document.addEventListener("DOMContentLoaded", () => {
  // Prevent script from running twice
  if (window.copyCodeInitialized) return;
  window.copyCodeInitialized = true;

  // Select only highlight boxes in a blog post
  const highlights = document.querySelectorAll(".post div.highlight");

  highlights.forEach((wrapper) => {
    // Only add buttons to highlight boxes inside a .code-wrapper
    if (!wrapper.closest(".code-wrapper")) return;

    // Only add buttons to boxes that actually contain code/text
    if (!wrapper.querySelector("pre, code")) return;

    // Avoid duplicates
    if (wrapper.querySelector(".copy-btn")) return;

    // Create the button
    const button = document.createElement("button");
    button.className = "copy-btn";
    button.innerText = "Copy";

    // Position the button inside the white box
    wrapper.style.position = "relative";
    wrapper.insertBefore(button, wrapper.firstChild);

    // Copy logic
    button.addEventListener("click", () => {
      const codeBlock = wrapper.querySelector("pre code, code");
      if (!codeBlock) return;

      navigator.clipboard.writeText(codeBlock.innerText).then(() => {
        button.innerText = "Copied!";
        setTimeout(() => (button.innerText = "Copy"), 2000);
      });
    });
  });
});
