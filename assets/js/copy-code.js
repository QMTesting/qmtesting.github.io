document.addEventListener("DOMContentLoaded", () => {
  // Prevent the script from running twice
  if (window.copyCodeInitialized) return;
  window.copyCodeInitialized = true;

  // Find the actual code blocks
  const codeBlocks = document.querySelectorAll(
    ".highlighter-rouge .highlight > pre > code"
  );

  codeBlocks.forEach((codeBlock) => {
    // Use the highlight containing THIS code block
    const pre = codeBlock.closest("pre");
    const highlight = pre?.parentElement;

    if (!highlight || !highlight.classList.contains("highlight")) {
      return;
    }

    // Prevent more than one button in this highlight
    if (highlight.querySelector(":scope > .code-copy-button")) {
      return;
    }

    // Make the highlight the positioning container
    highlight.style.position = "relative";

    // Create one Copy button
    const button = document.createElement("button");
    button.className = "code-copy-button";
    button.type = "button";
    button.textContent = "Copy";

    // Add the button directly to this highlight
    highlight.insertBefore(button, highlight.firstChild);

    // Copy functionality
    button.addEventListener("click", async () => {
      try {
        await navigator.clipboard.writeText(codeBlock.innerText);

        button.textContent = "Copied!";

        setTimeout(() => {
          button.textContent = "Copy";
        }, 2000);
      } catch (error) {
        console.error("Failed to copy code:", error);

        button.textContent = "Error";

        setTimeout(() => {
          button.textContent = "Copy";
        }, 2000);
      }
    });
  });

  console.log(
    "Copy buttons added to:",
    codeBlocks.length,
    "code blocks"
  );
});

