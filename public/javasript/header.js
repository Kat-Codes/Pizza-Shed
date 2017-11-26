if session[:admin] {}
    var header = document.getElementByClass("header").
}

/* If user clicks outside of button area, remove it */
window.onclick = function(event) {
  if (!event.target.matches('.dropButton')) {

    var dropdowns = document.getElementsByClassName("dropdown-content");
    var x;
    for (x = 0; x < dropdowns.length; x++) {
      var openDropdown = dropdowns[x];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}
