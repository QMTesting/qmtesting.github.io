document.addEventListener("DOMContentLoaded", () => {
  if (window.copyCodeInitialized) return;
  window.copyCodeInitialized = true;

  // Select only .highlight blocks that directly contain <pre><code>
  const highlights = document.querySelectorAll("div.highlight");

  highlights.forEach((box) => {
    // Skip if already has a button
    if (box.querySelector(".copy-btn")) return;

    // Skip if this .highlight contains another .highlight (nested)
    if (box.querySelector("div.highlight")) return;

    // Skip if it doesn't contain a <pre><code> block
    if (!box.querySelector("pre code")) return;

    // Create the copy button
    const button = document.createElement("button");
    button.className = "copy-btn";
    button.innerText = "Copy";

    // Position the button
    box.style.position = "relative";
    box.insertBefore(button, box.firstChild);

    // Copy functionality
    button.addEventListener("click", () => {
      const codeBlock = box.querySelector("pre code");
      if (!codeBlock) return;

      navigator.clipboard.writeText(codeBlock.innerText).then(() => {
        button.innerText = "Copied!";
        setTimeout(() => (button.innerText = "Copy"), 2000);
      });
    });
  });

  console.log("Copy buttons added to:", highlights.length, "code boxes");
});
