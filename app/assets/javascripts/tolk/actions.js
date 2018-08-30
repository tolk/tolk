$(function () {

  gapi.load('client');

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
    var self = this;
    gapi.client.init({
      'apiKey': window.googleApiKey,
      'discoveryDocs': ['https://www.googleapis.com/discovery/v1/apis/translate/v2/rest'],
    }).then(function() {
      return gapi.client.language.translations.list({
        q: origText,
        source: 'en',
        target: destLang,
      });
    }).then(function(response) {
      var destText = response.result.data.translations[0].translatedText;
      $(self).parents('tr').find(".translation textarea").val(destText);
    }, function(reason) {
      console.warn('Error: ' + reason.result.error.message);
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
