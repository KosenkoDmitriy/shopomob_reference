$(document).ready(function(){
    $("#nav-search").on("change keyup paste click", function(){
        var query = $( "#nav-search").val();
        $('#nav-search-form').attr({action:"/shops/-1/"+query+"?page=1" });
//        window.history.pushState("string", "Title", "newUrl2"); //change brower url without reloading
        console.log( "Handler for .on() called. " + query );
    });
})