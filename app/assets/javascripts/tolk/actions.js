$(function () {

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

});
