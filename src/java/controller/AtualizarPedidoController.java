package controller;

import java.io.IOException;
import java.sql.Connection;
import dao.PedidoDAO;
import connection.Conexao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vo.Pizzaria; 

@WebServlet("/atualizar-pedido")
public class AtualizarPedidoController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pizzaria pizzaria = (Pizzaria) session.getAttribute("pizzaria");

        // 1. Verificação de Sessão
        if (pizzaria == null) {
            response.sendRedirect("loginPizzaria.jsp");
            return;
        }

        String pedidoIdParam = request.getParameter("pedidoId");
        String novoStatus = request.getParameter("novoStatus");
        String mensagem = null;

        if (pedidoIdParam == null || novoStatus == null || pedidoIdParam.trim().isEmpty() || novoStatus.trim().isEmpty()) {
            mensagem = "Erro: Parâmetros de Pedido ou Status ausentes.";
        } else {
            try {
                int pedidoId = Integer.parseInt(pedidoIdParam);
                
                // 2. Conexão e Atualização do DB
                try (Connection conn = Conexao.getConnection()) {
                    PedidoDAO pedidoDao = new PedidoDAO(conn);
                    
                    if (pedidoDao.atualizarStatus(pedidoId, novoStatus)) {
                        mensagem = "Pedido #" + pedidoId + " atualizado para: " + novoStatus;
                    } else {
                        mensagem = "Erro: Pedido #" + pedidoId + " não foi encontrado ou não pôde ser atualizado.";
                    }
                }

            } catch (NumberFormatException e) {
                mensagem = "Erro: ID do pedido inválido.";
            } catch (Exception e) {
                e.printStackTrace();
                mensagem = "Erro de banco de dados ao atualizar pedido.";
            }
        }

        // 3. Redirecionamento de Volta
        // Redireciona para o Controller de listagem (PedidoController, mapeado para /exibirPedidos)
        request.getSession().setAttribute("statusMensagem", mensagem);
        response.sendRedirect(request.getContextPath() + "/exibirPedidos"); 
    }
}