var onload = function(){
  if (!document.getElementById("post-form")) return;

  var title_input = document.getElementById("post-title");
  var content_input = document.getElementById("post-content");

  var title_preview = document.getElementById("post-preview-title");
  var content_preview = document.getElementById("post-preview-content");

  var title_input_onkeyup = function(){
    title_preview.textContent = title_input.value || "";
  };
  title_input.onkeyup = title_input_onkeyup;

  var content_input_onkeyup = function(){
    content_preview.innerHTML = content_input.value || "";
  };
  content_input.onkeyup = content_input_onkeyup;

  content_input_onkeyup();  
  title_input_onkeyup();
};

window.onload = onload;