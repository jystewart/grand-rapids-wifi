jQuery(document).ready(function() {
	jQuery("#comment-form").ajaxForm({
	   dataType: 'script',
	   beforeSend: function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");}
	});
	jQuery('#ratings-form').submit(function() {
		var user_input = 0
     for (i = 0; i < this.elements['vote[rating]'].length; i++) {
			if (this.elements['vote[rating]'][i].checked) {
				user_input = this.elements['vote[rating]'][i].value;
				break;
        }
     }
     if (user_input == 0) {
			alert('You must select a rating before submitting');
			return false;
     }
     return true;
	});
});