$(function () {

  // Copy text action
  $(".translations .actions .copy").click(function (e) {
    e.preventDefault();

    var row = $(this).parents("tr")
      , original = row.find(".phrase .original").text();

    row.find(".translation textarea").val(original.trim());
  });

});
