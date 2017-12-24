$(function(){
    var checkValues = function(){
        var currentPassword = $('#password').val();
        var verifyPassword = $('#verify-password').val();
        var passwordmessage = ""
        if(currentPassword.length < 8){
            passwordmessage = "Password must be > 8 characters";
        } else if(verifyPassword != currentPassword){
            passwordmessage = "The Verification password does not match the Password";
        }
        $('#password-info')[0].innerText =passwordmessage;


        var nameMessage = ""
        var currentName = $('#name').val();
        if(currentName.indexOf(' ') > 2 && currentName.split(' ')[1] && currentName.split(' ')[1].length > 2) {
            nameMessage = ""
        } else {
            nameMessage = "Please enter your first and last name"
        }
        $('#name-info')[0].innerText = nameMessage;


        var emailMessage = ""
        var currentEmail = $('#email').val();
        if(currentEmail.indexOf('@') > 2 && currentEmail.indexOf('.') > 3 && currentEmail.split('@')[1] && currentEmail.split('@')[1].length > 1) {
            emailMessage = ""
        } else {
            emailMessage = "Please enter a valid email address"
        }

        $('#email-info')[0].innerText = emailMessage;

        if(emailMessage.length == 0 && nameMessage.length == 0 && passwordmessage == 0){
            $('.create-user')[0].disabled = false;
        } else {
            $('.create-user')[0].disabled = true;
        }
    }

    checkValues();

    $("#email").keyup(function(event){
      checkValues();
    })
    $("#password").keyup(function(event){
        checkValues();
    })
    $("#verify-password").keyup(function(event){
        checkValues();
    })
    $("#name").keyup(function(event){
        checkValues();
    })
})