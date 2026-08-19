document.addEventListener("DOMContentLoaded", () => {
  // Prevent script from running twice
  if (window.copyCodeInitialized) return;
  window.copyCodeInitialized = true;

  // Select only the outermost .highlight containers that contain code
  const codeBoxes = document.querySelectorAll("div.highlight");

  codeBoxes.forEach((box) => {
    // Skip if a copy button already exists
    if (box.querySelector(".copy-btn")) return;

    // Skip nested highlights (Rouge creates these internally)
    if (box.closest(".highlight") !== box) return;

    // Create one copy button per visible white box
    const button = document.createElement("button");
    button.className = "copy-btn";
    button.innerText = "Copy";

    // Position the button in the top-right corner
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

  console.log("Copy buttons added to:", codeBoxes.length, "code boxes");
});
