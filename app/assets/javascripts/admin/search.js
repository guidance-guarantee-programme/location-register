$(function() {
  'use strict';

  function formatLocation(location) {
    if (location.text === '' || location.element === undefined) {
      return null;
    }

    var className = $(location.element).data('hidden') ? 'location__hidden' : 'location__visible';

    return $('<div class="' + className + '">' + location.text + '</div>');
  }

  $('#search')
    .select2({
      templateResult: formatLocation,
      templateSelection: formatLocation
    })
    .on('change', function() {
      window.location = '/admin/locations/' + $(this).val();
    });
});
