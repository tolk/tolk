$(function () {
  var interpolation = new RegExp("%{\\w+}", "g");

  $(".phrase .value").each(function () {
    var text = $(this).text()
      , token_text = text;

    token_text = text.replace(interpolation, function (match) {
      return '<span class="interpolation">' + match + '</span>';
    });

    $(this).html(token_text);
  });

  $(".translations textarea").bind("focus", function () {
    $(this).toggleClass('active');
  });

  $(".translations textarea").bind("blur", function () {
    $(this).toggleClass('active');

    var row = $(this).parents("tr")
      , original_text = row.find(".phrase .original").text()
      , translated_text = $(this).val()
      , original_interpolations = original_text.match(interpolation)
      , translated_interpolations = translated_text.match(interpolation)
      , not_match;

    not_match = translated_text.length > 0 &&
                (original_interpolations || []).length !== (translated_interpolations || []).length;

    row.find(".actions .warning").toggle(not_match);

  });

});
