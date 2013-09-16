window.userFriendships = [];

$(document).ready(function() {
	$.ajax({
    	url: Routes.user_friendships_path({format: 'json'}),
    	dataType: 'json',
    	type: 'GET',
    	success: function(data) {
      		window.userFriendships = data;
    	}
	});
	$('#add-friendship').click(function(event) {
	  event.preventDefault();
	  var addFriendshipBtn = $(this);  
	  var BlockBtn = $('#block-user');
	  $.ajax({
	    url: Routes.user_friendships_path({user_friendship: {friend_id: addFriendshipBtn.data('friendId')}}),
	    dataType: 'json',
	    type: 'POST',
	    success: function(e) {
	      addFriendshipBtn.hide();
		  BlockBtn.hide();
	      $('#friend-status').html("<a href='#' class='btn btn-success'>Friendship Requested</a>");
	    }
	  });
	});
	
	$('#block-user').click(function(event) {
	  event.preventDefault();
	  var BlockBtn = $(this);

	  $.ajax({
	    url: Routes.user_block_path((BlockBtn.data('friendId'))),
	    dataType: 'json',
	    type: 'POST',
	    success: function(e) {
	      BlockBtn.hide();
	      $('#friend-status').html("<a href='#' class='btn btn-success'>Blocked User</a>");
	    }
	  });
	});
});