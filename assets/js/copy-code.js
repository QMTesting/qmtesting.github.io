window.addEventListener("load", () => {
  const blocks = document.querySelectorAll(".entry .highlight");

  blocks.forEach((block) => {
    const wrapper = document.createElement("div");
    wrapper.className = "code-wrapper";

    block.parentNode.insertBefore(wrapper, block);
    wrapper.appendChild(block);

    const button = document.createElement("button");
    button.className = "copy-btn";
    button.innerText = "Copy";

    wrapper.insertBefore(button, block);

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
