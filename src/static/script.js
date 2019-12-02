jQuery(document).ready(function () {

    function setNewImage() {
        jQuery.getJSON("/random", function (data) {
            $("#image").attr("src", "/image/" + data.file_name);
        });
    }

    function setImage(data) {
         $("#image").attr("src", "/image/" + data);
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
            // Temperature value
            jQuery("#tempval").text(parseFloat(data.currently.temperature).toFixed(1))
            // Temperature icon
            jQuery("#tempicon").removeClass();
            jQuery("#tempicon").addClass("wi");
            jQuery("#tempicon").addClass("wi-" + data.currently.icon);
        });
        setTimeout(arguments.callee, 10 * 60 * 1000);
    })();

    var socket = io();
    socket.on('connect', function(){
        console.log("CONNECTED!")
    });
    socket.on('image', function(data){
        console.log(data)
        setImage(data.data);
    });
    socket.on('command', function(data){
        console.log(data)
        if(data.data == 'next') {
            setNewImage();
        }
    });
    socket.on('disconnect', function(){
        console.log("DISCONNECTED!")
    });

});
