document.addEventListener("DOMContentLoaded", () => {
  // Prevent the script from running twice
  if (window.copyCodeInitialized) return;
  window.copyCodeInitialized = true;

  // Find each actual code block
  const codeBlocks = document.querySelectorAll(
    ".highlighter-rouge .highlight pre code"
  );

  codeBlocks.forEach((codeBlock) => {
    // Find the closest container for this specific code block
    const pre = codeBlock.closest("pre");

    const container =
      pre.closest(".code-wrapper") ||
      pre.closest(".highlight") ||
      pre.parentElement;

    // Stop if no container was found
    if (!container) return;

    // Prevent duplicate buttons in this specific container
    if (container.querySelector(":scope > .code-copy-button")) {
      return;
    }

    // Create the Copy button
    const button = document.createElement("button");
    button.className = "code-copy-button";
    button.type = "button";
    button.textContent = "Copy";

    // Make this container the positioning reference
    container.style.position = "relative";

    // Add the button directly inside this code container
    container.insertBefore(button, container.firstChild);

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
