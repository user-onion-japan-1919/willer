document.addEventListener("DOMContentLoaded", function () {
  let form = document.getElementById("note-form");
  let timeout = null;

  function autoSave() {
    clearTimeout(timeout);
    timeout = setTimeout(() => {
      let formData = new FormData(form);

      // ✅ metadataの値をJSON形式で送る
      let metadata = {};
      document.querySelectorAll(".metadata-entry").forEach(entry => {
        let key = entry.querySelector(".metadata-key").value;
        let value = entry.querySelector(".metadata-value").value;
        if (key.trim() !== "") {
          metadata[key] = value;
        }
      });

      formData.append("note[metadata]", JSON.stringify(metadata));

      fetch(form.action, {
        method: "PATCH",
        body: formData,
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        }
      })
      .then(response => response.json())
      .then(data => {
        document.getElementById("auto-save-status").textContent = "✔ 保存しました";
        setTimeout(() => {
          document.getElementById("auto-save-status").textContent = "";
        }, 3000);
      })
      .catch(error => console.error("自動保存エラー:", error));
    }, 2000);
  }

  document.getElementById("note-title").addEventListener("input", autoSave);
  document.getElementById("note-content").addEventListener("input", autoSave);
  document.getElementById("metadata-fields").addEventListener("input", autoSave);

  window.addField = function () {
    let container = document.getElementById("metadata-fields");
    let div = document.createElement("div");
    div.classList.add("metadata-entry");
    div.innerHTML = `
      <input type="text" class="metadata-key" placeholder="項目名">
      <input type="text" class="metadata-value" placeholder="内容">
      <button type="button" onclick="removeField(this)">削除</button>
    `;
    container.appendChild(div);
  }

  window.removeField = function (button) {
    button.parentElement.remove();
    autoSave();
  }
});
