var onload = function(){
  if (!document.getElementById("post-form"))
    return;

  var title = document.getElementById("post-title"),
      content = document.getElementById("post-content"),
      title_preview = document.getElementById("post-preview-title"),
      content_preview = document.getElementById("post-preview-content");

  var changed = false;
  var request;

  title.onkeyup = function(){ changed = true; };
  content.onkeyup = function(){ changed = true; };

  var do_request = function(){
    try { request.abort(); } catch(e){}

    changed = false;

    request = new XMLHttpRequest();
    request.open("POST", "/admin/markdown-preview", true);
    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    request.onreadystatechange = function(){
      if (request.readyState == 4 && request.status == 200) {
        title_preview.textContent = title.value || "";
        content_preview.innerHTML = request.responseText || "";
      }
    }

    request.send( 'text=' + encodeURIComponent( content.value ) );
  };

  setInterval( function(){
    if (changed) { do_request(); }
  }, 15000);

  do_request();
};

window.onload = onload;
