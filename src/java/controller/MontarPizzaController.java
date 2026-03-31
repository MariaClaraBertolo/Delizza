package controller;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import java.util.ArrayList; 
import java.util.Arrays;
import java.util.stream.Collectors;
import connection.Conexao;
import dao.IngredienteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vo.Ingrediente;
import vo.ItemCarrinho;
import java.util.Map;

@WebServlet("/montar-pizza")
public class MontarPizzaController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pizzariaParam = request.getParameter("pizzaria");
        if (pizzariaParam == null || pizzariaParam.trim().isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        int pizzariaId = Integer.parseInt(pizzariaParam);

        List<Ingrediente> ingredientes = null;

        try (Connection conn = Conexao.getConnection()) {
            IngredienteDAO dao = new IngredienteDAO(conn);
            ingredientes = dao.listarPorPizzaria(pizzariaId);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao carregar ingredientes.");
        }

        request.setAttribute("ingredientes", ingredientes);
        request.setAttribute("pizzariaId", pizzariaId);
        request.getRequestDispatcher("montarPizza.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        
        String pizzariaParam = request.getParameter("pizzaria"); 
        int pizzariaId = 0;
        try {
            pizzariaId = Integer.parseInt(pizzariaParam);
        } catch (NumberFormatException e) { /* Ignorar se não for um número */ }

        // Campos enviados do formulário (IDs e String de Detalhes)
        String nomePizza = request.getParameter("nomePizzaMontada");
        String ingredientesString = request.getParameter("ingredientesSelecionados");
        
        double valorCalculadoServidor = 0.0;
        
        // Coleta todos os IDs de ingredientes submetidos
        List<Integer> idsSelecionados = new ArrayList<>();
        
        // 1. Coletar IDs de Radio (Massa, Borda)
        String massaIdStr = request.getParameter("massaId");
        String bordaIdStr = request.getParameter("bordaId");

        if (massaIdStr != null && !massaIdStr.isEmpty()) idsSelecionados.add(Integer.parseInt(massaIdStr));
        // Adiciona borda apenas se não for vazio (sem borda)
        if (bordaIdStr != null && !bordaIdStr.isEmpty()) idsSelecionados.add(Integer.parseInt(bordaIdStr)); 

        // 2. Coletar IDs de Checkbox (Recheios, Outros)
        String[] recheioIds = request.getParameterValues("recheioIds");
        String[] outroIds = request.getParameterValues("outroIds");
        
        if (recheioIds != null) {
            idsSelecionados.addAll(Arrays.stream(recheioIds).map(Integer::parseInt).collect(Collectors.toList()));
        }
        if (outroIds != null) {
            idsSelecionados.addAll(Arrays.stream(outroIds).map(Integer::parseInt).collect(Collectors.toList()));
        }

        // 3. RECÁLCULO SEGURO NO SERVIDOR
        try (Connection conn = Conexao.getConnection()) {
            IngredienteDAO dao = new IngredienteDAO(conn);
            
            // Busca os preços apenas dos IDs submetidos
            Map<Integer, Double> precoPorId = dao.buscarPrecosPorIds(idsSelecionados);
            
            // Soma os preços dos IDs encontrados
            valorCalculadoServidor = idsSelecionados.stream()
                .mapToDouble(id -> precoPorId.getOrDefault(id, 0.0)) // Pega o preço mapeado ou 0.0
                .sum();

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("statusMensagem", "Erro interno ao calcular o preço da pizza no servidor.");
            response.sendRedirect(request.getContextPath() + "/montar-pizza?pizzaria=" + pizzariaId);
            return;
        }

        // 4. Cria e salva o ItemCarrinho
        ItemCarrinho item = new ItemCarrinho();
        item.setItemId(0); 
        item.setTipoItem("PIZZA"); 
        item.setQuantidade(1);
        
        // Usa o valor calculado pelo SERVIDOR
        item.setValorUnitario(valorCalculadoServidor); 
        item.setSubtotal(valorCalculadoServidor); 
        
        item.setItemPersonalizado(true);
        item.setNomePersonalizado(nomePizza != null && !nomePizza.isEmpty() ? nomePizza : "Pizza Montada");
        item.setIngredientesSelecionados(ingredientesString); 
        
        // 5. Adiciona ao carrinho
        @SuppressWarnings("unchecked")
        List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");
        if (carrinho == null) {
            carrinho = new ArrayList<>();
            session.setAttribute("carrinho", carrinho);
        }
        carrinho.add(item);
        
        session.setAttribute("statusMensagem", "Pizza adicionada ao carrinho! Total recalculado: R$" + String.format("%.2f", valorCalculadoServidor));
        
        response.sendRedirect(request.getContextPath() + "/carrinho");
    }
    
    // O método auxiliar calcularPrecoTotal foi removido, pois a lógica foi embutida no doPost.
}