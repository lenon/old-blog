/*
 * Post Preview
 */
var document_loaded = function(){
  if (!document.getElementById("post-form")) return;

  var title   = document.getElementById("post-title"),
      content = document.getElementById("post-content"),
      title_preview   = document.getElementById("preview-title"),
      content_preview = document.getElementById("preview-content"),
      loading_message = document.getElementById("preview-loading");

  var changed = false;
  var request;

  title.onkeyup = function(){
    changed = true;
  };

  content.onkeyup = function(){
    changed = true;
  };

  var show_loading_message = function(){
    loading_message.style.display = "";
  };

  var hide_loading_message = function(){
    loading_message.style.display = "none";
  };

  var do_request = function(){
    try { request.abort(); } catch(e){}

    changed = false;
    show_loading_message();

    request = new XMLHttpRequest();
    request.open("POST", "/admin/markdown-preview", true);
    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    request.onreadystatechange = function(){
      if (request.readyState != 4 || request.status != 200) return;

      hide_loading_message();
      title_preview.textContent = title.value || "";
      content_preview.innerHTML = request.responseText || "";
    }

    request.send( 'text=' + encodeURIComponent( content.value ) );
  };

  setInterval( function(){
    if (changed) { do_request(); }
  }, 10000);

  do_request();
};
