<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="vo.ItemCarrinho, vo.Ingrediente, java.util.*, java.text.DecimalFormat" %>
<%
    @SuppressWarnings("unchecked")
    List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");
    if (carrinho == null) carrinho = new ArrayList<>();
    DecimalFormat df = new DecimalFormat("R$ #,##0.00");
    double total = carrinho.stream().mapToDouble(ItemCarrinho::getSubtotal).sum();
    
    // Recupera a mensagem de erro da sessão e a limpa
    String erroMensagem = (String) session.getAttribute("statusMensagem"); // Usando "statusMensagem" que é o nome mais comum agora
    if (erroMensagem != null) {
        session.removeAttribute("statusMensagem");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Seu Carrinho</title>
    <style>
        body {font-family: Arial; background: #EFE4B0; padding: 20px;}
        .container {max-width: 900px; margin: 0 auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 0 15px rgba(0,0,0,0.2);}
        table {width: 100%; border-collapse: collapse; margin: 20px 0;}
        th, td {padding: 12px; border: 1px solid #ddd; text-align: left;}
        th {background: #ED5715; color: white;}
        .total {font-size: 1.8em; text-align: right; color: #4CAF50; margin-bottom: 20px;}
        .btn {padding: 12px 25px; margin: 10px; border: none; border-radius: 8px; cursor: pointer; font-weight: bold;}
        .continuar {background: #2196F3; color: white;}
        .finalizar {background: #4CAF50; color: white; font-size: 1.2em;}
        .limpar {background: #f44336; color: white;}
        .detalhe-item {font-size: 0.9em; color: #555;}
        .erro-msg {color: #f44336; font-weight: bold; text-align: center; border: 2px solid #f44336; padding: 10px; margin-bottom: 20px; border-radius: 5px;}
    </style>
</head>
<body>
<div class="container">
    <h1 style="color: #ED5715; text-align: center;">Seu Carrinho (<%= carrinho.size() %> itens)</h1>
    <%
        // Exibe mensagens de status/erro do Controller (statusMensagem)
        if (erroMensagem != null) {
    %>
        <div class="erro-msg">
            <%= erroMensagem %>
        </div>
    <%
        }
    %>
    <% if (carrinho.isEmpty()) { %>
        <p style="text-align: center;">Seu carrinho está vazio.</p>
        <p style="text-align: center;"><a href="<%= request.getContextPath() %>/cardapio?pizzaria=5" class="btn continuar">Continuar Comprando</a></p>
    <% } else { %>
        <table>
            <tr><th>Item</th><th>Detalhes</th><th>Preço</th></tr>
            <% for (ItemCarrinho ic : carrinho) { 
                String nomeBase = (ic.getTipo().equals("pronto") || !ic.isItemPersonalizado()) ? "Item Pronto" : "Pizza Personalizada";
            %>
                <tr>
                    <td>
                        <%= ic.isItemPersonalizado() ? ic.getNomePersonalizado() : (ic.getItemPronto() != null ? ic.getItemPronto().getNome() : nomeBase) %>
                    </td>
                    <td>
                        <% if (ic.isItemPersonalizado()) { 
                            // 🍕 NOVO: Usa a string formatada de ingredientes que o JS criou
                            String ingredientesFormatados = ic.getIngredientesSelecionados();
                            if (ingredientesFormatados != null) {
                                // Substitui \n por <br> para exibir formatado no HTML
                                out.print("<span class='detalhe-item'>");
                                out.print(ingredientesFormatados.replace("\n", "<br>"));
                                out.print("</span>");
                            } else {
                                out.print("Detalhes da pizza não foram carregados corretamente.");
                            }
                        } else { 
                            // Item Pronto (apenas descrição básica ou nome)
                            if (ic.getItemPronto() != null) {
                                out.print("<span class='detalhe-item'>");
                                out.print("Qtd: " + ic.getQuantidade());
                                out.print("</span>");
                            }
                        } %>
                    </td>
                    <td><%= df.format(ic.getSubtotal()) %></td>
                </tr>
            <% } %>
        </table>
        <div class="total">Total: <%= df.format(total) %></div>
        <div style="text-align: center;">
            <a href="<%= request.getContextPath() %>/cardapio?pizzaria=5" class="btn continuar">Continuar Comprando</a>
            <a href="<%= request.getContextPath() %>/carrinho?acao=limpar" class="btn limpar">Limpar Carrinho</a>
            <a href="finalizarPedido.jsp" class="btn finalizar">Finalizar Pedido →</a>
        </div>
    <% } %>
</div>
</body>
</html>