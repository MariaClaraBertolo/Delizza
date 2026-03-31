package controller;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import dao.PedidoDAO;
import connection.Conexao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vo.PedidoCompleto;
import vo.PedidoItem; // Classe que representa uma linha na tabela 'pedido_itens'
import vo.Pizzaria;

@WebServlet("/detalhePedido")
public class DetalhePedidoController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. SEGURANÇA: Verifica se a pizzaria está logada
        Pizzaria pizzaria = (Pizzaria) request.getSession().getAttribute("pizzaria");
        if (pizzaria == null) {
            response.sendRedirect("loginPizzaria.jsp");
            return;
        }

        String pedidoIdStr = request.getParameter("pedidoId");
        int pedidoId = 0;

        try {
            pedidoId = Integer.parseInt(pedidoIdStr);

            try (Connection conn = Conexao.getConnection()) {
                PedidoDAO pedidoDao = new PedidoDAO(conn);

                // 2. Busca o pedido principal e valida se ele pertence à pizzaria
                // (Presume-se que PedidoDAO tem este método para segurança)
                PedidoCompleto pedido = pedidoDao.buscarPorIdEPizzaria(pedidoId, pizzaria.getId());
                
                if (pedido == null) {
                    request.setAttribute("mensagemErro", "Pedido não encontrado ou não pertence a esta pizzaria.");
                    // Encaminha de volta à tela de pedidos com erro
                    request.getRequestDispatcher("/WEB-INF/exibirPedidos.jsp").forward(request, response);
                    return;
                }

                // 3. Busca os itens detalhados do pedido
                List<PedidoItem> itensDoPedido = pedidoDao.buscarItensDoPedido(pedidoId);

                // 4. Configura os atributos para o JSP
                request.setAttribute("pedido", pedido);
                request.setAttribute("itensDoPedido", itensDoPedido);
                request.setAttribute("pizzaria", pizzaria); // Garante o nome da pizzaria

                // 5. Encaminha para a página de detalhes
                request.getRequestDispatcher("/WEB-INF/detalhePedido.jsp").forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("mensagemErro", "Erro interno ao buscar detalhes do pedido.");
                // Redireciona de volta à lista de pedidos em caso de erro no DB
                response.sendRedirect(request.getContextPath() + "/exibirPedidos");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", "ID do pedido inválido.");
            response.sendRedirect(request.getContextPath() + "/exibirPedidos");
        }
    }
}