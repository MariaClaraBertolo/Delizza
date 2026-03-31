<%@ page contentType="text/html" pageEncoding="UTF-8" session="true"%>
<%@ page import="vo.Pizzaria" %>
<%@ page import="vo.ItemCardapio" %> <%-- Importa o VO do item --%>
<%
    // 1. Verificação de Sessão
    vo.Pizzaria pizzaria = (vo.Pizzaria) session.getAttribute("pizzaria");
    if (pizzaria == null) {
        response.sendRedirect("loginPizzaria.jsp");
        return;
    }

    // 2. Recebe o item que o Controller (acao="carregarEdicao") enviou
    vo.ItemCardapio item = (vo.ItemCardapio) request.getAttribute("itemParaEditar");
    
    // 3. Recebe uma mensagem de erro, se houver (ex: falha na busca)
    String mensagem = (String) request.getAttribute("mensagem");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Editar Item - <%= (item != null) ? item.getNome() : "Erro" %></title>
    
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
        .cadastro-form {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            padding: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            align-items: flex-end;
            flex-wrap: wrap; 
        }
        .cadastro-form div {
            display: flex;
            flex-direction: column;
            flex-grow: 1; 
            min-width: 120px; 
            flex-basis: 150px; 
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
            width: 100%; 
            box-sizing: border-box; 
        }
        
        /* Cor do botão de salvar alteração (Verde) */
        .cadastro-form button {
            background: #4CAF50; /* Verde */
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background 0.3s;
            height: 38px; 
            align-self: flex-end;
            min-width: 120px;
        }
        .cadastro-form button:hover {
            background: #45a049;
        }

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
    
    <%-- 
      Verifica se o item foi carregado. Se 'item' for nulo, 
      mostra uma mensagem de erro.
    --%>
    <% if (item != null) { %>
    
        <h2>Editar Item: <%= item.getNome() %></h2>
        <div class="container">
            
            <%-- Formulário de Edição --%>
            <form class="cadastro-form" action="CardapioController" method="post">
                
                <input type="hidden" name="acao" value="atualizar">
                <input type="hidden" name="id" value="<%= item.getId() %>">
                
                <div>
                    <label for="nome">Nome do Item:</label>
                    <input type="text" id="nome" name="nome" required 
                           value="<%= item.getNome() %>">
                </div>
                
                <div>
                    <label for="categoria">Categoria:</label>
                    <select id="categoria" name="categoria" required>
                        <option value="">-- Selecione --</option>
                        <option value="Pizza Salgada" <%= "Pizza Salgada".equals(item.getCategoria()) ? "selected" : "" %>>Pizza Salgada</option>
                        <option value="Pizza Doce"    <%= "Pizza Doce".equals(item.getCategoria()) ? "selected" : "" %>>Pizza Doce</option>
                        <option value="Bebida"        <%= "Bebida".equals(item.getCategoria()) ? "selected" : "" %>>Bebida</option>
                        <option value="Porção"        <%= "Porção".equals(item.getCategoria()) ? "selected" : "" %>>Porção</option>
                        <option value="Outro"         <%= "Outro".equals(item.getCategoria()) ? "selected" : "" %>>Outro</option>
                    </select>
                </div>
                
                <div>
                    <label for="preco">Preço (R$):</label>
                    <input type="text" id="preco" name="preco" required 
                           value="<%= item.getPreco() %>" placeholder="Ex: 45.50">
                </div>
                
                <div style="flex-basis: 100%;">
                    <label for="descricao">Descrição:</label>
                    <input type="text" id="descricao" name="descricao" 
                           value="<%= (item.getDescricao() != null) ? item.getDescricao() : "" %>" 
                           placeholder="Ex: Mussarela, calabresa, cebola e azeitonas">
                </div>
                
                <div style="flex-basis: 100%;">
                    <label for="imagemUrl">URL da Imagem:</label>
                    <input type="text" id="imagemUrl" name="imagemUrl" 
                           value="<%= (item.getImagemUrl() != null) ? item.getImagemUrl() : "" %>" 
                           placeholder="http://exemplo.com/imagem.png">
                </div>
                
                <button type="submit">Salvar Alterações</button>
            </form>
            
        </div>
        
    <% } else { %>
        
        <%-- 
          Se 'item' for nulo, exibe a mensagem de erro que o 
          Controller enviou (ou uma padrão).
        --%>
        <h2>Erro ao Carregar Item</h2>
        <div class="container">
            <div class="mensagem-erro">
                <%= (mensagem != null) ? mensagem : "O item que você está tentando editar não foi encontrado ou não pertence à sua pizzaria." %>
            </div>
        </div>
        
    <% } %>
    
    <a href="CardapioController" class="back-link">Voltar ao Cardápio</a>
</body>
</html>