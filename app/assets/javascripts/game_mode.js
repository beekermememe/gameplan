$(function(){
    $(".gm_disable").click(function(event){
        event.preventDefault();
        $.post('/game_mode/disable',function() {
            window.location = '/';
        })

    })
});