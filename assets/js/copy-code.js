document.addEventListener("DOMContentLoaded", () => {
  // Find all <pre><code> blocks inside posts
  const codeBlocks = document.querySelectorAll(".post pre > code");

  codeBlocks.forEach((codeBlock) => {
    const pre = codeBlock.parentNode;              // <pre class="highlight">
    const highlightDiv = pre.parentNode;           // <div class="highlight">
    const outerLangDiv = highlightDiv.parentNode;  // <div class="language-plaintext highlighter-rouge">

    // Create outer container for button + code
    const container = document.createElement("div");
    container.className = "code-block-container";

    // Insert container before the outer language div
    outerLangDiv.parentNode.insertBefore(container, outerLangDiv);

    // Move the existing language/highlight block inside a scrollable wrapper
    const wrapper = document.createElement("div");
    wrapper.className = "code-wrapper";
    container.appendChild(wrapper);
    wrapper.appendChild(outerLangDiv); // moves the whole block

    // Create copy button (above, outside .highlight)
    const button = document.createElement("button");
    button.innerText = "Copy";
    button.className = "copy-btn";
    container.insertBefore(button, wrapper); // button above wrapper

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

