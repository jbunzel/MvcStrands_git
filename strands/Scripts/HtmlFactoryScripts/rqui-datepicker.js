$(document).ready(function () {
    $.datepicker.setDefaults($.datepicker.regional["de"]);
    $("div#date").datepicker({
        changeMonth: true,
        changeYear: true,
        dateFormat: "ymm_TB/d",
        nextText: "",
        prevText: "",
        showOtherMonths: true,
        onSelect: function (dateText) 
        {
            window.location.href = HostAdress() + "/" +dateText;
        }
    });
});


