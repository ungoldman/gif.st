$(function(){
  $('.topbar .secondary-nav .btn').hover(
      function(){ $('.topbar .secondary-nav .twipsy').fadeIn(); },
      function(){ $('.topbar .secondary-nav .twipsy').fadeOut(); }
    );
    
  $('.dropdown').click(
    function(e){ e.preventDefault(); $('.dropdown .dropdown-menu').toggle(); }
  );
  
});