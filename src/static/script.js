jQuery(document).ready(function () {

    (function () {
        $("#time").text(moment().format('DD.MM.YYYY HH:mm'));
        setTimeout(arguments.callee, 60000);
    })();

    (function () {
        $("html").css('background-image', 'url("/photo")');
    })();

    (function () {
        jQuery.getJSON("/weather", function (data) {
            $("#tempval").text(parseFloat(data.currently.temperature).toFixed(1))
        });
        setTimeout(arguments.callee, 600000);
    })();

    jQuery("body").click(function () {
        location.reload();
    });

});
