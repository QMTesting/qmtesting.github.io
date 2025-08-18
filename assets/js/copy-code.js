document.addEventListener("DOMContentLoaded", () => {
  // Limit to code blocks inside blog post content
  document.querySelectorAll(".post-content pre > code").forEach((codeBlock) => {
    // Create a copy button
    const button = document.createElement("button");
    button.innerText = "Copy";
    button.className = "copy-btn";

    // Style the button inline (fallback if no CSS)
    button.style.position = "absolute";
    button.style.right = "5px";
    button.style.top = "5px";
    button.style.padding = "2px 8px";
    button.style.fontSize = "12px";
    button.style.cursor = "pointer";

    // Wrap <pre> in relative container so button positions correctly
    const pre = codeBlock.parentNode;
    pre.style.position = "relative";
    pre.appendChild(button);

    // Copy code to clipboard on click
    button.addEventListener("click", () => {
      navigator.clipboard.writeText(codeBlock.innerText).then(() => {
        button.innerText = "Copied!";
        setTimeout(() => (button.innerText = "Copy"), 2000);
      });
    });
  });
});
