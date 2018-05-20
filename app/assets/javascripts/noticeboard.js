$(function(){
    $(".gm_enable").click(function(event){
        $.post('/game_mode/enable',function() {
            window.location.reload();
        })
        event.preventDefault();
    })
});