$("#building_zipcode").focusout(function() {     
    var zipcode = $("#building_zipcode").val();
    zipcode = zipcode.replace("-", "");

    var urlStr = "https://viacep.com.br/ws/" + zipcode + "/json/";

    $.ajax({
        url : urlStr,
        type : "get",
        dataType : "json",
        success : function(data){
            $("#building_address").val(data.logradouro);
            $("#building_city").val(data.localidade);
            $("#building_province").val(data.uf);
        }
    });
});
