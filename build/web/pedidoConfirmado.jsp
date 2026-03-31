<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pedido Confirmado!</title>
    <style>
        body {font-family: Arial; background: #EFE4B0; display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100vh; margin: 0;}
        .box {background: white; padding: 40px; border-radius: 20px; box-shadow: 0 10px 20px rgba(0,0,0,0.2); text-align: center; max-width: 500px;}
        h1 {color: #4CAF50;}
        .numero {font-size: 3em; color: #ED5715; font-weight: bold;}
        .btn {background: #ED5715; color: white; padding: 15px 30px; border-radius: 10px; text-decoration: none; font-weight: bold; display: inline-block; margin-top: 20px;}
        .btn:hover {background: #ff3333;}
    </style>
</head>
<body>
    <div class="box">
        <h1>Pedido Confirmado!</h1>
        <p>Obrigado, <strong>${nomeCliente}</strong>!</p>
        <div class="numero">#${pedidoId}</div>
        <p>Seu pedido no valor de <strong>R$ ${String.format("%.2f", valorTotal)}</strong> foi enviado com sucesso.</p>
        <p>Entraremos em contato em breve pelo WhatsApp.</p>
        <a href="${pageContext.request.contextPath}/cardapio?pizzaria=5" class="btn">Fazer Outro Pedido</a>
    </div>
</body>
</html>