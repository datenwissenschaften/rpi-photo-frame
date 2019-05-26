jQuery(document).ready(function() {

    (function() {
        $("#time").text(moment().format('DD.MM.YYYY HH:mm'));
        setTimeout(arguments.callee, 60000);
    })();

    jQuery.getJSON("https://api.darksky.net/forecast/9559aa7862d3ef0cf894d3593fde1b11/48.199760,11.308920?lang=de&units=si", function(data) {
        $("#tempval").text(data.currently.temperature)
    });

});
