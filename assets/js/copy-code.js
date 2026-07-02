document.addEventListener("DOMContentLoaded", () => {
  // Target all code blocks inside posts
  const codeBlocks = document.querySelectorAll(".post pre > code");

  codeBlocks.forEach((codeBlock) => {
    const pre = codeBlock.parentNode;

    // Create wrapper
    const wrapper = document.createElement("div");
    wrapper.className = "code-wrapper";

    // Insert wrapper before <pre>
    pre.parentNode.insertBefore(wrapper, pre);

    // Move <pre> inside wrapper
    wrapper.appendChild(pre);

    // Create copy button
    const button = document.createElement("button");
    button.innerText = "Copy";
    button.className = "copy-btn";

    // Add button inside wrapper (NOT inside <pre>)
    wrapper.appendChild(button);

    // Copy code to clipboard
    button.addEventListener("click", () => {
      navigator.clipboard.writeText(codeBlock.innerText).then(() => {
        button.innerText = "Copied!";
        setTimeout(() => (button.innerText = "Copy"), 2000);
      });
    });

    // ⭐ Follow-the-scroll logic (keeps button in visible top-right)
    wrapper.addEventListener("scroll", () => {
      const scrollLeft = wrapper.scrollLeft;
      button.style.transform = `translateX(${scrollLeft}px)`;
    });
  });

  console.log("Copy buttons added to code blocks:", codeBlocks.length);
});
