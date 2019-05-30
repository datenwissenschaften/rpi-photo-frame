jQuery(document).ready(function () {

    (function () {
        jQuery("#time").text(moment().format('DD.MM.YYYY HH:mm'));
        setTimeout(arguments.callee, 60 * 1000);
    })();

    (function () {
        $("#image").attr("src", "/photo?" + Math.random() * 2048 * 2048);
        setTimeout(arguments.callee, 60 * 60 * 1000);
    })();

    (function () {
        jQuery.getJSON("/weather", function (data) {
            jQuery("#tempval").text(parseFloat(data.currently.temperature).toFixed(1))
        });
        setTimeout(arguments.callee, 10 * 60 * 1000);
    })();

    jQuery("#image").click(function () {
        jQuery.post("/backlight", { "switch": true }, function (data) {
            location.reload();
        });
    });

    jQuery("#off").click(function () {
        jQuery.post("/backlight", { "switch": false });
    });

});
