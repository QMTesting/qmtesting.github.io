document.addEventListener("DOMContentLoaded", () => {
  // Select all code blocks rendered by Markdown
  const codeBlocks = document.querySelectorAll("div.highlight pre, pre.highlight, pre > code");

  codeBlocks.forEach((block) => {
    // Create a copy button
    const button = document.createElement("button");
    button.className = "copy-btn";
    button.innerText = "Copy";

    // Position the button above the code block
    const wrapper = block.closest("div.highlight") || block.parentElement;
    wrapper.style.position = "relative";
    wrapper.insertBefore(button, wrapper.firstChild);

    // Copy functionality
    button.addEventListener("click", () => {
      const textToCopy = block.innerText;
      navigator.clipboard.writeText(textToCopy).then(() => {
        button.innerText = "Copied!";
        setTimeout(() => (button.innerText = "Copy"), 2000);
      });
    });
  });

  console.log("Copy buttons added to all code blocks:", codeBlocks.length);
});

