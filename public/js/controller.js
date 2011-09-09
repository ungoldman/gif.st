$(function(){
  $('.topbar .secondary-nav .btn').hover(
      function(){ $('.topbar .secondary-nav .twipsy').fadeIn(); },
      function(){ $('.topbar .secondary-nav .twipsy').fadeOut(); }
    );
    
  $('.dropdown').hover(
    function(){ $('.dropdown .dropdown-menu').show(); },
    function(){ $('.dropdown .dropdown-menu').hide(); }
  );
  
});