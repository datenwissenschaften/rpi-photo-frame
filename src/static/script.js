jQuery(document).ready(function() {

    (function() {
        $("#time").text(moment().format('DD.MM.YYYY HH:mm'));
        setTimeout(arguments.callee, 10000);
    })();

    jQuery.getJSON("http://" + location.hostname + ":6060/", function(data) {

        async.detect(data, function(sensor, callback) {
            callback(null, sensor.uid === 'OutdoorTemperature');
        }, function(err, result) {
            $("#tempval").text(result.value);
        });

    });


});
