document.addEventListener("DOMContentLoaded", () => {
  // Get just the first highlight box
  const wrapper = document.querySelector("div.highlight");
  if (!wrapper) return;

  // Create one copy button
  const button = document.createElement("button");
  button.className = "copy-btn";
  button.innerText = "Copy";

  // Position the button
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

