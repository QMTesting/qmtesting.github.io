document.addEventListener("DOMContentLoaded", () => {
  // Select ALL highlight blocks
  const allHighlights = document.querySelectorAll("div.highlight");

  allHighlights.forEach((wrapper) => {
    // Only add a button if THIS highlight contains a <pre> directly
    const pre = wrapper.querySelector(":scope > pre");
    if (!pre) return; // skip nested highlight wrappers

    // Prevent duplicates
    if (wrapper.querySelector(".copy-btn")) return;

    // Create the button
    const button = document.createElement("button");
    button.className = "copy-btn";
    button.innerText = "Copy";

    // Position the button
    wrapper.style.position = "relative";
    wrapper.insertBefore(button, wrapper.firstChild);

    // Copy functionality
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
