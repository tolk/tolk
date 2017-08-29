$(function () {

  // Copy text action
  $(document).live('click', '.copy', (function (e) {
    e.preventDefault();

    var row = $(this).parents("tr")
      , original_text = row.find(".original textarea").val();

    row.find(".translation textarea").val(original_text.trim()).trigger("change");
  }));

  // Google Translate action
  $('document').live('click', '.gtranslate', (function (e) {
    console.log('called GT action')
    e.preventDefault();

    var row = $(this).parents("tr")
      , origText = row.find(".original textarea").val()
      , origLang = 'en'
      , destLang = func() {
      var url = window.location.pathname;
      return url.substr(url.length-1);
    };

    function gTranslate(text) {
      var url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl="
      + 'en' + "&tl=" + destLang + "&dt=t&q=" + encodeURI(origText);
      var response = $.getJSON(url);
      return response;
    };

    destText = gTranslate(origText);
    row.find(".translation textarea").val(destText.trim()).trigger("change");
    console.log('completed GT action')
  }));

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
