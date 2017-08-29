$(function () {

  // Copy text action
  $('.translations .actions .copy').click(function (e) {
    e.preventDefault();

    var row = $(this).parents("tr")
      , original_text = row.find(".original textarea").val();

    row.find(".translation textarea").val(original_text.trim()).trigger("change");
  });

  // Google Translate action (NEW)
  $('.gtranslate').click(function (e) {
    e.preventDefault();

    var origText = $(this).parent(".actions").next('.original').find("textarea").val();
    var destLang = $(this).data('locale');
    var url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl="+ destLang + "&dt=t&q=" + encodeURI(origText);
    var self = this;
    $.getJSON(url, function(data) {
      var destText = data[0][0][0];
      $(self).parents('tr').find(".translation textarea").val(destText);
    });
  });

  // avoid lose data
  $(".translations textarea").bind("keydown", function () {
    window.onbeforeunload = confirm;
  });

  $(".translations textarea").bind("change", function () {
    window.onbeforeunload = confirm;
  });

  $("input.save, input.apply").click(function () {
    window.onbeforeunload = null;
  });

  function confirm() {
    return "You are leaving this page with non-saved data. Are you sure you want to continue?";
  }

});
