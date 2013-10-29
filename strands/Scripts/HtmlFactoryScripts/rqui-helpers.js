var myInterval = false; // this variable will hold the interval and work as a flag
var $win = $(window); //jquery win object
var dimensions = [$win.width(), $win.height()]; //initial dimensions

$(window).resize(function () { //on window resize...
    if (!myInterval) //if the interval is not set,
    {
        myInterval = setInterval(function () { //initialize it
            //and check to see if the dimenions have changed or remained the same
            if (dimensions[0] === $win.width() && dimensions[1] === $win.height()) {   //if they are the same, then we are no longer resizing the window
                clearInterval(myInterval); //deactivate the interval
                myInterval = false; //use it as a flag

                //doStuff(); //call your callback function
                resizeToWindow();
            }
            else {
                dimensions[0] = $win.width(); //else keep the new dimensions
                dimensions[1] = $win.height();
            }
        }, 64);  //and perform a check every 64ms
    }

});

function resizeToWindow() {
    $(".content-box, .rq-result-box").css("min-height", (dimensions[1] - 220) + "px");
    $(".rq-sidebar, .rq-left-sidebar, .content-box, .rq-result-box").css("max-height", (dimensions[1] - 220) + "px");
};

function ajaxLoadingIndicator(el) {
    this.init = function () {
        $('.rq-ajax-wait').css("width", $(el).width() - 7);
        $('.rq-ajax-wait').css("height", $(el).height());
        $('.rq-ajax-wait').css("top", $(el).offset().top + 5);
        $('.rq-ajax-wait').css("left", $(el).offset().left + 7);
        $('.rq-ajax-wait').fadeIn(800);
    }

    this.remove = function () {
        $('.rq-ajax-wait').fadeOut(800);
    }

    this.init();
}

var _myHelper = {
    /* helper function for processing the server response. Triggers either an error or success message window 
    /* and calls provided functions if neccessary. */
    processServerResponse: function (response, onSuccess, onError) {
        if (response.isSuccess) {
            if (response.message) // show message only if available
                _myHelper.showSuccess(response.message);
            // call success callback
            if ($.isFunction(onSuccess))
                onSuccess.apply();
        } else {
            //show error message
            var errMsg = "";

            if (response.message) // show message only if available
                errMsg = response.message;
            if (response.responseText)
                errMsg += ((errMsg != "") ? "<br>" : "") + response.responseText.replace(/\+/g, " ");
            if (errMsg != "")
                _myHelper.showError(errMsg, "error");
            if ($.isFunction(onError))
                onError.apply();
        }
    },

    showSuccess: function (msg) { _myHelper.showMessage(msg, "success"); },

    showError: function (msg) { _myHelper.showMessage(msg, "error"); },

    /* returns the info window element and creates one if it is not yet existing */
    infoWindow: function () {
        //remove old info window
        $("#simple-user-info").remove();
        //add new one
        return $("<div/>").attr("id", "simple-user-info")
               .appendTo("body");
    },

    /* Shows an error or success notification */
    showMessage: function (message, cssClass) {
        var $info = _myHelper.infoWindow().addClass(cssClass).text(message);
        //show info message
        $info.fadeIn(1000).on("mouseover", fadeOutInfoWindow);
        //hide after 10 seconds and on one document click
        setTimeout(function () { fadeOutInfoWindow(); }, 10000);
        $(document).one("click", fadeOutInfoWindow)
        //fadeOut info window
        function fadeOutInfoWindow() {
            $info.fadeOut(1000);
        }
    },

    /* Helper function for html encoding unsecure user input */
    encodeHtml: function (input) {
        return $("<div/>").text(input).html();
    }
}