$(function(){
    $('#data-datatables').DataTable();
    $(document).foundation();

    $('.save-new-lesson').click(function(event){
        event.preventDefault();
        var coach_id,player_notes,lesson_datetime;
        coach_id = $('.new-lesson_coach')[0].id;
        player_notes = $('#new-lesson_notes').val();
        lesson_datetime = $('#new-lesson_date').val();
        $.ajax({
            url: '/lessons',
            dataType: 'json',
            type: 'POST',
            data:{
                coach_id: coach_id,
                notes: player_notes,
                lesson_datetime: lesson_datetime
            },
            success: function (data) {
                console.log("Success saving lesson",data);
                location.reload();
            },
            error: function(err){
                console.log("Failure saving lesson",err);
            }
        })
    })

    $('.new-coach').click(function(element){
        $('#form-modal').bind('open.zf.reveal', function() {
            console.log('reattachNewCoachHandlers');
            reattachNewCoachHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/lessons/-1/coaches.html').done(function(resp){
            modal.html(resp).foundation('open');
        })
    })

    var reattachNewCoachHandlers = function() {
        $(".search-coach").click(function(event){
            event.preventDefault();
            var query = $('#coach').val();
            $("#searchingModal").foundation('open');
            $.ajax(
                '/lessons/-1/coaches_search.html?query=' + query
            ).done(function(resp){
                $(".search-results").html(resp);
                $(".search-results").height('110px');
                reattachNewSearchHandlers();
                $("#searchingModal").foundation('close');
                $("#form-modal").foundation('open');
            })
        })
        $('.update-coach').click(function(event) {
            event.preventDefault();
            var coach_id = $("#coach-id").val();
            var coach_name = $("#coach").val();
            $(".new-lesson_coach")[0].value = coach_name;
            $(".new-lesson_coach")[0].id = coach_id;
            $("#form-modal").foundation('close');
        })
        $('.cancel-update').click(function(event) {
            event.preventDefault();
            $("#form-modal").foundation('close');
        })
    }

    var reattachNewSearchHandlers = function(){
        $(".update-coach option").click(function(e){
            $("#coach-id").val(e.target.value);
            $("#coach").val(e.target.text);
            $(".search-results").html("");
            $(".search-results").height('10px');
        })
    }

    var attachNewDateHandler = function(){
        flatpickr("#new-lesson_date", {
            enableTime: true,
            altInput: true,
            plugins: [new confirmDatePlugin({})]
        });
    }
    attachNewDateHandler();
})