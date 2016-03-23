$(function(){
  $('.display-locations__display-hidden, .display-locations__display-active, .pagination__checkbox').change(
    function() { $(this).parents('form').submit() }
  );
});
