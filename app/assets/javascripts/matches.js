$(function(){
    $('#data-datatables').DataTable();
    $(document).foundation();

    $(".match-data").click(function(e){
        e.preventDefault();
        var href = e.target.dataset.href;
        var modal = $("#match_opponent");
        $.ajax(href).done(function(resp){
            modal.html(resp).foundation('open');
        })
    });

    $('.view-match').click(function(element){
        var match_id = element.target.id.split('-id-')[1];
        location.pathname = '/matches/' + match_id;
    });

    $('.results').click(function(element){
        var match_id = $(".match-details")[0].id;
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            reattachResultHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/' + match_id + '/result.html').done(function(resp){
            modal.html(resp).foundation('open');
        });
    })

    $('.strengths').click(function(element){
        var match_id = $(".match-details")[0].id;
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachStrengthResultHandlers');
            reattachStrengthResultHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/' + match_id + '/strengths.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    $('.weaknesses').click(function(element){
        var match_id = $(".match-details")[0].id;
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachWeaknessResultHandlers');
            reattachWeaknessResultHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/' + match_id + '/weaknesses.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    $('.note_to_self').click(function(element){
        var match_id = $(".match-details")[0].id;
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachNotesToSelfHandlers');
            reattachNoteToSelfHandlers();
            $("#note-to-self").focus();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/' + match_id + '/note_to_self.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    $('.post_match_notes').click(function(element){
        var match_id = $(".match-details")[0].id;
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            reattachPostMatchNotesHandlers();
            $("#note-to-self").focus();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/' + match_id + '/post_match_notes.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    $('.team').click(function(element){
        var match_id = $(".match-details")[0].id;
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachNotesToSelfHandlers');
            reattachTeamHandlers();
            $("#team").focus();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/' + match_id + '/team.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    $('.league').click(function(element){
        var match_id = $(".match-details")[0].id;
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachLeagueHandlers');
            reattachLeagueHandlers();
            $("#league").focus();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/' + match_id + '/league.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    $('.season').click(function(element){
        var match_id = $(".match-details")[0].id;
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachSeasonHandlers');
            reattachSeasonHandlers();
            $("#season").focus();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/' + match_id + '/season.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    $('.opponent').click(function(element){
        var match_id = $(".match-details")[0].id;
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachOpponentHandlers');
            reattachOpponentHandlers();
            $('#opponent').focus();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/' + match_id + '/opponents.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    $('.opponent2').click(function(element){
        var match_id = $(".match-details")[0].id;
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            reattachOpponent2Handlers();
            $('#opponent').focus();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/' + match_id + '/opponents.html?opponents2=true').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    $('.location').click(function(element){
        var match_id = $(".match-details")[0].id;
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachLocationHandlers');
            reattachLocationHandlers();
            $('#location').focus();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/' + match_id + '/location.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    var reattachLocationHandlers = function() {
        $("#location").keyup(function(event){
            event.preventDefault();
            var match_id = $(".match-details")[0].id;
            var query = $('#location').val();
            $.ajax(
                '/matches/' + match_id + '/search_locations.html?query=' + query
            ).done(function(resp){
                $(".search-results").html(resp);
                $(".search-results").height('110px');
                reattachLocationSearchHandlers();
            })
        })
        $('.update-location').click(function(event) {
            var match_id = $(".match-details")[0].id;
            var location_id = $("#location-id").val();
            $.ajax({
                    url: '/matches/' + match_id,
                    type: 'PUT',
                    dataType: 'json',
                    data: {location: location_id},
                    success: function (data) {
                        console.log("Success changing location",data);
                        location.reload();
                    },
                    error: function(err){
                        console.log("Failure changing location",err);
                        $("#form-modal").foundation('close');
                    }
                }
            );

        })
    }
    var reattachLocationSearchHandlers = function(){
        $(".update-location option").click(function(e){
            $("#location-id").val(e.target.value);
            $("#location").val(e.target.text);
            $(".search-results").html("");
            $(".search-results").height('10px');
        })
    }

    var reattachOpponent2Handlers = function() {
        $(".search-opponent").click(function(event){
            event.preventDefault();
            var match_id = $(".match-details")[0].id;
            var query = $('#opponent2').val();
            $("#searchingModal").foundation('open')
            $.ajax(
                '/matches/' + match_id + '/search_opponents.html?query=' + query
            ).done(function(resp){
                $(".search-results").html(resp);
                $(".search-results").height('110px');
                reattachSearchHandlers();
                $("#searchingModal").foundation('close');
                $("#form-modal").foundation('open');
            })
        })
        $('.update-opponent').click(function(event) {
            var match_id = $(".match-details")[0].id;
            var opponent_id = $("#opponent-id").val();
            $.ajax({
                    url: '/matches/' + match_id,
                    type: 'PUT',
                    dataType: 'json',
                    data: {opponent2: opponent_id},
                    success: function (data) {
                        console.log("Success changing opponent",data);
                        location.reload();
                    },
                    error: function(err){
                        console.log("Failure changing opponent",err);
                        $("#form-modal").foundation('close');
                    }
                }
            );

        })
    }

    var reattachOpponentHandlers = function() {
        $(".search-opponent").click(function(event){
            event.preventDefault();
            var match_id = $(".match-details")[0].id;
            var query = $('#opponent').val();
            $("#searchingModal").foundation('open')
            $.ajax(
                '/matches/' + match_id + '/search_opponents.html?query=' + query
            ).done(function(resp){
                $(".search-results").html(resp);
                $(".search-results").height('110px');
                reattachSearchHandlers();
                $("#searchingModal").foundation('close');
                $("#form-modal").foundation('open');
            })
        })
        $('.update-opponent').click(function(event) {
            var match_id = $(".match-details")[0].id;
            var opponent_id = $("#opponent-id").val();
            $.ajax({
                    url: '/matches/' + match_id,
                    type: 'PUT',
                    dataType: 'json',
                    data: {opponent: opponent_id},
                    success: function (data) {
                        console.log("Success changing opponent",data);
                        location.reload();
                    },
                    error: function(err){
                        console.log("Failure changing opponent",err);
                        $("#form-modal").foundation('close');
                    }
                }
            );

        })
    }
    var reattachSearchHandlers = function(){
        $(".update-opponent option").click(function(e){
            $("#opponent-id").val(e.target.value);
            $("#opponent").val(e.target.text);
            $(".search-results").html("");
            $(".search-results").height('10px');
        })
    }

    var reattachNoteToSelfHandlers = function(){
        $('.update-note-to-self').click(function(event) {
            event.preventDefault();
            var match_id = $(".match-details")[0].id;
            var note_to_self = $("#note-to-self")[0].value;
            $.ajax({
                    url: '/matches/' + match_id,
                    type: 'PUT',
                    dataType: 'json',
                    data: {note_to_self: note_to_self},
                    success: function (data) {
                        console.log("Success changing note_to_self",data);
                        location.reload();
                    },
                    error: function(err){
                        console.log("Failure changing note_to_self",err);
                        $("#form-modal").foundation('close');
                    }
                }
            );

        })
    }

    var reattachPostMatchNotesHandlers = function(){
        $('.update-post-match-notes').click(function(event) {
            event.preventDefault();
            var match_id = $(".match-details")[0].id;
            var post_match_notes = $("#post-match-notes")[0].value;
            $.ajax({
                    url: '/matches/' + match_id,
                    type: 'PUT',
                    dataType: 'json',
                    data: {post_match_notes: post_match_notes},
                    success: function (data) {
                        console.log("Success changing post_match_notes",data);
                        location.reload();
                    },
                    error: function(err){
                        console.log("Failure changing post_match_notes",err);
                        $("#form-modal").foundation('close');
                    }
                }
            );

        })
    }

    var reattachSeasonHandlers = function(){
        $('.update-season').click(function(event) {
            event.preventDefault();
            var match_id = $(".match-details")[0].id;
            var season = $("#season-update")[0].value;
            $.ajax({
                    url: '/matches/' + match_id,
                    type: 'PUT',
                    dataType: 'json',
                    data: {season: season},
                    success: function (data) {
                        console.log("Success changing season",data);
                        location.reload();
                    },
                    error: function(err){
                        console.log("Failure changing season",err);
                        $("#form-modal").foundation('close');
                    }
                }
            );

        })
    }

    var reattachLeagueHandlers = function(){
        $('.update-league').click(function(event) {
            event.preventDefault();
            var match_id = $(".match-details")[0].id;
            var league = $("#league-update")[0].value;
            $.ajax({
                    url: '/matches/' + match_id,
                    type: 'PUT',
                    dataType: 'json',
                    data: {league: league},
                    success: function (data) {
                        console.log("Success changing league",data);
                        location.reload();
                    },
                    error: function(err){
                        console.log("Failure changing league",err);
                        $("#form-modal").foundation('close');
                    }
                }
            );

        })
    }

    var reattachTeamHandlers = function(){
        $('.update-team').click(function(event) {
            event.preventDefault();
            var match_id = $(".match-details")[0].id;
            var team = $("#team-update")[0].value;
            $.ajax({
                    url: '/matches/' + match_id,
                    type: 'PUT',
                    dataType: 'json',
                    data: {team: team},
                    success: function (data) {
                        console.log("Success changing team",data);
                        location.reload();
                    },
                    error: function(err){
                        console.log("Failure changing team",err);
                        $("#form-modal").foundation('close');
                    }
                }
            );

        })
    }

    var reattachResultHandlers = function(){
        $('.update-match').click(function(event) {
            event.preventDefault();
            var match_id = $(".match-details")[0].id;
            var setInfo = [], i = 0;
            var home_scores = $(".home-score");
            var aways_scores = $(".away-score");
            var number_of_scores = home_scores.length;
            while(i <number_of_scores){
                // is it a valid score
                if(home_scores[i].selectedIndex && aways_scores[i].selectedIndex){
                    setInfo.push({home: home_scores[i].value, away: aways_scores[i].value})
                }
                i = i + 1;
            }
            $.ajax({
                url: '/matches/' + match_id,
                type: 'PUT',
                dataType: 'json',
                data: {result: setInfo},
                success: function (data) {
                    console.log("Success changing score",data);
                    location.reload();
                    },
                error: function(err){
                    console.log("Failure changing score",err);
                    $("#form-modal").foundation('close');
                    }
                }
            );
        });

        $('.cancel-update').click(function(event){
            event.preventDefault();
            console.log("Close modal");
            $("#form-modal").foundation('close');
        });
        $(document).foundation();
    }

    var reattachStrengthResultHandlers = function(){
        $('.update-strengths').click(function(event) {
            event.preventDefault();
            var match_id = $(".match-details")[0].id;
            var selectedOptions = [],
                optsSelected = $(".edit-strengths")[0].selectedOptions,
                i = 0;
            while(i < optsSelected.length){
                selectedOptions.push(optsSelected[i].value);
                i = i + 1;
            }
            $.ajax({
                    url: '/matches/' + match_id,
                    type: 'PUT',
                    dataType: 'json',
                    data: {strengths: selectedOptions},
                    success: function (data) {
                        console.log("Success changing strengths",data);
                        location.reload();
                    },
                    error: function(err){
                        console.log("Failure changing strengths",err);
                        $("#form-modal").foundation('close');
                    }
                }
            );

        })
    }

    var reattachWeaknessResultHandlers = function(){
        $('.update-weaknesses').click(function(event) {
            event.preventDefault();
            var match_id = $(".match-details")[0].id;
            var selectedOptions = [],
                optsSelected = $(".edit-weaknesses")[0].selectedOptions,
                i = 0;
            while(i < optsSelected.length){
                selectedOptions.push(optsSelected[i].value);
                i = i + 1;
            }
            $.ajax({
                    url: '/matches/' + match_id,
                    type: 'PUT',
                    dataType: 'json',
                    data: {weaknesses: selectedOptions},
                    success: function (data) {
                        console.log("Success changing weaknesses",data);
                        location.reload();
                    },
                    error: function(err){
                        console.log("Failure changing weaknesses",err);
                        $("#form-modal").foundation('close');
                    }
                }
            );

        })
    }

    var attachDateHandler = function(){
      flatpickr("#match_datetime", {
        enableTime: true,
        altInput: true,
        plugins: [new confirmDatePlugin({})],
        onOpen: [
          function(selectedDates, dateStr, instance){
            var currentSelectedTime = $("#match_datetime").val();
            if(currentSelectedTime) {
              instance.setDate(currentSelectedTime);
            }
          }],
        onClose: function(selectedDates, dateStr, instance){
          var match_id = $(".match-details")[0].id;
          $.ajax({
                url: '/matches/' + match_id,
                type: 'PUT',
                dataType: 'json',
                data: {match_datetime: dateStr},
                success: function (data) {
                  console.log("Success changing strengths",data);
                  location.reload();
                },
                error: function(err){
                  console.log("Failure changing strengths",err);
                  $("#form-modal").foundation('close');
                }
              }
          );
        }
      });
    }
    attachDateHandler();
})