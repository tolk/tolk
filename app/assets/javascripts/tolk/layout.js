$(function () {

  // Fit text area height
  $('.translations textarea').each(function () {
    $(this).css({ height: $(this).parent('td').css('height')});
  });

  // Mark active textarea
  $(".translations textarea").bind("focus", function () {
    $(this).parents("tr").toggleClass('active');
  });

  $(".translations textarea").bind("blur", function () {
    $(this).parents("tr").toggleClass('active');
  });

  $("#limit_select").change(function () {
    var limit = $(this).val();
    var href = window.location.href.split("?")[0];
    href += "?limit="
    href += limit
    window.location.href = href
  })
});
