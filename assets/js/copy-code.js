document.addEventListener("DOMContentLoaded", () => {
  const blocks = document.querySelectorAll(".entry .highlight");

  blocks.forEach((block) => {
    // Create button
    const button = document.createElement("button");
    button.className = "copy-btn";
    button.innerText = "Copy";

    // Insert button ABOVE the highlight block
    block.parentNode.insertBefore(button, block);

    // Copy logic
    const code = block.querySelector("code");
    button.addEventListener("click", () => {
      navigator.clipboard.writeText(code.innerText).then(() => {
        button.innerText = "Copied!";
        setTimeout(() => {
          button.innerText = "Copy";
        }, 2000);

      });
    });
  });
});

