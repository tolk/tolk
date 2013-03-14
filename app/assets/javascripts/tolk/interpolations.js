$(function () {
  var interpolation = new RegExp("%{\\w+}", "g");

  $(".phrase .value").each(function () {
    var text = $('<div/>').text($(this).text()).html()
      , token_text;

    token_text = text.replace(interpolation, function (match) {
      return '<span class="interpolation"  title="Don\'t translate this word">' + match + '</span>';
    });

    $(this).html(token_text);
  });

  $(".translations textarea").bind("focus", function () {
    $(this).parents("tr").toggleClass('active');
  });

  $(".translations textarea").bind("blur", function () {
    $(this).parents("tr").toggleClass('active');

    var row = $(this).parents("tr")
      , original_text = row.find(".phrase .original").text()
      , translated_text = $(this).val()
      , original_interpolations = original_text.match(interpolation) || []
      , translated_interpolations = translated_text.match(interpolation) || []
      , not_match;

    not_match = translated_text.length > 0 &&
                ($(original_interpolations).not(translated_interpolations).length !== 0 ||
                 $(translated_interpolations).not(original_interpolations).length !== 0);

    row.find(".actions .warning").toggle(not_match);

  });

});
