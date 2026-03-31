<%@ page contentType="text/html" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.util.List, java.util.TimeZone, java.text.DecimalFormat" %>
<%@ page import="vo.Pizzaria" %>
<%
    Pizzaria pizzaria = (Pizzaria) session.getAttribute("pizzaria");
    if (pizzaria == null) {
        response.sendRedirect("loginPizzaria.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<vo.PedidoCompleto> pedidos = (List<vo.PedidoCompleto>) request.getAttribute("pedidos");
    if (pedidos == null) pedidos = java.util.Collections.emptyList();

    DecimalFormat df = new DecimalFormat("R$ #,##0.00");
    
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Pedidos Recebidos - <%= pizzaria.getNome() %></title>
    <style>
        body {font-family: Arial; background: #EFE4B0; padding: 20px;}
        .container {max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 0 15px rgba(0,0,0,0.1);}
        h1 {color: #ED5715; text-align: center;}
        table {width: 100%; border-collapse: collapse; margin: 20px 0;}
        th, td {padding: 12px; text-align: left; border-bottom: 1px solid #ddd;}
        th {background: #ED5715; color: white;}
        tr:hover {background: #f1f1f1;}
        .status-pendente {color: #ff9800; font-weight: bold;}
        .status-confirmado {color: #4CAF50; font-weight: bold;}
        .status-entregue {color: #2196F3; font-weight: bold;}
        
        /* Estilos dos botões de ação */
        .btn-action {background: #4CAF50; color: white; border: none; padding: 8px 12px; border-radius: 5px; cursor: pointer; transition: background 0.3s; display: block; margin-bottom: 5px;}
        .btn-action:hover {background: #45a049;}
        .btn-detail {background: #007bff; color: white; padding: 8px 12px; border-radius: 5px; text-decoration: none; display: inline-block; margin-bottom: 5px;}
        .btn-detail:hover {background: #0056b3;}
        .btn-disabled {background: #ccc; cursor: default;}
        .btn-voltar {display: inline-block; margin-top: 20px; background: #ED5715; color: white; padding: 12px 25px; border-radius: 8px; text-decoration: none;}
        .btn-voltar:hover {background: #ff3333;}
    </style>
</head>
<body>
<div class="container">
    <h1>Pedidos Recebidos (<%= pedidos.size() %>)</h1>

    <% if (pedidos.isEmpty()) { %>
        <p style="text-align:center; font-size:1.3em;">Nenhum pedido recebido ainda.</p>
    <% } else { %>
        <table>
            <tr>
                <th>Nº Pedido</th>
                <th>Data/Hora</th>
                <th>Cliente</th>
                <th>Endereço</th>
                <th>Valor Total</th>
                <th>Pagamento</th>
                <th>Troco</th>
                <th>Status</th>
                <th>Ações</th> </tr>
            <% for (vo.PedidoCompleto p : pedidos) { %>
            <tr>
                <td><strong>#<%= p.getId() %></strong></td>
                <td><%= sdf.format(p.getDataPedido()) %></td>
                <td><%= p.getNomeCliente() %><br><small><%= p.getTelefone() %></small></td>
                <td><%= p.getEnderecoEntrega() %></td>
                <td><strong><%= df.format(p.getValorTotal()) %></strong></td>
                <td>
                    <%  
                        String metodo = p.getMetodoPagamento();
                        if (metodo.equals("DINHEIRO")) {
                            out.print("Dinheiro");
                        } else if (metodo.equals("CARTAO")) {
                            out.print("Cartão");
                        } else if (metodo.equals("PIX")) {
                            out.print("PIX");
                        } else {
                            out.print(metodo);
                        }
                    %>
                </td>
                <td><%= p.getTroco() > 0 ? df.format(p.getTroco()) : "-" %></td>
                <td class="status-<%= p.getStatus().toLowerCase() %>"><%= p.getStatus() %></td>
                <td>
                    <a href="<%= request.getContextPath() %>/detalhePedido?pedidoId=<%= p.getId() %>" class="btn-detail">Ver Detalhes</a>
                    
                    <% if (p.getStatus().equals("PENDENTE")) { %>
                        <form action="atualizar-pedido" method="post" style="margin:0;">
                            <input type="hidden" name="pedidoId" value="<%= p.getId() %>">
                            <input type="hidden" name="novoStatus" value="CONFIRMADO">
                            <button type="submit" class="btn-action">Confirmar Pedido</button>
                        </form>
                    <% } else if (p.getStatus().equals("CONFIRMADO")) { %>
                        <form action="atualizar-pedido" method="post" style="margin:0;">
                            <input type="hidden" name="pedidoId" value="<%= p.getId() %>">
                            <input type="hidden" name="novoStatus" value="ENTREGUE">
                            <button type="submit" class="btn-action" style="background: #2196F3;">Marcar como Entregue</button>
                        </form>
                    <% } else { %>
                        <button class="btn-action btn-disabled">Finalizado</button>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </table>
    <% } %>

    <a href="painelPizzaria.jsp" class="btn-voltar">Voltar ao Painel</a>
</div>
</body>
</html>