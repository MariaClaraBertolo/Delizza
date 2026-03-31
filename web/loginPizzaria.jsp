<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Login Pizzaria</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #EFE4B0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }

        h2 {
            color: #ED5715;
            margin-bottom: 2rem;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
            background: white;
            padding: 30px 40px;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            min-width: 300px;
        }

        input[type="email"],
        input[type="password"] {
            padding: 10px;
            border: 2px solid #ED5715;
            border-radius: 8px;
            font-size: 1rem;
        }

        button {
            background: #ED5715;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }

        button:hover {
            background: #ff3333;
        }

        .link {
            margin-top: 10px;
            text-align: center;
        }

        .link a {
            color: #ED5715;
            text-decoration: none;
            font-weight: bold;
        }

        .link a:hover {
            color: #ff3333;
        }

        .erro {
            color: red;
            margin-top: 10px;
            text-align: center;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h2>Login da Pizzaria</h2>
    <form action="PizzariaController" method="post">
        <input type="hidden" name="acao" value="login">
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="senha" placeholder="Senha" required>
        <button type="submit">Entrar</button>
        <button type="button" onclick="window.location.href='index.jsp'">Voltar ao Painel</button>   
    </form>

    <p class="erro"><%= request.getAttribute("erro") != null ? request.getAttribute("erro") : "" %></p>
</body>
</html>
