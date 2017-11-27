$(function(){
    $('#data-datatables').DataTable();
    $(document).foundation();

    $('.view-match').click(function(element){
        var match_id = element.target.id.split('-id-')[1];
        location.pathname = '/matches/' + match_id;
    });
})