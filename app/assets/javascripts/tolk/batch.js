$(function () {
  $(".js-start-batch-translation").click(function (e) {
    e.preventDefault();

    $target = $(e.currentTarget)

    $.ajax({
      url: $target.data('url'),
      data: {},
      method: 'POST',
      success: function (response) {
      }
    })
    
  });
})

