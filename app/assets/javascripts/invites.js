
function invite_cb_changed(cb, person_id, meeting_id, invite_id) {
	//debugger;
	if (cb.checked) {
		//create new invite
		$.post(
			'invites', 
			{	person_id: person_id },
				function(response) {
					var msgType = response.type;
					var personId = response.person_id;
					var msgArr = response[msgType];
					var checked = response.saved;
					$("#msg-modal").first("div.modal-body").text(msgArr.toString());
					
					if (msgType == "error") {
						$("#msg-modal").addClass("alert");
						$("#msg-modal").addClass("alert-error");	
					} //TODO Handle other errors here
					
					$("#msg-modal").modal(response.modal_alert_display_val);
					
					//debugger;

					$("input#"+personId).prop('checked', checked); //uncheck if not saved
					
					
				}
			);
	} else {
		//destroy old invite
		$.ajax({
			url: 'invites/'+invite_id,
			type: 'DELETE',
			data: {id: invite_id}
		});
	}
}