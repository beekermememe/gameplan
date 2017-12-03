$(function(){
    $('#data-datatables').DataTable();
    $(document).foundation();

    $('.view-match').click(function(element){
        var match_id = element.target.id.split('-id-')[1];
        location.pathname = '/matches/' + match_id;
    });

    $('.results').click(function(element){
        var match_id = $(".match-details")[0].id;
        var popup = $(".popup");
        $('#form-modal').bind('opened', function() {
            reattachResultHandlers();
        });
        $("#form-modal").foundation('reveal', 'open', {
            url: ('/matches/' + match_id + '/result.html')
        });
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
                    // $("#form-modal").foundation('reveal', 'close');
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

})