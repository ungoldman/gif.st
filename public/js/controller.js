$(function(){
  /* nav behaviors */
  $('#session').click(
    function(event){
      event.preventDefault();
      $('.dropdown-menu', this).toggle();
      $('.dropdown-toggle', this).toggleClass('dropdown-active');
    }
  );
  $('html').click(function() {
    $('.dropdown-menu').hide();
    $('.dropdown-toggle', this).removeClass('dropdown-active');
   });
   $('#session').click(function(event){ event.stopPropagation() });
   $('#session .dropdown-menu').click(function(event){ event.stopPropagation() });
   
  /* ajax & pushState */
  $('.nav.primary-links a').click(function(event){
    event.preventDefault();
    var $link = $(this);
    var $path = $link.text();
    
    $('#sandbox').load('/' + $path + '?ajax=true', function() {
      
      var stateObj = { user: "<%= @user.name %>" };
      history.pushState(stateObj, "gif.st | " + $path, $path);
      
      $('.nav.primary-links a').each(function(){
        $(this).parent().removeClass('active');
      });
      $link.parent().addClass('active');
    });
  });
  
  /* upload */
  $('.topbar .secondary-nav .btn.upload').hover(
    function(){ $('.topbar .secondary-nav .twipsy').fadeIn(); },
    function(){ $('.topbar .secondary-nav .twipsy').fadeOut(); }
  );
  
  $('.topbar .secondary-nav .btn.upload').click(function(event){
    event.preventDefault();
    var uploader = new Uploader();
    $(this).addClass('disabled');
  });
});

function Uploader() {
  
  if ($('#uploader').length == 0) {
    this.html = '<div id="uploader" class="modal-wrapper">' +
      '<div class="modal">' +
      '<div class="modal-header">' +
        '<h3>Gif Uploader</h3>' +
        '<a href="#" class="close">×</a>' +
      '</div>' +
      '<div class="modal-body">' +
        '<p>Select File to Upload...</p>' +
        '<form action="/gif/new" method="post" enctype="multipart/form-data">' +
          '<p>' +
            '<label for="file">File:</label>' +
            '<input type="file" name="file">' +
          '</p>' +
          '<p>' +
            '<input name="commit" type="submit" value="Upload" />' +
         ' </p>' +
        '</form>' +
      '</div>' +
      '<div class="modal-footer">' +
        '<a href="#" class="btn primary">Upload</a>' +
        '<a href="#" class="btn secondary">Cancel</a>' +
      '</div>' +
    '</div>' +
    '</div>';
    
    $('#main').prepend(this.html);
    
    /*
    /* close dialog box */
    $('#uploader .close').click(function(event){
      event.preventDefault();
      $('#uploader').remove();
      $('.topbar .secondary-nav .btn.upload').removeClass('disabled');
    });
    $('#uploader .modal-footer .btn.secondary').click(function(event){
      event.preventDefault();
      $('#uploader').remove();
      $('.topbar .secondary-nav .btn.upload').removeClass('disabled');
    });
  };
};