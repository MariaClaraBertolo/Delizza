<%@ page contentType="text/html" pageEncoding="UTF-8" session="true"%>
<%
    vo.Pizzaria pizzaria = (vo.Pizzaria) session.getAttribute("pizzaria");
    if (pizzaria == null) {
        response.sendRedirect("loginPizzaria.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Painel da Pizzaria</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #EFE4B0;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 50px 20px;
            margin: 0;
            min-height: 100vh;
        }

        h2 {
            color: #ED5715;
            margin-bottom: 3rem;
        }

        .menu {
            display: flex;
            flex-direction: column;
            gap: 20px;
            width: 250px;
        }

        .menu a {
            background: #ED5715;
            color: white;
            text-decoration: none;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            font-weight: bold;
            transition: background 0.3s;
        }

        .menu a:hover {
            background: #ff3333;
        }
    </style>
</head>
<body>
    <h2>Bem-vinda, <%= pizzaria.getNome() %>!</h2>
    <div class="menu">
        <a href="CardapioController">Gerenciar Cardápio</a>
        <a href="IngredienteController">Gerenciar Ingredientes</a>
        <a href="<%= request.getContextPath() %>/exibirPedidos">Ver Pedidos Recebidos</a>
        <a href="loginPizzaria.jsp">Sair</a>
    </div>
</body>
</html>
