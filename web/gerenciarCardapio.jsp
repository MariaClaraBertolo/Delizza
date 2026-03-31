<%@ page contentType="text/html" pageEncoding="UTF-8" session="true"%>
<%@ page import="vo.Pizzaria" %>
<%@ page import="vo.ItemCardapio" %> <%-- ATENÇÃO: Você precisará criar este VO --%>
<%@ page import="java.util.List" %>
<%
    // 1. O Controller deve garantir que 'pizzaria' está na sessão
    vo.Pizzaria pizzaria = (vo.Pizzaria) session.getAttribute("pizzaria");
    if (pizzaria == null) {
        response.sendRedirect("loginPizzaria.jsp");
        return;
    }

    // 2. O Controller deve ter enviado 'itensCardapio' e 'mensagem' no request
    @SuppressWarnings("unchecked")
    List<vo.ItemCardapio> itensCardapio = (List<vo.ItemCardapio>) request.getAttribute("itensCardapio");
    String mensagem = (String) request.getAttribute("mensagem");
    
    // 3. Se a JSP for acessada diretamente (sem Controller), inicializamos a lista
    if (itensCardapio == null) {
        itensCardapio = java.util.Collections.emptyList();
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Gerenciar Cardápio - <%= pizzaria.getNome() %></title>
    
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
            margin-bottom: 2rem;
        }
        .container {
            width: 90%;
            max-width: 900px;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* Formulário de Cadastro */
        .cadastro-form {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            padding: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            align-items: flex-end;
            flex-wrap: wrap; /* Permite que os itens quebrem a linha */
        }
        .cadastro-form div {
            display: flex;
            flex-direction: column;
            flex-grow: 1; /* Faz com que cresçam para preencher o espaço */
            min-width: 120px; /* Largura mínima */
            flex-basis: 150px; /* Base de largura */
        }
        .cadastro-form label {
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }
        .cadastro-form input[type="text"], 
        .cadastro-form select,
        .cadastro-form textarea {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
            width: 100%; /* Faz o input ocupar o espaço do 'div' */
            box-sizing: border-box; /* Garante que padding não estoure a largura */
        }
        .cadastro-form button {
            background: #4CAF50; 
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.3s;
            height: 38px; /* Alinha altura com os inputs */
            align-self: flex-end;
            min-width: 120px;
        }
        .cadastro-form button:hover {
            background: #45a049;
        }

        /* Tabela */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
            vertical-align: middle; /* Alinha o conteúdo da célula no meio */
        }
        th {
            background-color: #ED5715;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        /* Imagem na Tabela */
        .tabela-imagem {
            width: 80px;
            height: 60px;
            object-fit: cover;
            border-radius: 5px;
            border: 1px solid #eee;
        }

        /* Botões de Ação */
        .acao-btn {
            background: #f44336; /* Vermelho Excluir */
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9em;
            transition: background 0.3s;
            display: inline-block;
            margin-top: 5px; /* Espaço caso quebre a linha */
        }
        .acao-btn:hover {
            background: #d32f2f;
        }
        
        /* --- NOVO ESTILO PARA O BOTÃO ALTERAR --- */
        .acao-btn-editar {
            background: #2196F3; /* Azul */
            margin-right: 5px; /* Espaço entre os botões */
        }
        .acao-btn-editar:hover {
            background: #1976D2;
        }
        /* --- FIM DO NOVO ESTILO --- */
        
        /* Mensagens */
        .mensagem-sucesso, .mensagem-erro {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: bold;
            text-align: center;
        }
        .mensagem-sucesso {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .mensagem-erro {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        /* Link de Voltar */
        .back-link {
            display: inline-block;
            margin-top: 20px;
            background: #ED5715;
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            font-weight: bold;
            transition: background 0.3s;
        }
        .back-link:hover {
            background: #ff3333;
        }
    </style>
</head>
<body>
    <h2>Gerenciar Cardápio</h2>
    
    <div class="container">
        <%-- Exibe a mensagem de sucesso ou erro vinda do Controller --%>
        <% if (mensagem != null) { 
            String cssClass = mensagem.toLowerCase().contains("sucesso") ? "mensagem-sucesso" : "mensagem-erro";
        %>
            <div class="<%= cssClass %>"><%= mensagem %></div>
        <% } %>
        
        <h3>Cadastrar Novo Item</h3>
        
        <form class="cadastro-form" action="CardapioController" method="post">
            <input type="hidden" name="acao" value="cadastrar">
            
            <div>
                <label for="nome">Nome do Item:</label>
                <input type="text" id="nome" name="nome" required placeholder="Ex: Pizza Calabresa">
            </div>
            
            <div>
                <label for="categoria">Categoria:</label>
                <select id="categoria" name="categoria" required>
                    <option value="">-- Selecione --</option>
                    <option value="Pizza Salgada">Pizza Salgada</option>
                    <option value="Pizza Doce">Pizza Doce</option>
                    <option value="Bebida">Bebida</option>
                    <option value="Porção">Porção</option>
                    <option value="Outro">Outro</option>
                </select>
            </div>
            
            <div>
                <label for="preco">Preço (R$):</label>
                <input type="text" id="preco" name="preco" required placeholder="Ex: 45.50">
            </div>
            
            <div style="flex-basis: 100%;"> <%-- Ocupa a linha inteira --%>
                <label for="descricao">Descrição:</label>
                <input type="text" id="descricao" name="descricao" placeholder="Ex: Mussarela, calabresa, cebola e azeitonas">
            </div>
            
            <div style="flex-basis: 100%;"> <%-- Ocupa a linha inteira --%>
                <label for="imagemUrl">URL da Imagem:</label>
                <input type="text" id="imagemUrl" name="imagemUrl" placeholder="http://exemplo.com/imagem.png">
            </div>
            
            <button type="submit">Cadastrar Item</button>
        </form>

        <h3>Itens do Cardápio (<%= itensCardapio.size() %>)</h3>
        <% if (!itensCardapio.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Imagem</th>
                        <th>Nome</th>
                        <th>Categoria</th>
                        <th>Preço</th>
                        <th>Ação</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Loop para exibir cada item do cardápio --%>
                    <% for (vo.ItemCardapio item : itensCardapio) { %>
                    <tr>
                        <td><%= item.getId() %></td>
                        <td>
                            <%-- Exibe a imagem se a URL não estiver vazia --%>
                            <% if (item.getImagemUrl() != null && !item.getImagemUrl().trim().isEmpty()) { %>
                                <img src="<%= item.getImagemUrl() %>" alt="<%= item.getNome() %>" class="tabela-imagem">
                            <% } else { %>
                                (Sem foto)
                            <% } %>
                        </td>
                        <td><%= item.getNome() %></td>
                        <td><%= item.getCategoria() %></td>
                        <td><%= String.format("R$ %.2f", item.getPreco()) %></td>
                        
                        <td>
                            <%-- Botão Alterar (Editar) --%>
                            <a href="CardapioController?acao=carregarEdicao&id=<%= item.getId() %>" 
                                class="acao-btn acao-btn-editar">
                                Alterar
                             </a>
                            
                            <%-- Botão Excluir --%>
                            <a href="CardapioController?acao=excluir&id=<%= item.getId() %>" 
                               class="acao-btn" 
                               onclick="return confirm('Tem certeza que deseja excluir \'<%= item.getNome() %>\'?');">
                                Excluir
                            </a>
                                
                        </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <p>Nenhum item cadastrado no seu cardápio ainda. Use o formulário acima para adicionar.</p>
        <% } %>
    </div>
    <a href="painelPizzaria.jsp" class="back-link">Voltar ao Painel</a>
</body>
</html>