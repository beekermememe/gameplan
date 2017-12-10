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
        $('#form-modal').bind('opened', function() {
            reattachResultHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/' + match_id + '/result.html').done(function(resp){
            modal.html(resp).foundation('open');
        });
    })

    $('.strengths').click(function(element){
        var match_id = $(".match-details")[0].id;
        $('#form-modal').bind('opened', function() {
            reattachStrengthResultHandlers();
        });
        var modal = $("#form-modal");
        $.ajax('/matches/' + match_id + '/strengths.html').done(function(resp){
            debugger;
            modal.html(resp).foundation('open');
        })
    })

    var reattachResultHandlers = function(){
        $('.update-match').click(function(event) {
            event.preventDefault();
            var match_id = $(".match-details")[0].id;
            var setInfo = [], i = 0;
            var home_scores = $(".set .home-score");
            var aways_scores = $(".set .away-score");
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
                    $("#form-modal").foundation('reveal', 'close');
                    }
                }
            );
        });

        $('.cancel-update').click(function(event){
            event.preventDefault();
            console.log("Close modal");
            $("#form-modal").foundation('reveal', 'close');
        });
        $(document).foundation();
    }

    var reattachStrengthResultHandlers = function(){

    }
})