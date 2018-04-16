$(function(){
    $('#data-datatables').DataTable();
    $(document).foundation();

    $('.create-match').click(function(event){
        event.preventDefault();
        var location_id,strength_ids,opponent_id, weakness_ids, result, notes_to_self, match_datetime, team ,season, post_match_notes, league;
        location_id = $('#new_location_id').val();
        strength_ids = $('#new_strengths_ids').val();
        weakness_ids = $('#new_weaknesses_ids').val();
        result = $('#new_results_array').val();;
        notes_to_self = $('#new_note_to_self').text();
        opponent_id = $('#new_opponent_id').val();
        match_datetime = $('#new_match_datetime').val();
        team = $('#new-team').val();
        season = $('#new-season').val();
        league = $('#new-league').val();
        post_match_notes = $('#post_match_notes').text();
        $.ajax({
                url: '/matches',
                dataType: 'json',
                type: 'POST',
                data:{
                    opponent_id: opponent_id,
                    location_id: location_id,
                    strength_ids: strength_ids,
                    weakness_ids: weakness_ids,
                    result: result,
                    notes_to_self: notes_to_self,
                    post_match_notes: post_match_notes,
                    match_datetime: match_datetime,
                    team: team,
                    season: season,
                    league: league
                },
                success: function (data) {
                    if(data['match_id']){
                        console.log("Success saving match",data);
                        location.pathname ='/matches/' + data['match_id'] + '?new_match=true';
                    }
                },
                error: function(err){
                    console.log("Failure saving match",err);
                }
            })
    })

    $('.new-results').click(function(element){
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            reattachNewResultHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/-1/result.html').done(function(resp){
            modal.html(resp).foundation('open');
        });
    })

    $('.new-strengths').click(function(element){
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachStrengthResultHandlers');
            reattachNewStrengthResultHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/-1/strengths.html').done(function(resp){
            modal.html(resp).foundation('open');
            $("#location").focus();
        })
    })

    $('.new-weaknesses').click(function(element){
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachWeaknessResultHandlers');
            reattachNewWeaknessResultHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/-1/weaknesses.html').done(function(resp){
            modal.html(resp).foundation('open');
            $("#location").focus();
        })
    })

    $('.new-note_to_self').click(function(element){
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachNotesToSelfHandlers');
            reattachNewNoteToSelfHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/-1/note_to_self.html').done(function(resp){
            modal.html(resp).foundation('open');
            $("#note-to-self").focus();
        })
    })

    $('.new-post-match-notes').click(function(element){
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            reattachPostMatchNotesHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/-1/post_match_notes.html').done(function(resp){
            modal.html(resp).foundation('open');
            $("#post-match-notes").focus();
        })
    })

    $('.new-opponent').click(function(element){
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachNewOpponentHandlers');
            reattachNewOpponentHandlers();
            $("#opponent").focus();
            $('.update-opponent')[0].disabled = true;
            $("#search")[0].disabled = true;
        });
        var modal = $("#form-modal");
        $.ajax('/matches/-1/opponents.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    $('.new-location').click(function(element){
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachLocationHandlers');
            reattachNewLocationHandlers();
            $("#location").focus();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/-1/location.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    var reattachNewLocationHandlers = function() {
        $("#location").keyup(function(event){
            event.preventDefault();
            var query = $('#location').val();
            $.ajax(
                '/matches/-1/search_locations.html?query=' + query
            ).done(function(resp){
                $(".search-results").html(resp);
                $(".search-results").height('110px');
                reattachNewLocationSearchHandlers();
            })
        })
        $('.update-location').click(function(event) {
            event.preventDefault();
            var location_id = $("#location-id").val();
            $('#new-location').val($("#location").val());
            $('#new_location_id').val(location_id);
            $("#form-modal").foundation('close');
        })
        $('.cancel-update').click(function(event) {
            event.preventDefault();
            $("#form-modal").foundation('close');
        })

    }

    var reattachNewLocationSearchHandlers = function(){
        $(".update-location option").click(function(e){
            $("#new_location_id").val(e.target.value);
            $("#location-id").val(e.target.value);
            $("#location").val(e.target.text);
            $(".search-results").html("");
            $(".search-results").height('10px');
        })
    }

    var reattachNewOpponentHandlers = function() {
        $("#search").click(function(event){
            event.preventDefault();
            var query = $('#opponent').val();
            $("#searchingModal").foundation('open');
            $.ajax(
                '/matches/-1/search_opponents.html?query=' + query
            ).done(function(resp){
                $(".search-results").html(resp);
                $(".search-results").height('110px');
                reattachNewSearchHandlers();
                $("#searchingModal").foundation('close');
                $("#form-modal").foundation('open');
            })
        })
        $('#opponent').keyup(function(ev){
            if($("#opponent").val() && $("#opponent").val().split(' ').length > 1 && $("#opponent").val().split(' ')[1].length > 2){
                $("#search")[0].disabled = false;
            } else {
                $("#search")[0].disabled = true;
            }
        });
        $('.update-opponent').click(function(event) {
            event.preventDefault();
            var opponent_id = $("#opponent-id").val();
            var opponent_name = $("#opponent").val();
            $("#new-opponent").val(opponent_name);
            $("#new_opponent_id").val(opponent_id);
            $("#form-modal").foundation('close');
        })
        $('.cancel-update').click(function(event) {
            event.preventDefault();
            $("#form-modal").foundation('close');
        })
    }

    var reattachNewSearchHandlers = function(){
        $(".update-opponent option").click(function(e){
            $("#opponent-id").val(e.target.value);
            $("#opponent").val(e.target.text);
            $(".search-results").html("");
            $(".search-results").height('10px');
            $('.update-opponent')[0].disabled = false;
        })
    }

    var reattachNewNoteToSelfHandlers = function(){
        $('.update-note-to-self').click(function(event) {
            event.preventDefault();
            var note_to_self = $("#note-to-self")[0].value;
            $("#form-modal").foundation('close');
        })
        $('.cancel-update').click(function(event) {
            event.preventDefault();
            $("#form-modal").foundation('close');
        })

    }

    var reattachPostMatchNotesHandlers = function(){
        $('.update-post-match-notes').click(function(event) {
            event.preventDefault();
            var post_match_notes = $("#post-match-notes")[0].value;
            $("#form-modal").foundation('close');
        })
        $('.cancel-update').click(function(event) {
            event.preventDefault();
            $("#form-modal").foundation('close');
        })

    }


    var reattachNewResultHandlers = function(){
        $('.update-match').click(function(event) {
            event.preventDefault();
            var i = 0;
            var home_scores = $(".home-score");
            var aways_scores = $(".away-score");
            var number_of_scores = home_scores.length;
            var result_string = [];
            while(i <number_of_scores){
                // is it a valid score
                if(home_scores[i].selectedIndex && aways_scores[i].selectedIndex){
                    result_string.push(home_scores[i].value + '-' + aways_scores[i].value);
                }
                i = i + 1;
            }
            $("#form-modal").foundation('close');
            console.log('result = ' + result_string.join(','));
            $('#new-results').val(result_string.join(','));
            $("#new_results_array").val(result_string.join(','));
        });

        $('.cancel-update').click(function(event){
            event.preventDefault();
            console.log("Close modal");
            $("#form-modal").foundation('close');
        });
        $(document).foundation();
    }

    var reattachNewStrengthResultHandlers = function(){
        $('.update-strengths').click(function(event) {
            event.preventDefault();
            var selectedOptions = [],selectedOptionsText = []
                optsSelected = $(".edit-strengths")[0].selectedOptions,
                i = 0;
            while(i < optsSelected.length){
                selectedOptions.push(optsSelected[i].value);
                selectedOptionsText.push(optsSelected[i].innerText);
                i = i + 1;
            }
            $("#new-strengths").val(selectedOptionsText.join(','))
            $("#new_strengths_ids").val(selectedOptions.join(','))
            $("#form-modal").foundation('close');
        })
        $('.cancel-update').click(function(event) {
            event.preventDefault();
            $("#form-modal").foundation('close');
        })
    }

    var reattachNewWeaknessResultHandlers = function(){
        $('.update-weaknesses').click(function(event) {
            event.preventDefault();
            var selectedOptions = [],selectedOptionsText = [],
                optsSelected = $(".edit-weaknesses")[0].selectedOptions,
                i = 0;
            while(i < optsSelected.length){
                selectedOptions.push(optsSelected[i].value);
                selectedOptionsText.push(optsSelected[i].innerText);
                i = i + 1;
            }
            $("#new-weaknesses").val(selectedOptionsText.join(','))
            $("#new_weaknesses_ids").val(selectedOptions.join(','))
            $("#form-modal").foundation('close');
        })
        $('.cancel-update').click(function(event) {
            event.preventDefault();
            $("#form-modal").foundation('close');
        })
    }

  var attachNewDateHandler = function(){
    flatpickr("#new_match_datetime", {
      enableTime: true,
      altInput: true,
      plugins: [new confirmDatePlugin({})]
    });
  }
  attachNewDateHandler();
})