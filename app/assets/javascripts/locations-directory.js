$(function() {
  'use strict';

  $('.js-submit-form').change(
    function() { $(this).parents('form').submit(); }
  );
});
