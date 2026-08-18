document.addEventListener("DOMContentLoaded", () => {
  // Select only the outermost .highlight containers
  const codeWrappers = document.querySelectorAll("div.highlight");

  codeWrappers.forEach((wrapper) => {
    // Skip if a copy button already exists
    if (wrapper.querySelector(".copy-btn")) return;

    // Create one copy button per wrapper
    const button = document.createElement("button");
    button.className = "copy-btn";
    button.innerText = "Copy";

    // Position the button in the top-right corner
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

  console.log("Copy buttons added to:", codeWrappers.length, "code blocks");
});
