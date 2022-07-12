$(document).on('turbolinks:load', function(){
    $('.votes').on('ajax:success', function(e) {
        var rating = e.detail[0].rating;
        var resourceName = e.detail[0].resource_name;
        var resourceId = e.detail[0].resource_id;
        $('#' + resourceName + '_' + resourceId + '_rating').html(rating);
    })
});