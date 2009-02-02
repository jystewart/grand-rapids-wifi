$(document).ready(function() {
	$('table tbody tr:even').css({'background-color': '#eee'});
	
	$('table thead tr').each(function(ref, element) {
		$new_checkbox = $('<input type="checkbox" id="master-checkbox" />');
		$new_checkbox.click(function(event) {
			if (event.target.checked) {
				$('table tbody tr input[type=checkbox]').attr('checked', true);
			} else {
				$('table tbody tr input[type=checkbox]').attr('checked', false);
			}
		});
		$new_elems = $new_checkbox.wrap('<td></td>');
		$new_elems.insertAfter(element.childNodes[0]);
	});
	
	$('table tbody tr').each(function(ref, element) {
		var ident = element.getAttribute('id').replace(/comment-row-/, '');
		
		$new_elems = $('<td><input type="checkbox" name="ids[]" value="' + ident + '"></td>');
		$new_elems.insertAfter(element.childNodes[0]);
	});
	
	$('table tbody tr td form').each(function(ref, element) {
		var action = element.getAttribute('action');
		$element = $(element);
		var button = $element.find('input[type=submit]');
		var string = button[0].getAttribute('value');
		var click_elem = $('<a>' + string + '</a>');
		if (string == 'Delete') {
			click_elem.click(function() {
				$.ajax({
					url: action, 
					type: 'DELETE', 
					dataType: "script", 
					beforeSend: function(xhr) { xhr.setRequestHeader("Accept", "text/javascript"); }
				});
			});
		} else {
			click_elem.click(function() {
				$.ajax({
					url: action, 
					type: 'POST', 
					dataType: "script",
					beforeSend: function(xhr) { xhr.setRequestHeader("Accept", "text/javascript"); }
				});
			});
		}
		click_elem.insertBefore(button);
		button.remove();
	});
	
	$('table').wrap('<form method="post" action="/comments/bulk" id="bulk-edit">');
	buttons = $('<p><strong>Bulk edit:</strong> <input type="submit" name="act" value="Delete" />' +
		' <input type="submit" name="act" value="Spam" />' +
		' <input type="submit" name="act" value="Reprieve" /></p>');
	$('#bulk-edit table').after(buttons);
	$('#bulk-edit table').before(buttons.clone());
})