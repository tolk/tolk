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
  $('.js-gtranslate-single').click(function (e) {
    e.preventDefault();

    var origText = $(this).parent(".actions").next('.original').find("textarea").val();
    var destLang = $(this).data('locale');
    if(destLang === 'es-CO') { destLang = 'es'; }
    var self = this;
    gTranslate(origText, destLang).then(function(response) {
      var destText = response.result.data.translations[0].translatedText;
      var tr = $(self).parents('tr')
      var textarea = tr.find(".translation textarea")
      textarea.val(destText);
      textarea.data("auto_generated_value", destText);
      tr.find('[id$="auto_generated_at"]').val(new Date().toISOString());
    }, function(reason) {
      console.warn('Error: ' + reason.result.error.message);
    });
  });

  $('.js-gtranslate-all').click(function (e) {
    e.preventDefault();
    var destLang = $(this).data('locale');
    if(destLang === 'es-CO') { destLang = 'es'; }

    var tbody = $("form.edit_locale").find("tbody")
    var texts = [];
    tbody.find("td.original").each(function() {
      texts.push($(this).find("textarea").val());
    })

    gTranslate(texts, destLang).then(function(response) {
      var translations = response.result.data.translations;
      tbody.find("td.translation").each(function(index) {
        var newValueArea = $(this).find("textarea");
        var originalValue = texts[index];

        var value = translations[index].translatedText;
        if(newValueArea.val().length > 0 || // exclude already filled
          originalValue.indexOf("%{") > -1 || // exclude phrases with variables
          originalValue.indexOf("---") > -1) { // exclude --- one: ... other: ...
          return true;
        }
        newValueArea.data("auto_generated_value", value);
        newValueArea.val(value);
        newValueArea.parent().find('[id$="auto_generated_at"]').val(new Date().toISOString());
      })
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

  $(".translations textarea").bind("keyup", function () {
    var newValue = $(this).val().trim();
    var input = $(this).parent().find('[id$="auto_generated_at"]');
    if(newValue.length > 0 && newValue === $(this).data("auto_generated_value")) {
      input.val(new Date().toISOString());
    } else {
      input.val("");
    }
  });

  $("input.save, input.apply").click(function () {
    window.onbeforeunload = null;
  });

  function confirm() {
    return "You are leaving this page with non-saved data. Are you sure you want to continue?";
  }

  function gTranslate(q, target) {
    return gapi.client.init({
      'apiKey': window.googleApiKey,
      'discoveryDocs': ['https://www.googleapis.com/discovery/v1/apis/translate/v2/rest'],
    }).then(function() {
      return gapi.client.language.translations.list({
        q: q,
        source: 'en',
        target: target,
      });
    })
  }
});
