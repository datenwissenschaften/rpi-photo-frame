jQuery(document).ready(function () {

    (function () {
        $("#time").text(moment().format('DD.MM.YYYY HH:mm'));
        setTimeout(arguments.callee, 60 * 1000);
    })();

    (function () {
        $("#image2").attr("src", "/photo?" + Math.random() * 2048 * 2048);
        $("#image1").toggleClass("transparent");
        setTimeout(arguments.callee, 10 * 1000);
    })();

    (function () {
        jQuery.getJSON("/weather", function (data) {
            $("#tempval").text(parseFloat(data.currently.temperature).toFixed(1))
        });
        setTimeout(arguments.callee, 10 * 60 * 1000);
    })();

    jQuery("body").click(function () {
        location.reload();
    });

});
