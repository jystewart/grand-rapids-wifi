$(document).ready(function() {
	$new_link = $('<p><a id="add-new-time">Add new</a></p>');
	$new_link.insertAfter($('#opening-times'));
	
	$new_link.click(function() {
		new_index = $("#opening-times").children('li').length;
		var $copy = $('#opening-times').children('li:last').clone();
		$copy.children('select').each(function (index, node) {
			$(node).attr({
				id: node.id.replace(new_index - 1, new_index),
				name: node.name.replace(new_index - 1, new_index)
			});
		});
		$('#opening-times').append($copy);
		return false;
	})
});
