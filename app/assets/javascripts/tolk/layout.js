
$(function () {

  // Fit text area height
  $('td textarea').each(function () {
    $(this).css({ height: $(this).parent('td').css('height')});
  });

});
