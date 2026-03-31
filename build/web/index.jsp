<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Pizzaria Bella Massa</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #EFE4B0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }
        h1 {
            color: #ED5715;
            margin-bottom: 2rem;
        }
        .buttons {
            display: flex;
            gap: 20px;
        }
        a {
            background: #ED5715;
            color: white;
            padding: 12px 24px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
        }
        a:hover {
            background: #ff3333;
        }
    </style>
</head>
<body>
    <h1>🍕 Pizzaria Delizza</h1>
    <div class="buttons">
        <a href="<%= request.getContextPath() %>/cardapio?pizzaria=5">Ver Cardápio</a>
        <a href="loginPizzaria.jsp">Área da Pizzaria</a>
    </div>
</body>
</html>
