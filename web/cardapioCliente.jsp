<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="vo.ItemCardapio" %>
<%@ page import="vo.ItemCarrinho" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    // ====== CARRINHO DA SESSÃO ======
    @SuppressWarnings("unchecked")
    List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");
    if (carrinho == null) {
        carrinho = new ArrayList<>();
    }
    // ====== ITENS DO CARDÁPIO ======
    @SuppressWarnings("unchecked")
    List<ItemCardapio> itensCardapio = (List<ItemCardapio>) request.getAttribute("itensCardapio");
    if (itensCardapio == null) {
        itensCardapio = java.util.Collections.emptyList();
    }
    // ====== ID DA PIZZARIA – PEGA DIRETO DA URL (NUNCA MAIS VAI DAR ERRO) ======
    String pizzariaParam = request.getParameter("pizzaria");
    int pizzariaId = 5; // valor padrão
    if (pizzariaParam != null && !pizzariaParam.trim().isEmpty()) {
        try {
            pizzariaId = Integer.parseInt(pizzariaParam.trim());
        } catch (NumberFormatException e) {
            pizzariaId = 5; // se vier algo inválido, usa 5 como fallback
        }
    }
    DecimalFormat df = new DecimalFormat("R$ #,##0.00");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Cardápio Online - Pizzaria Delizza</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* Paleta de Cores Consistente */
        :root {
            --primary-color: #ED5715; /* Laranja/Vermelho para destaque e botões principais */
            --secondary-color: #F8B400; /* Amarelo/Ouro para ênfase */
            --background-color: #FDFDFD; /* Branco/Fundo leve */
            --body-background: #EFE4B0; /* Bege (Original Body) */
            --text-color: #333;
            --price-color: #4CAF50; /* Verde para Preço */
        }
        body {
            font-family: 'Poppins', Arial, sans-serif;
            background: var(--body-background);
            margin: 0;
            padding: 0;
            color: var(--text-color);
        }
       
        .header-content {
            background: #FF925C; /* Alterado para a cor solicitada em vez de var(--background-color) */
            padding: 20px 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        h1 {
            color: white; /* Alterado para branco */
            text-align: center;
            margin: 0 0 10px;
            font-size: 2.8em;
        }
        /* NAVEGAÇÃO SUPERIOR */
        .nav-links {
            text-align: center;
            margin: 10px 0;
        }
        .nav-links a {
            background: #2196F3; /* Alterado para a cor do botão de adicionar ao carrinho */
            color: white;
            padding: 10px 20px;
            margin: 0 8px;
            border-radius: 20px; /* Borda mais suave (pill shape) */
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            transition: background-color .3s, transform .2s;
            box-shadow: 0 3px 6px rgba(0,0,0,0.2);
        }
        .nav-links a:hover {
            background: #1976D2; /* Alterado para o hover do botão de adicionar ao carrinho */
            transform: translateY(-2px);
        }
       
        h2 {
            color: var(--text-color);
            text-align: center;
            font-size: 1.8em;
            margin: 40px auto 25px;
            width: fit-content;
            border-bottom: 3px solid var(--secondary-color);
            padding-bottom: 5px;
        }
        /* GRID E CARDS */
        .cardapio-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); /* Reduzido de 300px para 250px para diminuir o tamanho das caixas */
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .card-item {
            background: var(--background-color);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            text-align: center;
            transition: transform .3s, box-shadow .3s;
            display: flex;
            flex-direction: column;
        }
        .card-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(0,0,0,0.2);
        }
        .card-item img {
            width: 100%;
            height: 180px; /* Reduzido de 220px para 180px para tornar a caixa menor, ajustando proporcionalmente */
            object-fit: contain; /* Alterado de 'cover' para 'contain' para exibir toda a imagem sem corte */
            background-color: #f8f8f8; /* Fundo leve para preencher espaços se a imagem não preencher toda a área */
        }
        .card-content {
            padding: 15px; /* Reduzido de 20px para 15px para compactar a caixa */
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .card-content h3 {
            color: var(--primary-color);
            margin: 0 0 5px;
            font-size: 1.4em; /* Levemente reduzido para caber melhor em caixas menores */
            font-weight: 700;
        }
        .card-content p {
            color: #666;
            min-height: 40px; /* Garante que cards vazios tenham altura similar */
            margin: 5px 0 15px;
            font-size: 0.85em; /* Reduzido levemente para compactar */
            line-height: 1.4;
        }
        .card-price {
            font-size: 1.5em; /* Reduzido de 1.6em para caber melhor */
            font-weight: 700;
            color: var(--price-color);
            margin: 10px 0; /* Reduzido margens */
        }
        .add-btn {
            background: #2196F3; /* Mantendo um azul vibrante para a ação principal de compra */
            color: white;
            border: none;
            padding: 10px; /* Reduzido de 12px para compactar */
            border-radius: 6px;
            width: 100%;
            font-weight: 600;
            cursor: pointer;
            transition: background .3s;
            margin-top: auto; /* Empurra o botão para baixo */
        }
        .add-btn:hover {
            background: #1976D2;
        }
       
        /* MENSAGEM DE VAZIO */
        .empty-msg {
            text-align: center;
            font-size: 1.5em;
            color: #999;
            margin: 80px 0;
            padding: 20px;
            background: var(--background-color);
            border-radius: 8px;
            max-width: 600px;
            margin: 80px auto;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        /* LINK DE VOLTAR */
        .voltar {
            display: block;
            text-align: center;
            margin: 40px 0;
            color: var(--primary-color);
            font-weight: 600;
            font-size: 1.1em;
            text-decoration: none;
            padding: 10px 20px;
            border: 1px solid var(--primary-color);
            width: fit-content;
            margin: 40px auto;
            border-radius: 5px;
            transition: background-color .2s, color .2s;
        }
        .voltar:hover {
            background-color: var(--primary-color);
            color: white;
        }
       
        /* Responsividade */
        @media (max-width: 600px) {
            h1 { font-size: 2em; }
            .nav-links a {
                margin: 5px;
                padding: 8px 15px;
                font-size: 0.9em;
                display: block;
                width: 80%;
                margin: 8px auto;
            }
            .cardapio-grid {
                padding: 10px;
                gap: 20px;
            }
            .card-item img {
                height: 150px; /* Ajuste para telas menores */
            }
        }
    </style>
</head>
<body>
   
    <div class="header-content">
        <h1>Cardápio Online - 🍕 Pizzaria Delizza</h1>
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/cardapio?pizzaria=<%= pizzariaId %>">Cardápio Pronto</a>
            <a href="<%= request.getContextPath() %>/montar-pizza?pizzaria=<%= pizzariaId %>">Monte Sua Pizza</a>
            <a href="verCarrinho.jsp">🛒 Ver Carrinho (<%= carrinho.size() %>)</a>
        </div>
    </div>
    <h2>Pizzas e Produtos Prontos</h2>
    <% if (itensCardapio.isEmpty()) { %>
        <p class="empty-msg">😔 Nenhum item disponível no cardápio no momento. Volte em breve!</p>
    <% } else { %>
        <div class="cardapio-grid">
            <% for (ItemCardapio item : itensCardapio) { %>
                <div class="card-item">
                    <img src="<%= (item.getImagemUrl() != null && !item.getImagemUrl().trim().isEmpty())
                                 ? item.getImagemUrl()
                                 : "https://via.placeholder.com/300x220/FF6B35/FFFFFF?text=Pizza+Delizza" %>"
                             alt="<%= item.getNome() %>">
                    <div class="card-content">
                        <div>
                            <h3><%= item.getNome() %></h3>
                            <p><%= (item.getDescricao() != null && !item.getDescricao().trim().isEmpty())
                                     ? item.getDescricao() : "Deliciosa pizza feita com carinho e ingredientes frescos!" %></p>
                        </div>
                       
                        <div class="card-price"><%= df.format(item.getPreco()) %></div>
                        <form action="<%= request.getContextPath() %>/carrinho" method="post">
                            <input type="hidden" name="acao" value="adicionarPronto">
                            <input type="hidden" name="itemId" value="<%= item.getId() %>">
                            <button type="submit" class="add-btn">Adicionar ao Carrinho</button>
                        </form>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
    <a href="<%= request.getContextPath() %>/" class="voltar">← Voltar à Home</a>
</body>
</html>