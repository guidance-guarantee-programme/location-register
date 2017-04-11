(function() {
  'use strict';

  var locations = [],
    geocoder,
    map,
    markers = [],
    infoWindows = [],
    lookupMarker;

  function getJSON(url, cb) {
    var xmlHttp = new XMLHttpRequest();

    xmlHttp.onreadystatechange = function() {
      if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
        cb(JSON.parse(xmlHttp.responseText));
      }
    };

    xmlHttp.open('GET', url, true);
    xmlHttp.send();
  }

  function closeInfoWindows() {
    var i;
    for (i in infoWindows) {
      infoWindows[i].close();
    }
  }

  function showNearestMarker(latLng) {
    var closest,
      closestDistance = false,
      i, m;

    for (i in markers) {
      m = markers[i];
      var distance = google.maps.geometry.spherical.computeDistanceBetween(latLng, m.position);
      if (closestDistance === false || distance < closestDistance) {
        closest = m;
        closestDistance = distance;
      }
    }

    if (closest) {
      closeInfoWindows();
      new google.maps.event.trigger(closest, 'click');
    }
  }

  window.lookupAddress = function() {
    var address = document.getElementById('address').value;

    geocoder.geocode({'address': address}, function(results, status) {
      if (status === google.maps.GeocoderStatus.OK) {
        map.setCenter(results[0].geometry.location);

        if (lookupMarker) {
          lookupMarker.setMap(null);
        }

        lookupMarker = new google.maps.Marker({
          map: map,
          position: results[0].geometry.location,
          icon: {
            path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
            scale: 5
          }
        });

        showNearestMarker(results[0].geometry.location);
      } else {
        alert('Geocode was not successful for the following reason: ' + status);
      }
    });
  };

  function makeHandler(marker, content) {
    var infoWindow = new google.maps.InfoWindow({
      content: content
    });
    infoWindows.push(infoWindow);

    return function() {
      closeInfoWindows();
      infoWindow.open(map, marker);
    };
  }

  function contentForLocation(l) {
    var elements = [
      '<b>', l['title'] + ' Citizens Advice', '</b>',
      '<p>', l['address'].replace(/(?:\r\n|\r|\n)/g, '<br />'), '</p>'
    ];

    if (l['booking_centre'] && l['booking_centre'] !== l['title']) {
      elements.push(
        '<p><b>Booking Centre Details</b></p>',
        '<p>', l['booking_centre'] + ' Citizens Advice', '</p>'
      );
    }

    elements.push(
      '<p>', l['hours'].replace(/(?:\r\n|\r|\n)/g, '<br />'), '</p>',
      l['phone']
    );

    return elements.join('\n');
  }

  function placeMarkers() {
    var i, l, content;
    for (i in locations) {
      l = locations[i];
      content = contentForLocation(l);

      markers[i] = new google.maps.Marker({
        position: new google.maps.LatLng(l['lat'], l['lng']),
        map: map,
        title: l['title']
      });

      google.maps.event.addListener(markers[i], 'click', makeHandler(markers[i], content));
    }
  }

  function parseGeoJSON(geojson) {
    function findLocationProperties(locations, id) {
      var i;
      for (i in locations) {
        if (locations[i]['id'] === id) {
          return locations[i]['properties'];
        }
      }
    }

    var
      results = [],
      features = geojson['features'],
      feature, coordinates, location, i;

    for (i in features) {
      feature = features[i];
      coordinates = feature['geometry']['coordinates'];
      location = feature['properties'];

      location['lng'] = coordinates[0];
      location['lat'] = coordinates[1];

      var bookingLocationId = location['booking_location_id'];

      if (bookingLocationId && bookingLocationId !== '') {
        var bookingLocation = findLocationProperties(features, bookingLocationId);
        if (bookingLocation) {
          location['hours'] = bookingLocation['hours'];
          location['booking_centre'] = bookingLocation['title'];

          if (location['phone'] === '') {
            location['phone'] = bookingLocation['phone'];
          }
        }
      }

      results.push(location);
    }

    return results;
  }

  function initialise() {
    geocoder = new google.maps.Geocoder();

    var latLng = new google.maps.LatLng(51.5073509, -0.12775829999998223);

    map = new google.maps.Map($('.google-maps__canvas')[0], {
      zoom: 8,
      center: latLng
    });

    getJSON('/locations.json', function(json) {
      locations = parseGeoJSON(json);
      placeMarkers();
    });
  }

  google.maps.event.addDomListener(window, 'load', initialise);
})();
