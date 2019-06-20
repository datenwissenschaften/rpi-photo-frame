jQuery(document).ready(function () {

    function setNewImage() {
        jQuery.getJSON("/random", function (data) {
            $("#image").attr("src", "/image/" + data.file_name);
        });
    }

    (function () {
        setNewImage();
        setTimeout(arguments.callee, 60 * 60 * 1000);
    })();

    (function () {
        jQuery("#time").text(moment().format('DD.MM.YYYY HH:mm'));
        setTimeout(arguments.callee, 60 * 1000);
    })();

    (function () {
        jQuery.getJSON("/weather", function (data) {
            jQuery("#tempval").text(parseFloat(data.currently.temperature).toFixed(1))
        });
        setTimeout(arguments.callee, 10 * 60 * 1000);
    })();

    jQuery("#image").click(function () {
        jQuery.ajax({
            url: "/backlight",
            type: "POST",
            data: JSON.stringify({ "switch": true }),
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function () {
                setNewImage();
            }
        });
    });

    jQuery("#off").click(function () {
        jQuery.ajax({
            url: "/backlight",
            type: "POST",
            data: JSON.stringify({ "switch": false }),
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function () {
            }
        });
    });

    var socket = io();
    socket.on('connect', function(){
        console.log("CONNECTED!")
    });
    socket.on('image', function(data){
        console.log(data)
    });
    socket.on('disconnect', function(){
        console.log("DISCONNECTED!")
    });

});
