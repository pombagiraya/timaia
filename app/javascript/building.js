      console.log('ola');
      
    const clear_form_zipcode = () => {
        //Limpa valores do formulário de cep.
        document.getElementById('building_address').value=("");
        document.getElementById('building_city').value=("");
        document.getElementById('building_province').value=("");
    };

    function my_callback(content) {
        if (!("error" in content)) {
            //Atualiza os campos com os valores.
            document.getElementById('building_address').value=(content.logradouro);
            document.getElementById('building_city').value=(content.localidade);
            document.getElementById('building_province').value=(content.uf);
        } //end if.
        else {
            //CEP não Encontrado.
            clear_form_zipcode();
            alert("ZIP CODE could not be found.");
        }
    };

    const findzipcode = (value) => {

        //Nova variável "zipcode" somente com dígitos.
        var zipcode = value.replace(/\D/g, '');

        //Verifica se campo cep possui valor informado.
        if (zipcode != "") {

            //Expressão regular para validar o CEP.
            var validzipcode = /^[0-9]{8}$/;

            //Valida o formato do CEP.
            if(validzipcode.test(zipcode)) {

                //Preenche os campos com "..." enquanto consulta webservice.
                document.getElementById('building_address').value="...";
                document.getElementById('building_city').value="...";
                document.getElementById('building_province').value="...";

                //Cria um elemento javascript.
                var script = document.createElement('script');

                //Sincroniza com o callback.
                script.src = 'https://viacep.com.br/ws/'+ zipcode + '/json/?callback=my_callback';

                //Insere script no documento e carrega o conteúdo.
                document.body.appendChild(script);

            } //end if.
            else {
                //cep é inválido.
                clear_form_zipcode();
                alert("ZIP CODE invalid.");
            }
        } //end if.
        else {
            //cep sem valor, limpa formulário.
            clear_form_zipcode();
        }
    };

    findzipcode('90440090');

    console.log('ola');