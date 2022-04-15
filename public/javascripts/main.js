jQuery(document).ready(function () {

    function setRandomImage() {
        jQuery("#image").attr("src", "/photo?" + Math.round(new Date().getTime() / 1000));
    }

    function setImage(data) {
        jQuery("#image").attr("src", "/photo?photo=" + data);
    }

    function sendToast(data) {
        console.log(data);
        toastr.options = {
            "closeButton": false,
            "debug": false,
            "newestOnTop": true,
            "progressBar": true,
            "positionClass": "toast-top-center",
            "preventDuplicates": true,
            "onclick": null,
            "showDuration": "300",
            "hideDuration": "1000",
            "timeOut": "0",
            "extendedTimeOut": "0",
            "showEasing": "swing",
            "hideEasing": "linear",
            "showMethod": "fadeIn",
            "hideMethod": "fadeOut",
            "escapeHtml": false
        };
        toastr.success("<p>" + data + "</p>");
    }

    (function () {
        setRandomImage();
        setTimeout(arguments.callee, 60 * 60 * 1000);
    })();

    (function () {
        jQuery("#time").text(moment().format("DD.MM.YYYY HH:mm"));
        setTimeout(arguments.callee, 60 * 1000);
    })();

    (function () {
        jQuery.getJSON("/weather", function (data) {
            // Temperature value
            jQuery("#tempval").text(parseFloat(data.currently.temperature).toFixed(1));
            // Temperature icon
            const tempSelector = jQuery("#tempicon");
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
    const socket = new ReconnectingWebSocket("ws://localhost:9000/ws", null, {debug: true, reconnectInterval: 3000});
    socket.open();
    socket.onopen = function () {
        jQuery("#image").click(function () {
            setRandomImage();
        });
    };
    socket.onmessage = function (event) {
        const data = JSON.parse(event.data);
        console.log(data);
        if (data.type === "next") {
            setRandomImage();
        }
        if (data.type === "photo") {
            setImage(data.data);
        }
        if (data.type === "toast") {
            sendToast(data.message);
        }
    };
    socket.onclose = function () {
    };
    // socket.on("command", function (data) {
    //     if (data.data === "next") {
    //         setRandomImage();
    //     }
    // });
    // socket.on("toast", function (data) {
    //     const options = {
    //         settings: {
    //             duration: 8 * 60 * 60 * 1000
    //         },
    //         style: {
    //             main: {
    //                 "font": "48px Sans-Serif;"
    //             }
    //         }
    //     };
    //     // noinspection JSUnresolvedVariable,JSUnresolvedFunction
    //     iqwerty.toast.Toast(data.data, options);
    // });
    // socket.on("image", function (data) {
    //     setImage(data.data);
    // });
    // socket.on("disconnect", function () {
    // });

});
