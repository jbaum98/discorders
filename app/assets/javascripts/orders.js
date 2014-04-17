$("#order_form input[type='number']").change( function () {
    $("label[for='order_paid'].form-control").text("($" + ((parseInt($(order_orange).val()) + parseInt($(order_blue).val()) + parseInt($(order_white).val())) * 8) + ")");
});