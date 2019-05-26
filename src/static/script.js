jQuery(document).ready(function () {

    (function () {
        $("#time").text(moment().format('DD.MM.YYYY HH:mm'));
        setTimeout(arguments.callee, 60000);
    })();

    jQuery.getJSON("/weather", function (data) {
        $("#tempval").text(parseFloat(data.currently.temperature).toFixed(1))
    });

    jQuery("body").click(function () {
        location.reload();
    });

});
