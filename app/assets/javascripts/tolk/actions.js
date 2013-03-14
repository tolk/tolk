$(function () {

  // Copy text action
  $(".translations .actions .copy").click(function (e) {
    e.preventDefault();

    var row = $(this).parents("tr")
      , original = row.find(".phrase .original").text();

    row.find(".translation textarea").addClass("dirty").val(original.trim());

    // Bind the dirty callback after copy
    window.onbeforeunload = confirm;
  });

  // avoid lose data
  $(".translations textarea").bind("blur", function () {
    if ($(this).is(".dirty")) {
      window.onbeforeunload = confirm;
    }
  });

  $(".translations textarea").bind("keydown", function () {
    $(this).addClass("dirty");
  });

  $("input.save, input.apply").click(function () {
    window.onbeforeunload = null;
  });

  function confirm() {
    return "You are leaving this page with non-saved data. Are you sure you want to continue?";
  }

});
