//= require tolk/jquery-3.5.1.min.js

$(function () {

  //////////////////////////////////////////////////////////////////////// ACTIONS
  // Copy text action
  $(".translations .actions .copy").click(function (e) {
    e.preventDefault();

    var row = $(this).parents("tr")
      , original_text = row.find(".original textarea").val();

    row.find(".translation textarea").val(original_text.trim()).trigger("change");
  });

  // avoid lose data
  $(".translations textarea").bind("keydown", function () {
    window.onbeforeunload = showConfirm;
  });

  $(".translations textarea").bind("change", function () {
    window.onbeforeunload = showConfirm;
  });

  $(".save-translations").click(function () {
    window.onbeforeunload = null;
    $("body form").submit();
  });

  function showConfirm() {
    return "You are leaving this page with non-saved data. Are you sure you want to continue?";
  }


  //////////////////////////////////////////////////////////////////////// LAYOUT
  // Fit text area height
  $('.translations textarea').each(function () {
    $(this).css({ height: $(this).parent('td').height()});
  });

  // Mark active textarea
  $(".translations textarea").bind("focus", function () {
    $(this).parents("tr").toggleClass('active');
  });

  $(".translations textarea").bind("blur", function () {
    $(this).parents("tr").toggleClass('active');
  });


  //////////////////////////////////////////////////////////////////////// INTERPOLATIONS
  var interpolation = new RegExp("%{\\w+}", "g");
  
  $(".translations textarea").bind("change", function () {
      var row = $(this).parents("tr")
        , original_text = row.find(".original textarea").val()
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
