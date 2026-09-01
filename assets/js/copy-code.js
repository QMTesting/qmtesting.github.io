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

document.addEventListener("DOMContentLoaded", function () {
  document
    .querySelectorAll(".highlighter-rouge > .code-wrapper > .copy-btn")
    .forEach(function (button) {
      button.remove();
    });
});


document.addEventListener("DOMContentLoaded", () => {
  const imageWrappers = document.querySelectorAll("div.copy-image-wrapper, .highlight .copy-image-wrapper");

  imageWrappers.forEach(wrapper => {
    const button = document.createElement("button");
    button.innerText = "Copy";
    button.className = "copy-btn";

    // Position button
    wrapper.style.position = "relative";
    button.style.position = "absolute";
    button.style.top = "0px";
    button.style.right = "0px";

    wrapper.appendChild(button);

    button.addEventListener("click", async () => {
      const img = wrapper.querySelector("img");

      try {
        const response = await fetch(img.src);
        const blob = await response.blob();
        await navigator.clipboard.write([
          new ClipboardItem({ [blob.type]: blob })
        ]);

        button.innerText = "Copied!";
        setTimeout(() => (button.innerText = "Copy"), 2000);
      } catch (err) {
        console.error(err);
        alert("Failed to copy image.");
      }
    });
  });
});



