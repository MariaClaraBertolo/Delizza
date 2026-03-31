<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="vo.Ingrediente, java.util.*" %>
<%
    @SuppressWarnings("unchecked")
    List<Ingrediente> ingredientes = (List<Ingrediente>) request.getAttribute("ingredientes");
    Integer pizzariaId = (Integer) request.getAttribute("pizzariaId");
    
    if (ingredientes == null) ingredientes = Collections.emptyList();
    if (pizzariaId == null) pizzariaId = 5;
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Monte Sua Pizza</title>
    <style>
        /* Paleta de Cores Original (vermelho/laranja e fundo bege) */
        :root {
            --primary-color: #ED5715; /* Laranja/Vermelho (Original H1) */
            --highlight-color: #F8B400; /* Amarelo/Ouro para Destaque */
            --background-color: #EFE4B0; /* Bege/Amarelo Claro (Original Body) */
            --text-color: #333;
        }
        body {
            font-family: Arial, sans-serif;
            background: var(--background-color);
            padding: 20px;
            margin: 0;
            color: var(--text-color);
        }
        h1 {
            color: var(--primary-color);
            text-align: center;
            font-size: 2.5rem;
            border-bottom: 2px solid #ccc;
            padding-bottom: 10px;
            margin-bottom: 30px;
        }
        h2 {
            color: var(--text-color);
            font-size: 1.5rem;
            margin-top: 30px;
            margin-bottom: 15px;
            text-align: left;
            border-left: 5px solid var(--highlight-color);
            padding-left: 10px;
        }
        .container {
            max-width: 900px;
            margin: 20px auto;
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .secao {
            margin-bottom: 40px;
        }
        /* GRID Simples */
        .ingredientes {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 15px;
        }
        .ing {
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 4px;
            text-align: center;
            cursor: pointer;
            transition: border-color 0.2s, background-color 0.2s;
        }
        /* Esconde o radio/checkbox padrão */
        .ing input[type="radio"], .ing input[type="checkbox"] {
            display: none;
        }
        /* Estiliza o Label */
        .ing label {
            display: block;
            font-weight: bold;
            padding: 8px 0;
            line-height: 1.4;
            cursor: pointer;
        }
        .ing small {
            display: block;
            font-weight: normal;
            color: #666;
            font-size: 0.85em;
        }
        /* Feedback Visual (Selecionado) - Usa a cor de destaque (Amarelo/Ouro) */
        .ing input:checked + label {
            background-color: var(--highlight-color);
            color: var(--text-color); /* Mantém o texto escuro para contraste */
            border-radius: 2px;
        }
        
        /* Feedback Visual (Hover) - Usa a cor primária (Laranja/Vermelho) */
        .ing:hover {
            border-color: var(--primary-color);
        }
        /* Botão */
        .btn {
            background: var(--primary-color);
            color: white;
            padding: 15px 30px;
            font-size: 1.1em;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            margin-top: 20px;
            transition: background-color 0.2s;
        }
        .btn:hover {
            background: #D3470F; /* Versão um pouco mais escura da primary-color */
        }
        /* Link de Voltar */
        .link-voltar {
            text-align: center;
            margin-top: 20px;
        }
        
        .link-voltar a {
            color: var(--primary-color);
            text-decoration: none;
            font-size: 0.9em;
        }
        
        .link-voltar a:hover {
            text-decoration: underline;
        }
        .total-area {
            text-align: right;
            font-size: 1.5em;
            margin-top: 20px;
            font-weight: bold;
            color: #4CAF50;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Monte Sua Pizza</h1>
    
    <form action="<%= request.getContextPath() %>/montar-pizza" method="post" id="formMontarPizza">
        <input type="hidden" name="acao" value="adicionarPersonalizada">
        
        <input type="hidden" name="valorCalculado" id="valorCalculado">
        <input type="hidden" name="ingredientesSelecionados" id="ingredientesSelecionados">
        <input type="hidden" name="nomePizzaMontada" id="nomePizzaMontada">

        <div class="secao">
            <h2>1. Escolha a Massa (obrigatório)</h2>
            <div class="ingredientes">
                <% for (Ingrediente i : ingredientes) {
                    if ("Massa".equals(i.getTipo())) { %>
                    <div class="ing">
                        <input type="radio" id="massa-<%= i.getId() %>" name="massaId" value="<%= i.getId() %>" data-nome="<%= i.getNome() %>" data-tipo="Massa" data-preco="<%= i.getPreco() %>" required onchange="calcularTotal()">
                        <label for="massa-<%= i.getId() %>">
                            <%= i.getNome() %><small>R$ <%= String.format("%.2f", i.getPreco()).replace(",", ".") %></small>
                        </label>
                    </div>
                <% }} %>
            </div>
        </div>
        <div class="secao">
            <h2>2. Borda (opcional)</h2>
            <div class="ingredientes">
                <% for (Ingrediente i : ingredientes) {
                    if ("Borda".equals(i.getTipo())) { %>
                    <div class="ing">
                        <input type="radio" id="borda-<%= i.getId() %>" name="bordaId" value="<%= i.getId() %>" data-nome="<%= i.getNome() %>" data-tipo="Borda" data-preco="<%= i.getPreco() %>" onchange="calcularTotal()">
                        <label for="borda-<%= i.getId() %>">
                            <%= i.getNome() %><small>R$ <%= String.format("%.2f", i.getPreco()).replace(",", ".") %></small>
                        </label>
                    </div>
                <% }} %>
                <div class="ing">
                    <input type="radio" id="borda-none" name="bordaId" value="" data-nome="Sem Borda" data-tipo="Borda" data-preco="0.00" checked onchange="calcularTotal()">
                    <label for="borda-none">
                        Sem Borda<small>R$ 0,00</small>
                    </label>
                </div>
            </div>
        </div>
        <div class="secao">
            <h2>3. Recheios (quantos quiser)</h2>
            <div class="ingredientes">
                <% for (Ingrediente i : ingredientes) {
                    if (i.getTipo().contains("Recheio")) { %>
                    <div class="ing">
                        <input type="checkbox" id="recheio-<%= i.getId() %>" name="recheioIds" value="<%= i.getId() %>" data-nome="<%= i.getNome() %>" data-tipo="Recheio" data-preco="<%= i.getPreco() %>" onchange="calcularTotal()">
                        <label for="recheio-<%= i.getId() %>">
                            <%= i.getNome() %><small>R$ <%= String.format("%.2f", i.getPreco()).replace(",", ".") %></small>
                        </label>
                    </div>
                <% }} %>
            </div>
        </div>
        <div class="secao">
            <h2>4. Outros Ingredientes (opcional)</h2>
            <div class="ingredientes">
                <% for (Ingrediente i : ingredientes) {
                    if ("Outro".equals(i.getTipo())) { %>
                    <div class="ing">
                        <input type="checkbox" id="outro-<%= i.getId() %>" name="outroIds" value="<%= i.getId() %>" data-nome="<%= i.getNome() %>" data-tipo="Outro" data-preco="<%= i.getPreco() %>" onchange="calcularTotal()">
                        <label for="outro-<%= i.getId() %>">
                            <%= i.getNome() %><small>R$ <%= String.format("%.2f", i.getPreco()).replace(",", ".") %></small>
                        </label>
                    </div>
                <% }} %>
            </div>
        </div>
        
        <div class="total-area">
            Total Calculado: <span id="totalDisplay">R$ 0,00</span>
        </div>
        
        <button type="submit" class="btn">Adicionar ao Carrinho</button>
    </form>
    <div class="link-voltar">
        <a href="<%= request.getContextPath() %>/cardapio?pizzaria=<%= pizzariaId %>">
            Voltar ao Cardápio
        </a>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', calcularTotal); // Calcula ao carregar
    
    function calcularTotal() {
        let total = 0.0;
        let detalhes = "Pizza Montada\n";
        let recheios = [];
        let outros = [];
        let massaNome = "";
        let bordaNome = "";
        
        // --- 1. Processar Ingredientes ---
        
        document.querySelectorAll('input:checked').forEach(input => {
            const preco = parseFloat(input.dataset.preco) || 0;
            const nome = input.dataset.nome;
            const tipo = input.dataset.tipo;
            
            total += preco;

            if (tipo === "Massa") {
                massaNome = nome;
            } else if (tipo === "Borda") {
                bordaNome = nome;
            } else if (tipo === "Recheio") {
                recheios.push(nome);
            } else if (tipo === "Outro") {
                outros.push(nome);
            }
        });

        // --- 2. Construir String de Detalhes (ingredientesSelecionados) ---
        
        // Adiciona Massa e Borda
        detalhes += "Massa: " + (massaNome || 'Não selecionada') + "\n";
        if (bordaNome && bordaNome !== "Sem Borda") {
            detalhes += "Borda: " + bordaNome + "\n";
        }
        
        // Adiciona Recheios
        if (recheios.length > 0) {
            detalhes += "Recheios: " + recheios.join(', ') + "\n";
        }

        // Adiciona Outros
        if (outros.length > 0) {
            detalhes += "Outros: " + outros.join(', ') + "\n";
        }
        
        // --- 3. Atualizar Campos Ocultos ---

        // Define um nome básico para a pizza (opcional, mas bom para exibição)
        let nomeFinal = "Pizza Montada (" + (massaNome || 'Sem Massa') + ")";
        if (recheios.length > 0) {
             nomeFinal += " c/ " + recheios[0];
        }
        
        document.getElementById('valorCalculado').value = total.toFixed(2);
        document.getElementById('ingredientesSelecionados').value = detalhes.trim();
        document.getElementById('nomePizzaMontada').value = nomeFinal;
        
        // --- 4. Atualizar Display ---
        document.getElementById('totalDisplay').textContent = "R$ " + total.toFixed(2).replace('.', ',');
    }
</script>
</body>
</html>