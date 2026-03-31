<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="vo.PedidoCompleto, vo.PedidoItem, vo.Pizzaria" %>
<%@ page import="java.util.List, java.text.DecimalFormat" %>
<%
    // ... (Código de recuperação de dados e formatação permanece o mesmo)
    PedidoCompleto pedido = (PedidoCompleto) request.getAttribute("pedido");
    @SuppressWarnings("unchecked")
    List<PedidoItem> itens = (List<PedidoItem>) request.getAttribute("itensDoPedido");
    Pizzaria pizzaria = (Pizzaria) request.getSession().getAttribute("pizzaria");

    // Formatação
    DecimalFormat df = new DecimalFormat("R$ #,##0.00");
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");

    // Validação de segurança básica
    if (pedido == null || pizzaria == null) {
        response.sendRedirect(request.getContextPath() + "/exibirPedidos");
        return;
    }
    if (itens == null) itens = java.util.Collections.emptyList();
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Detalhes do Pedido #<%= pedido.getId() %></title>
    <style>
        body {font-family: Arial, sans-serif; background: #EFE4B0; padding: 20px;}
        .container {max-width: 900px; margin: 0 auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 0 15px rgba(0,0,0,0.1);}
        h1 {color: #ED5715; text-align: center; border-bottom: 2px solid #ED5715; padding-bottom: 10px;}
        h2 {color: #555; margin-top: 20px;}
        .info-box {border: 1px solid #ddd; padding: 15px; border-radius: 8px; margin-bottom: 20px;}
        .info-box p {margin: 5px 0;}
        table {width: 100%; border-collapse: collapse; margin-top: 15px;}
        th, td {padding: 10px; border: 1px solid #ddd; text-align: left;}
        th {background: #f1f1f1; font-weight: bold;}
        .total-final {font-size: 1.6em; text-align: right; color: #4CAF50; margin-top: 20px;}
        .btn-voltar {display: inline-block; margin-top: 30px; background: #2196F3; color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none;}
        .btn-voltar:hover {background: #1976D2;}
        /* Estilos para Status */
        .status-pendente {color: orange; font-weight: bold;}
        .status-confirmado {color: blue; font-weight: bold;}
        .status-entregue {color: green; font-weight: bold;}
    </style>
</head>
<body>
<div class="container">
    <h1>Detalhes do Pedido #<%= pedido.getId() %></h1>

    <div class="info-box">
        <h2>Cliente e Entrega</h2>
        <p><strong>Cliente:</strong> <%= pedido.getNomeCliente() %></p>
        <p><strong>Telefone:</strong> <%= pedido.getTelefone() %></p>
        <p><strong>Endereço:</strong> <%= pedido.getEnderecoEntrega() %></p>
        <hr>
        <p><strong>Data/Hora:</strong> <%= sdf.format(pedido.getDataPedido()) %></p>
        <p><strong>Status Atual:</strong> <span class="status-<%= pedido.getStatus().toLowerCase() %>"><%= pedido.getStatus() %></span></p>
        <p><strong>Método de Pagamento:</strong> <%= pedido.getMetodoPagamento() %></p>
        <p><strong>Troco:</strong> <%= pedido.getTroco() > 0 ? df.format(pedido.getTroco()) : "Não" %></p>
    </div>

    <h2>Itens Solicitados</h2>
    <% if (itens.isEmpty()) { %>
        <p style="text-align: center;">Nenhum item detalhado encontrado para este pedido.</p>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Qtd.</th>
                    <th>Tipo</th>
                    <th>Nome do Item</th>
                    <th>Descrição / Detalhes</th>
                    <th>Preço Unitário</th>
                </tr>
            </thead>
            <tbody>
                <% for (PedidoItem item : itens) { 
                    // CORREÇÃO: Formata a descrição (ingredientes) para exibir quebras de linha em HTML
                    String detalhes = item.getDescricaoItem() != null && !item.getDescricaoItem().trim().isEmpty() 
                                      ? item.getDescricaoItem().replace("\n", "<br>") 
                                      : "-"; 
                %>
                <tr>
                    <td><%= item.getQuantidade() %></td>
                    <td><%= item.getTipoItem() %></td> 
                    <td><strong><%= item.getNomeItem() %></strong></td>
                    <td><%= detalhes %></td> <td><%= df.format(item.getValorUnitario()) %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <div class="total-final">
            Valor Total do Pedido: <strong><%= df.format(pedido.getValorTotal()) %></strong>
        </div>
    <% } %>

    <a href="<%= request.getContextPath() %>/exibirPedidos" class="btn-voltar">← Voltar à Lista de Pedidos</a>
</div>
</body>
</html>