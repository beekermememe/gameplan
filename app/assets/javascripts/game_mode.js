$(function(){
    $(".gm_disable").click(function(event){
        event.preventDefault();
        $.post('/game_mode/disable',function() {
            window.location = '/';
        })

    })
    $('.gm_strengths').click(function(element){
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachStrengthResultHandlers');
            reattachStrengthResultHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/game_mode/strengths.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    $('.gm_weaknesses').click(function(element){
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachWeaknessResultHandlers');
            reattachWeaknessResultHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/game_mode/weaknesses.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    $('.gm_note_to_self').click(function(element){
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachNotesToSelfHandlers');
            reattachNoteToSelfHandlers();
            $("#note-to-self").focus();
        });
        var modal = $("#form-modal");
        $.ajax('/game_mode/note_to_self.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    $('.gm_post_match_notes').click(function(element){
        $('#form-modal').off();
        $('#form-modal').bind('open.zf.reveal', function() {
            reattachPostMatchNotesHandlers();
            $("#note-to-self").focus();
        });
        var modal = $("#form-modal");
        $.ajax('/game_mode/post_match_notes.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    var reattachNoteToSelfHandlers = function(){
        $('.gm-update-note-to-self').click(function(event) {
            event.preventDefault();
            var note_to_self = $("#note-to-self")[0].value;
            $.ajax({
                    url: '/game_mode',
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
        $('.gm-update-post-match-notes').click(function(event) {
            event.preventDefault();
            var post_match_notes = $("#post-match-notes")[0].value;
            $.ajax({
                    url: '/game_mode',
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

    var reattachStrengthResultHandlers = function(){
        $('.gm-update-strengths').click(function(event) {
            event.preventDefault();
            var selectedOptions = [],
                optsSelected = $(".edit-strengths")[0].selectedOptions,
                i = 0;
            while(i < optsSelected.length){
                selectedOptions.push(optsSelected[i].value);
                i = i + 1;
            }
            $.ajax({
                    url: '/game_mode',
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
        $('.gm-update-weaknesses').click(function(event) {
            event.preventDefault();
            var selectedOptions = [],
                optsSelected = $(".edit-weaknesses")[0].selectedOptions,
                i = 0;
            while(i < optsSelected.length){
                selectedOptions.push(optsSelected[i].value);
                i = i + 1;
            }
            $.ajax({
                    url: '/game_mode',
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

});