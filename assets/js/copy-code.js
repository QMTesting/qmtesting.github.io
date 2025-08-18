document.addEventListener("DOMContentLoaded", () => {
  // Target all code blocks inside posts
  const codeBlocks = document.querySelectorAll(".post pre > code");

  codeBlocks.forEach((codeBlock) => {
    // Create copy button
    const button = document.createElement("button");
    button.innerText = "Copy";
    button.className = "copy-btn";

    // Inline styling (can be moved to CSS)
    button.style.position = "absolute";
    button.style.right = "5px";
    button.style.top = "5px";
    button.style.padding = "2px 8px";
    button.style.fontSize = "12px";
    button.style.cursor = "pointer";

    // Make the parent <pre> relative so button positions correctly
    const pre = codeBlock.parentNode;
    pre.style.position = "relative";
    pre.appendChild(button);

    // Copy code to clipboard
    button.addEventListener("click", () => {
      navigator.clipboard.writeText(codeBlock.innerText).then(() => {
        button.innerText = "Copied!";
        setTimeout(() => (button.innerText = "Copy"), 2000);
      });
    });
  });

  console.log("Copy buttons added to code blocks:", codeBlocks.length);
});
