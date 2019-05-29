jQuery(document).ready(function () {

    (function () {
        $("#time").text(moment().format('DD.MM.YYYY HH:mm'));
        setTimeout(arguments.callee, 60 * 1000);
    })();

    (function () {
        if ($("#image1").hasClass("transparent")) {
            $("#image1").attr("src", "/photo?" + Math.random() * 2048 * 2048);
            setTimeout(function () {
                $("#image1").toggleClass("transparent");
                $("#image2").toggleClass("transparent");
            }, 2000);
        }
        if ($("#image2").hasClass("transparent")) {
            $("#image2").attr("src", "/photo?" + Math.random() * 2048 * 2048);
            setTimeout(function () {
                $("#image2").toggleClass("transparent");
                $("#image2").toggleClass("transparent");
            }, 2000);
        }
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
