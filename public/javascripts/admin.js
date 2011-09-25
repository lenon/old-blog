/*
 * PREVIEW DE POSTS
 */

// Método chamado ao carregar a página
var onload = function(){
  // Retorna caso o formulário de edição de posts não exista.
  // Ou seja, a página atual não é a página de edição de posts.
  if (!document.getElementById("post-form"))
    return;

  var title = document.getElementById("post-title"), // Input de edição do título do post
      content = document.getElementById("post-content"), // Textarea de edição do conteúdo do post
      title_preview = document.getElementById("preview-title"), // Elemento do preview onde será exibido o título
      content_preview = document.getElementById("preview-content"); // Elemento do preview onde será exibido o conteúdo

  // Variável que será usada como flag para funções abaixo
  var changed = false;
  var request; // Variável que armazenará o XMLHTTPRequest

  // Quando o título ou o conteúdo mudar, "changed" será true
  title.onkeyup = function(){ changed = true; };
  content.onkeyup = function(){ changed = true; };

  var show_loading_message = function(){
    document.getElementById("preview-loading").style.display = "";
  };

  var hide_loading_message = function(){
    document.getElementById("preview-loading").style.display = "none";
  };

  // Função que fará o request do preview para o servidor
  var do_request = function(){
    try {
      // Tenta abortar o request anterior, se existir
      request.abort();
    } catch(e){}

    changed = false;
    show_loading_message();

    // Inicia o objeto XMLHttpRequest (yah, srsly)
    request = new XMLHttpRequest();
    request.open("POST", "/admin/markdown-preview", true);
    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    // Quando o estado do request mudar e seu status for 200, exibe o preview do post
    request.onreadystatechange = function(){
      if (request.readyState == 4 && request.status == 200) {
        hide_loading_message();
        title_preview.textContent = title.value || "";
        content_preview.innerHTML = request.responseText || "";
      }
    }

    request.send( 'text=' + encodeURIComponent( content.value ) );
  };

  setInterval( function(){
    if (changed) {
      do_request();
    }
  }, 15000);

  do_request();
};

window.onload = onload;
