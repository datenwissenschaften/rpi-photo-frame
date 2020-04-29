jQuery(document).ready(function () {

    function setRandomImage() {
        $("#image").attr("src", "/random?" + Math.round(new Date().getTime() / 1000));
    }

    function setImage(data) {
        $("#image").attr("src", "/image/" + data);
    }

    (function () {
        setRandomImage();
        setTimeout(arguments.callee, 60 * 60 * 1000);
    })();

    (function () {
        jQuery("#time").text(moment().format('DD.MM.YYYY HH:mm'));
        setTimeout(arguments.callee, 60 * 1000);
    })();

    (function () {
        jQuery.getJSON("/weather", function (data) {
            // Temperature value
            jQuery("#tempval").text(parseFloat(data.currently.temperature).toFixed(1))
            // Temperature icon
            const tempSelector = jQuery("#tempicon")
            tempSelector.removeClass();
            tempSelector.addClass("wi");
            let icon = data.currently.icon;
            if (icon.includes("partly-cloudy")) {
                icon = "day-cloudy";
            }
            if (icon.includes("clear")) {
                icon = "day-sunny";
            }
            tempSelector.addClass("wi-" + icon);
        });
        setTimeout(arguments.callee, 10 * 60 * 1000);
    })();

    // noinspection JSUnresolvedFunction
    const socket = io();
    socket.on('connect', function () {
    });
    socket.on('command', function (data) {
        if (data.data === 'next') {
            setRandomImage();
        }
    });
    socket.on('image', function (data) {
        setImage(data.data);
    });
    socket.on('disconnect', function () {
    });

});
