document.addEventListener("DOMContentLoaded", () => {
  // Target all code blocks inside posts
  const codeBlocks = document.querySelectorAll(".post pre > code");

  codeBlocks.forEach((codeBlock) => {
    const pre = codeBlock.parentNode;

    // Create outer container for button + code
    const container = document.createElement("div");
    container.className = "code-block-container";

    // Insert container before <pre>
    pre.parentNode.insertBefore(container, pre);

    // Create copy button (above)
    const button = document.createElement("button");
    button.innerText = "Copy";
    button.className = "copy-btn";
    container.appendChild(button);

    // Create scrollable wrapper for code
    const wrapper = document.createElement("div");
    wrapper.className = "code-wrapper";
    container.appendChild(wrapper);

    // Move <pre> into wrapper
    wrapper.appendChild(pre);

    // Copy logic
    button.addEventListener("click", () => {
      navigator.clipboard.writeText(codeBlock.innerText).then(() => {
        button.innerText = "Copied!";
        setTimeout(() => (button.innerText = "Copy"), 2000);
      });
    });
  });

  console.log("Copy buttons added to code blocks:", codeBlocks.length);
});
