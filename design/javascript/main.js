$(function () {
    $('.download-format-select').change(function () {
        $('.download-link').hide();
        $('.' + $(this).val()).show();
        $('.format-all').show();
    });

    $('.toggle-all-formats').click(function () {
    	if ($(this).is(':checked')) {
    		$('.download-link').show();
    		$('.download-format-select').prop('disabled', true);
    	} else {
    		$('.download-format-select').prop('disabled', false);
    		$('.download-format-select').trigger('change');
    	}
    });

    $('.download-link').hide();
    $('.format-read').show();
    $('.format-all').show();
});