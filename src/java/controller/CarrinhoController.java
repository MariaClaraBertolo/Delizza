package controller;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import dao.IngredienteDAO;
import dao.ItemCardapioDAO;
import connection.Conexao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vo.*;

@WebServlet("/carrinho")
public class CarrinhoController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String acao = request.getParameter("acao");
        HttpSession session = request.getSession();

        if ("limpar".equals(acao)) {
            session.removeAttribute("carrinho");
        }

        response.sendRedirect("verCarrinho.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");
        if (carrinho == null) carrinho = new ArrayList<>();

        String acao = request.getParameter("acao");

        try (Connection conn = Conexao.getConnection()) {
            ItemCardapioDAO itemDao = new ItemCardapioDAO(conn);
            IngredienteDAO ingDao = new IngredienteDAO(conn);

            if ("adicionarPronto".equals(acao)) {
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                ItemCardapio item = itemDao.buscarPorId(itemId);

                if (item != null) {
                    ItemCarrinho ic = new ItemCarrinho();
                    ic.setTipo("pronto");
                    ic.setItemPronto(item);
                    ic.setQuantidade(1);
                    ic.setSubtotal(item.getPreco());
                    carrinho.add(ic);
                }

            } else if ("adicionarPersonalizada".equals(acao)) {
                
                double precoTotal = 0.0;
                
                // --- 1. MASSA (Obrigatória) ---
                String massaParam = request.getParameter("massaId");
                if (massaParam == null || massaParam.isEmpty()) {
                    // Se a massa não veio, aborta a adição.
                    request.setAttribute("mensagem", "Massa obrigatória não selecionada.");
                    throw new IllegalArgumentException("Massa não fornecida.");
                }

                int massaId = Integer.parseInt(massaParam);
                Ingrediente massa = ingDao.buscarPorId(massaId);
                
                // CORREÇÃO: Verifica se a massa foi encontrada no DB
                if (massa == null) {
                    request.setAttribute("mensagem", "Massa selecionada inválida.");
                    throw new Exception("Massa com ID " + massaId + " não encontrada.");
                }

                precoTotal += massa.getPreco();

                // Cria o ItemCarrinho
                ItemCarrinho ic = new ItemCarrinho();
                ic.setTipo("personalizada");
                ic.setMassa(massa);
                ic.setRecheios(new ArrayList<>()); // Inicializa a lista de recheios
                
                // --- 2. BORDA (Opcional) ---
                String bordaParam = request.getParameter("bordaId");
                if (bordaParam != null && !bordaParam.isEmpty()) {
                    int bordaId = Integer.parseInt(bordaParam);
                    Ingrediente borda = ingDao.buscarPorId(bordaId);
                    
                    // CORREÇÃO: Verifica se a borda foi encontrada
                    if (borda != null) {
                        ic.setBorda(borda);
                        precoTotal += borda.getPreco();
                    }
                }

                // --- 3. RECHEIOS ---
                String[] recheiosIds = request.getParameterValues("recheioIds");
                if (recheiosIds != null) {
                    List<Ingrediente> recheios = new ArrayList<>();
                    for (String idStr : recheiosIds) {
                        int id = Integer.parseInt(idStr);
                        Ingrediente rec = ingDao.buscarPorId(id);
                        
                        // CORREÇÃO: Verifica se o recheio foi encontrado
                        if (rec != null) {
                            recheios.add(rec);
                            precoTotal += rec.getPreco();
                        }
                    }
                    ic.setRecheios(recheios);
                }

                // --- 4. FINALIZAÇÃO ---
                ic.setQuantidade(1);
                // CORREÇÃO: O subtotal é o total de todos os ingredientes somados (precoTotal)
                ic.setSubtotal(precoTotal);
                
                // Se o ItemCarrinho tiver um setPrecoBase(), você pode querer removê-lo
                // ou usá-lo para armazenar precoTotal
                // ic.setPrecoBase(precoTotal); 
                
                carrinho.add(ic);
            }

            session.setAttribute("carrinho", carrinho);
            request.setAttribute("mensagem", "Item adicionado ao carrinho!");

        } catch (Exception e) {
            // Se cair aqui, a requisição foi abortada. O carrinho não é alterado.
            e.printStackTrace();
            // A mensagem de erro será exibida na tela do carrinho.
            // Para não perder a mensagem, você pode passá-la para o redirecionamento via Session
            session.setAttribute("erroCarrinho", request.getAttribute("mensagem") != null ? 
                                                 request.getAttribute("mensagem") : "Erro desconhecido ao adicionar item.");
        }

        response.sendRedirect("verCarrinho.jsp");
    }
}