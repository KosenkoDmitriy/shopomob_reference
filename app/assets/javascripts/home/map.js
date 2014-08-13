var ready;
var geocoder;
var map;

//ready = function() {
//
//};
//$(document).ready(ready);
//$(document).on('page:load', ready);
//$(document).on('page:change', ready);
function loadScript() {
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = 'https://maps.googleapis.com/maps/api/js?language=ru&' +
        'callback=initialize';
    document.body.appendChild(script);
}

window.onload = loadScript;
loadScript();
google.maps.event.addDomListener(window, 'load', initialize);

function initialize() {
    var map_canvas = document.getElementById('map_canvas');

    var destination = new google.maps.LatLng(43.0167, 44.6500)
    var map_options = {
        center: destination,
        zoom: 16,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    map = new google.maps.Map(map_canvas, map_options);

    codeAddressTo();
    calcRoute();
}

function codeAddressTo() {
    geocoder = new google.maps.Geocoder();

//        var element = document.getElementById("address").firstChild;
//        address = element.textContent || element.innerText || "";

//        var address = $("#addressTo").attr('value');
//        console.log("to: "+address);

    var addresses = $(".addressTo").map(function(){
        return $(this).attr("value");
    }).get();

    for (var i in addresses) {
        var address = addresses[i];
        geocoder.geocode( { 'address': address}, function(results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                map.setCenter(results[0].geometry.location);
                var marker = new google.maps.Marker({
                    map: map,
                    position: results[0].geometry.location
                });
            } else {
                //                alert("Geocode was not successful for the following reason: " + status);
//                alert("Организация не найдена. Ошибка: " + status);
            }
        });
    }
}

function calcRoute() {

    var directionsService = new google.maps.DirectionsService();

//        var start = document.getElementById('start').value;
//        var end = document.getElementById('end').value;

    var addresses = $(".addressTo").map(function(){
        return $(this).attr("value");
    }).get();
    var addressFrom = $("#addressFrom").val();
//    var addressTo = $("#addressTo").attr('value');

    for (var i in addresses) {
        var addressTo = addresses[i];
        var request = {
            origin:addressFrom,
            destination:addressTo,
            travelMode: google.maps.TravelMode.DRIVING
        };
        directionsService.route(request, function(response, status) {
            if (status == google.maps.DirectionsStatus.OK) {
//                console.log("route:"+addressTo);
                renderDirections(response);
            }
        });
    }
}

function renderDirections(result) {
    var directionsRenderer = new google.maps.DirectionsRenderer();
    directionsRenderer.setMap(map);
    directionsRenderer.setDirections(result);
}
