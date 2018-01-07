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
})