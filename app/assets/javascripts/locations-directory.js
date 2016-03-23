$(function(){
  $('.js-submit-form').change(
    function() { $(this).parents('form').submit() }
  );
});
