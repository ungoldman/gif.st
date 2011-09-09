$(function(){
  $('.topbar .secondary-nav .btn').hover(
      function(){ $('.topbar .secondary-nav .twipsy').fadeIn(); },
      function(){ $('.topbar .secondary-nav .twipsy').fadeOut(); }
    );
    
  $('.dropdown').click(
    function(e){
      e.preventDefault();
      $('.dropdown-menu', this).toggle();
      $('.dropdown-toggle', this).toggleClass('dropdown-active');
    }
  );
  
  $('html').click(function() {
    $('.dropdown-menu').hide();
    $('.dropdown-toggle', this).removeClass('dropdown-active');
   });

   $('.dropdown').click(function(event){
       event.stopPropagation();
   });
});