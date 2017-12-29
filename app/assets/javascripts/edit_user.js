$(function(){
  var update_user = function(){
      $.ajax({
          url: '/users/' + $('#user-id').val(),
          type: 'PUT',
          dataType: 'json',
          data: {
              name: $("#name").val(),
              club_id: $("#club-id").val(),
              email:  $("#email").val(),
              city:  $("#city").val(),
              state:  $("#state").val(),
              zipcode:  $("#zipcode").val(),
              usta_number: $("#usta_number").val()
          },
          success: function(data){
              alert("Updated details successfully");
              window.location.reload();
          },
          error: function (data) {
              alert("Failed to update");
          }
      })
  }

  $("#update-existing-user").click(function(e){
     e.preventDefault();
     update_user();
  });

  var attachClubSearchHandlers = function() {
      $("#club").click(function (event) {
          $('#form-modal').bind('open.zf.reveal', function () {
              console.log('reattachLocationHandlers');
              reattachClubLocationHandlers();
          });
          var modal = $("#form-modal");
          $.ajax('/matches/-1/location.html').done(function (resp) {
              modal.html(resp).foundation('open');
          })
      })
  }
  var reattachClubLocationHandlers = function(){
      $("#location").keyup(function(event){
          event.preventDefault();
          var query = $('#location').val();
          $.ajax(
              '/matches/-1/search_locations.html?query=' + query
          ).done(function(resp){
              $(".search-results").html(resp);
              $(".search-results").height('110px');
              $(".update-location option").click(function(e){
                  $("#club-id").val(e.target.value);
                  $("#club").val(e.target.text);
                  $(".search-results").html("");
                  $(".search-results").height('10px');
                  var modal = $("#form-modal");
                  modal.foundation('close');
              })
          })
      })

  }

  attachClubSearchHandlers();
})