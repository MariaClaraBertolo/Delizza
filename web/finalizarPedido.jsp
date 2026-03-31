<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="vo.ItemCarrinho, java.util.*, java.text.DecimalFormat" %>
<%
    @SuppressWarnings("unchecked")
    List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");
    if (carrinho == null || carrinho.isEmpty()) {
        response.sendRedirect("verCarrinho.jsp");
        return;
    }
    DecimalFormat df = new DecimalFormat("R$ #,##0.00");
    double total = carrinho.stream().mapToDouble(ItemCarrinho::getSubtotal).sum();
    
    // NOVO CÓDIGO: Captura a mensagem de erro do Controller (se o forward foi usado)
    String erro = (String) request.getAttribute("statusMensagem");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>Finalizar Pedido</title>
    <style>
        body {font-family: Arial; background: #EFE4B0; padding: 20px;}
        .container {max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 0 15px rgba(0,0,0,0.2);}
        h1, h2 {color: #ED5715; text-align: center;}
        label {display: block; margin: 15px 0 5px; font-weight: bold;}
        input, select, textarea {width: 100%; padding: 10px; border: 2px solid #ED5715; border-radius: 8px;}
        .troco {display: none;}
        button {background: #4CAF50; color: white; padding: 15px; font-size: 1.3em; border: none; border-radius: 10px; cursor: pointer; width: 100%; margin-top: 20px;}
        button:hover {background: #45a049;}
        .total {font-size: 1.8em; text-align: center; color: #4CAF50; margin: 30px 0;}
        .btn-voltar-carrinho {color: #ED5715; text-decoration: none;}
        .erro-mensagem {color: red; font-weight: bold; text-align: center; padding: 10px; border: 1px solid red; background: #ffebeb; border-radius: 5px; margin-bottom: 20px;}
    </style>
    <script>
        function mostrarTroco() {
            const pagamento = document.getElementById("pagamento").value;
            document.getElementById("trocoContainer").style.display = pagamento === "dinheiro" ? "block" : "none";
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>Finalizar Pedido</h1>
        
        <% 
            // CÓDIGO PARA EXIBIR A MENSAGEM DE ERRO
            if (erro != null) { 
        %>
            <p class="erro-mensagem"><%= erro %></p>
        <%
            }
        %>
       
       <form action="<%= request.getContextPath() %>/checkout" method="post">
            <input type="hidden" name="acao" value="confirmar">

            <h2>Dados de Entrega</h2>
            <label for="nomeCliente">Nome Completo</label>
            <input type="text" name="nomeCliente" id="nomeCliente" required>

            <label for="endereco">Endereço Completo (com número e bairro)</label>
            <textarea name="endereco" id="endereco" rows="3" required></textarea>

            <label for="telefone">Telefone / WhatsApp</label>
            <input type="text" name="telefone" id="telefone" placeholder="(99) 99999-9999" required>

            <h2>Pagamento</h2>
            <label for="pagamento">Forma de Pagamento</label>
            <select name="formaPagamento" id="pagamento" onchange="mostrarTroco()" required>
                <option value="">Selecione</option>
                <option value="dinheiro">Dinheiro (preciso de troco)</option>
                <option value="cartao">Cartão na entrega</option>
            </select>

            <div id="trocoContainer" class="troco"> 
                <label for="trocoPara">Precisa de troco para quanto?</label>
                <input type="text" name="trocoPara" id="trocoPara" placeholder="Ex: 100,00">
            </div>

            <div class="total">
                Total do Pedido: <%= df.format(total) %>
            </div>

            <button type="submit">Confirmar Pedido</button>
        </form>

        <br>
        <p style="text-align: center;">
            <a href="verCarrinho.jsp" class="btn-voltar-carrinho">← Voltar ao Carrinho</a> 
        </p>
    </div>
</body>
</html>