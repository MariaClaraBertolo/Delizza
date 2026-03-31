<%@ page contentType="text/html" pageEncoding="UTF-8" session="true"%>
<%@ page import="vo.Pizzaria" %>
<%@ page import="vo.Ingrediente" %>
<%@ page import="java.util.List" %>
<%
    Pizzaria pizzaria = (Pizzaria) session.getAttribute("pizzaria");
    if (pizzaria == null) {
        response.sendRedirect("loginPizzaria.jsp");
        return;
    }
    @SuppressWarnings("unchecked")
    List<Ingrediente> ingredientes = (List<Ingrediente>) request.getAttribute("ingredientes");
    String mensagem = (String) request.getAttribute("mensagem");
    Ingrediente edicao = (Ingrediente) request.getAttribute("ingredienteEdicao");

    if (ingredientes == null) {
        ingredientes = java.util.Collections.emptyList();
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Gerenciar Ingredientes - <%= pizzaria.getNome() %></title>
    <style>
        body{font-family:Arial,sans-serif;background:#EFE4B0;display:flex;flex-direction:column;align-items:center;padding:50px 20px;margin:0;min-height:100vh}
        h2{color:#ED5715;margin-bottom:2rem}
        .container{width:90%;max-width:900px;background:white;padding:30px;border-radius:10px;box-shadow:0 4px 8px rgba(0,0,0,0.1)}
        .cadastro-form{display:flex;gap:10px;margin-bottom:30px;padding:15px;border:1px solid #ccc;border-radius:5px;align-items:flex-end;flex-wrap:wrap}
        .cadastro-form div{flex-direction:column;flex-grow:1;min-width:120px;flex-basis:150px}
        .cadastro-form label{font-weight:bold;margin-bottom:5px;color:#333}
        .cadastro-form input[type="text"],.cadastro-form select{padding:10px;border:1px solid #ddd;border-radius:5px;font-size:1em;width:100%;box-sizing:border-box}
        .cadastro-form button{background:#4CAF50;color:white;border:none;padding:10px 15px;border-radius:5px;cursor:pointer;font-weight:bold;height:38px;min-width:120px;transition:background .3s}
        .cadastro-form button:hover{background:#45a049}
        table{width:100%;border-collapse:collapse;margin-top:20px}
        th,td{padding:12px;border:1px solid #ddd;text-align:left}
        th{background:#ED5715;color:white}
        tr:nth-child(even){background:#f9f9f9}
        .acao-btn.alterar{background:#2196F3;margin-right:5px}
        .acao-btn.alterar:hover{background:#1976D2}
        .acao-btn{background:#f44336;color:white;border:none;padding:8px 12px;border-radius:5px;cursor:pointer;text-decoration:none;font-size:.9em;transition:background .3s;display:inline-block}
        .acao-btn:hover{background:#d32f2f}
        .mensagem-sucesso,.mensagem-erro{padding:10px;margin-bottom:20px;border-radius:5px;font-weight:bold;text-align:center}
        .mensagem-sucesso{background:#d4edda;color:#155724;border:1px solid #c3e6cb}
        .mensagem-erro{background:#f8d7da;color:#721c24;border:1px solid #f5c6cb}
        .back-link{display:inline-block;margin-top:20px;background:#ED5715;color:white;padding:10px 15px;border-radius:5px;text-decoration:none;font-weight:bold}
        .back-link:hover{background:#ff3333}
        .cancelar{background:#999;padding:10px 15px;border-radius:5px;color:white;text-decoration:none;margin-left:10px;display:inline-block}
        .cancelar:hover{background:#777}
    </style>
</head>
<body>
    <h2>Gerenciar Ingredientes</h2>
    <div class="container">
        <% if (mensagem != null) { 
            String cssClass = mensagem.toLowerCase().contains("sucesso") ? "mensagem-sucesso" : "mensagem-erro"; %>
            <div class="<%= cssClass %>"><%= mensagem %></div>
        <% } %>

        <!-- FORMULÁRIO INTELIGENTE -->
        <h3><%= edicao != null ? "Editar Ingrediente" : "Cadastrar Novo Ingrediente" %></h3>
        <form class="cadastro-form" action="IngredienteController" method="post">
            <input type="hidden" name="acao" value="<%= edicao != null ? "atualizar" : "cadastrar" %>">
            <% if (edicao != null) { %>
                <input type="hidden" name="id" value="<%= edicao.getId() %>">
            <% } %>

            <div><label>Nome:</label><input type="text" name="nome" required value="<%= edicao != null ? edicao.getNome() : "" %>" placeholder="Ex: Mussarela"></div>
            <div><label>Tipo:</label>
                <select name="tipo" required>
                    <option value="">-- Selecione --</option>
                    <option value="Massa" <%= edicao != null && "Massa".equals(edicao.getTipo()) ? "selected" : "" %>>Massa</option>
                    <option value="Borda" <%= edicao != null && "Borda".equals(edicao.getTipo()) ? "selected" : "" %>>Borda</option>
                    <option value="Recheio Salgado" <%= edicao != null && "Recheio Salgado".equals(edicao.getTipo()) ? "selected" : "" %>>Recheio Salgado</option>
                    <option value="Recheio Doce" <%= edicao != null && "Recheio Doce".equals(edicao.getTipo()) ? "selected" : "" %>>Recheio Doce</option>
                    <option value="Outro" <%= edicao != null && "Outro".equals(edicao.getTipo()) ? "selected" : "" %>>Outro</option>
                </select>
            </div>
            <div><label>Estoque:</label><input type="text" name="quantidadeEstoque" required value="<%= edicao != null ? edicao.getQuantidadeEstoque() : "" %>" placeholder="Ex: 1.5"></div>
            <div><label>Unidade:</label><input type="text" name="unidadeMedida" required value="<%= edicao != null ? edicao.getUnidadeMedida() : "" %>" placeholder="Ex: kg"></div>
            <div><label>Preço (R$):</label><input type="text" name="preco" required value="<%= edicao != null ? String.format("%.2f", edicao.getPreco()) : "" %>" placeholder="Ex: 10.50"></div>
            <button type="submit"><%= edicao != null ? "Salvar Alterações" : "Cadastrar" %></button>
            <% if (edicao != null) { %>
                <a href="gerenciarIngredientes.jsp" class="cancelar">Cancelar</a>
            <% } %>
        </form>

        <h3>Ingredientes Disponíveis (<%= ingredientes.size() %>)</h3>
        <% if (!ingredientes.isEmpty()) { %>
            <table>
                <thead>
                    <tr><th>ID</th><th>Nome</th><th>Tipo</th><th>Estoque</th><th>Unidade</th><th>Preço</th><th>Ação</th></tr>
                </thead>
                <tbody>
                    <% for (Ingrediente ing : ingredientes) { %>
                        <tr>
                            <td><%= ing.getId() %></td>
                            <td><%= ing.getNome() %></td>
                            <td><%= ing.getTipo() %></td>
                            <td><%= ing.getQuantidadeEstoque() %></td>
                            <td><%= ing.getUnidadeMedida() %></td>
                            <td><%= String.format("R$ %.2f", ing.getPreco()) %></td>
                            <td>
                                <a href="IngredienteController?acao=prepararAlteracao&id=<%= ing.getId() %>" class="acao-btn alterar">Alterar</a>
                                <a href="IngredienteController?acao=excluir&id=<%= ing.getId() %>" class="acao-btn" 
                                   onclick="return confirm('Excluir \'<%= ing.getNome() %>\'?');">Excluir</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <p>Nenhum ingrediente cadastrado.</p>
        <% } %>
    </div>
    <a href="painelPizzaria.jsp" class="back-link">Voltar ao Painel</a>
</body>
</html>