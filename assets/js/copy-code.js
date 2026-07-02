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
    button.style.right = "0px";
    button.style.top = "0px";
    button.style.padding = "0px 0px";
    button.style.fontSize = "12px";
    button.style.cursor = "pointer";

    // Make the parent <pre> relative so button positions correctly
    const pre = codeBlock.parentNode;

    // Create wrapper
    const wrapper = document.createElement("div");
    wrapper.className = "code-wrapper";
    
    // Insert wrapper before <pre>
    pre.parentNode.insertBefore(wrapper, pre);
    
    // Move <pre> inside wrapper
    wrapper.appendChild(pre);
    
    // Add button inside wrapper (NOT inside <pre>)
    wrapper.appendChild(button);


    // Copy code to clipboard
    button.addEventListener("click", () => {
      navigator.clipboard.writeText(codeBlock.innerText).then(() => {
        button.innerText = "Copied!";
        setTimeout(() => (button.innerText = "Copy"), 2000);
      });
    });
  });

  console.log("Copy buttons added to code blocks:", codeBlocks.length);

  // Put copy button in right top corner - start
  document.addEventListener("DOMContentLoaded", () => {
  const codeBlocks = document.querySelectorAll(".post pre > code");

  codeBlocks.forEach((codeBlock) => {
    const pre = codeBlock.parentNode;

    // Create wrapper
    const wrapper = document.createElement("div");
    wrapper.className = "code-wrapper";

    // Insert wrapper before <pre>
    pre.parentNode.insertBefore(wrapper, pre);
    wrapper.appendChild(pre);

    // Create copy button
    const button = document.createElement("button");
    button.innerText = "Copy";
    button.className = "copy-btn";
    wrapper.appendChild(button);

    // Copy logic
    button.addEventListener("click", () => {
      navigator.clipboard.writeText(codeBlock.innerText).then(() => {
        button.innerText = "Copied!";
        setTimeout(() => (button.innerText = "Copy"), 2000);
      });
    });

    // ⭐ Follow-the-scroll logic
    wrapper.addEventListener("scroll", () => {
      const scrollLeft = wrapper.scrollLeft;
      button.style.transform = `translateX(${scrollLeft}px)`;
    });
  });
});

// Put copy button in right top corner - end
  
});
