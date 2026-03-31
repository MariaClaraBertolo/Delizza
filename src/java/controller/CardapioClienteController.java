package controller;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import dao.ItemCardapioDAO;
import dao.IngredienteDAO;
import vo.ItemCardapio;
import vo.Ingrediente;
import connection.Conexao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/cardapio")
public class CardapioClienteController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pizzariaIdParam = request.getParameter("pizzaria");
        // Definimos o valor padrão como 5, que é onde seus dados estão.
        int pizzariaId = 5; 

        List<ItemCardapio> itensCardapio = null;
        List<Ingrediente> ingredientes = null;
        String mensagem = null;

        // 1. Tenta obter o ID da URL. Se for nulo ou inválido, usa o padrão 5.
        if (pizzariaIdParam != null && !pizzariaIdParam.trim().isEmpty()) {
            try {
                pizzariaId = Integer.parseInt(pizzariaIdParam);
            } catch (NumberFormatException e) {
                // Se o parâmetro for inválido (ex: "abc"), usa o padrão 5 e seta a mensagem.
                mensagem = "ID da pizzaria inválido (" + pizzariaIdParam + "). Carregando ID padrão (5).";
            }
        } else {
            // Se o parâmetro não foi passado, usa o padrão 5 e seta a mensagem.
            mensagem = "Nenhum ID de pizzaria informado. Carregando ID padrão (5).";
        }

        // 2. Realiza a busca no banco de dados.
        try (Connection conn = Conexao.getConnection()) {
            
            if (conn == null) {
                throw new Exception("Falha ao obter conexão com o banco de dados.");
            }

            // Busca os itens do cardápio pronto (pizzas, bebidas, porções)
            ItemCardapioDAO itemDao = new ItemCardapioDAO(conn);
            itensCardapio = itemDao.listarPorPizzaria(pizzariaId);

            // Busca os ingredientes para a função 'Monte Sua Pizza'
            IngredienteDAO ingDao = new IngredienteDAO(conn);
            ingredientes = ingDao.listarPorPizzaria(pizzariaId);

            // 3. Verifica se a busca resultou em lista vazia.
            if (itensCardapio.isEmpty()) {
                // Se não tinha uma mensagem de erro de ID, cria uma nova.
                if (mensagem == null || mensagem.contains("Carregando ID padrão")) {
                    mensagem = "Cardápio vazio para a Pizzaria (ID: " + pizzariaId + ").";
                }
            } else {
                // Se a busca teve sucesso E havia uma mensagem de ID (ex: ID inválido, mas carregou ID 5), 
                // limpamos a mensagem ou a tornamos informativa.
                if (mensagem != null) {
                     mensagem = "Cardápio carregado com sucesso (ID: " + pizzariaId + ").";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            mensagem = "Erro interno ao carregar o cardápio. Tente novamente mais tarde.";
        }

        // 4. Define os atributos na requisição
        request.setAttribute("mensagem", mensagem);
        request.setAttribute("itensCardapio", itensCardapio);
        request.setAttribute("ingredientes", ingredientes);
        request.setAttribute("pizzariaId", String.valueOf(pizzariaId)); 

        RequestDispatcher rd = request.getRequestDispatcher("/cardapioCliente.jsp");
        rd.forward(request, response);
    }
}