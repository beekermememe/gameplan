$(function(){
    $('.view-lesson').click(function (event) {
        event.preventDefault();
        var lesson_id = event.target.id.split('-id-')[1];
        location.pathname = '/lessons/' + lesson_id;
    })
    $('.cancel-lesson-update').click(function(event){
        event.preventDefault();
        location.pathname = '/lessons';
    })

    $('.coach').click(function(element){
        var lesson_id = $(".lesson-details")[0].id;
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachOpponentHandlers');
            reattachCoachHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/lessons/' + lesson_id + '/coaches.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })
    var reattachCoachHandlers = function() {
        $("#coach").keyup(function(event){
            event.preventDefault();
            var lesson_id = $(".lesson-details")[0].id;
            var query = $('#coach').val();
            $.ajax(
                '/lessons/' + lesson_id + '/coaches_search.html?query=' + query
            ).done(function(resp){
                $(".search-results").html(resp);
                $(".search-results").height('110px');
                reattachSearchHandlers();
            })
        })
        $('.update-coach').click(function(event) {
            var lesson_id = $(".lesson-details")[0].id;
            var coach_id = $("#coach-id").val();
            $.ajax({
                    url: '/lessons/' + lesson_id,
                    type: 'PUT',
                    dataType: 'json',
                    data: {coach_id: coach_id},
                    success: function (data) {
                        console.log("Success changing coach",data);
                        location.reload();
                    },
                    error: function(err){
                        console.log("Failure changing coach",err);
                        $("#form-modal").foundation('close');
                    }
                }
            );

        })
    }
    var reattachSearchHandlers = function(){
        $(".update-coach option").click(function(e){
            $("#coach-id").val(e.target.value);
            $("#coach").val(e.target.text);
            $(".search-results").html("");
            $(".search-results").height('10px');
        })
    }

    $('.lesson_notes').click(function(element){
        var lesson_id = $(".lesson-details")[0].id;
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachNotesHandlers');
            reattachNotesHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/lessons/' + lesson_id + '/player_notes.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })
    var reattachNotesHandlers = function(){
        $('.update-player-notes').click(function(event) {
            event.preventDefault();
            var lesson_id = $(".lesson-details")[0].id;
            var player_notes = $("#player-notes")[0].value;
            $.ajax({
                    url: '/lessons/' + lesson_id,
                    type: 'PUT',
                    dataType: 'json',
                    data: {notes: player_notes},
                    success: function (data) {
                        console.log("Success changing player-notes",data);
                        location.reload();
                    },
                    error: function(err){
                        console.log("Failure changing player-notes",err);
                        $("#form-modal").foundation('close');
                    }
                }
            );

        })
    }

    var attachLassonDateHandler = function(){
        flatpickr("#lesson_date", {
            enableTime: true,
            altInput: true,
            plugins: [new confirmDatePlugin({})],
            onOpen: [
                function(selectedDates, dateStr, instance){
                    var currentSelectedTime = $("#lesson_date").val();
                    if(currentSelectedTime) {
                        instance.setDate(currentSelectedTime);
                    }
                }],
            onClose: function(selectedDates, dateStr, instance){
                var lesson_id = $(".lesson-details")[0].id;
                $.ajax({
                        url: '/lessons/' + lesson_id,
                        type: 'PUT',
                        dataType: 'json',
                        data: {lesson_date: dateStr},
                        success: function (data) {
                            console.log("Success changing lesson_date",data);
                            location.reload();
                        },
                        error: function(err){
                            console.log("Failure changing lesson_date",err);
                            $("#form-modal").foundation('close');
                        }
                    }
                );
            }
        });
    }
    attachLassonDateHandler();
})