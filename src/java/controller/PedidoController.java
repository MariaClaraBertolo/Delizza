package controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import connection.Conexao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vo.*;
import dao.PedidoDAO; // Importar o DAO

@WebServlet("/exibirPedidos") 
public class PedidoController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        listarPedidosDaPizzaria(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Se alguém enviar um POST para /exibirPedidos (ex: após a ação de atualizar), ele lista.
        listarPedidosDaPizzaria(request, response); 
    }

    private void listarPedidosDaPizzaria(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pizzaria pizzaria = (Pizzaria) session.getAttribute("pizzaria");
        String mensagem = null; 
        
        if (pizzaria == null) {
            response.sendRedirect("loginPizzaria.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        List<PedidoCompleto> pedidos = new ArrayList<>();
        
        // 1. RECUPERA MENSAGENS DE STATUS (vindo do AtualizarPedidoController)
        mensagem = (String) session.getAttribute("statusMensagem");
        if (mensagem != null) {
            session.removeAttribute("statusMensagem");
        }

        try (Connection conn = Conexao.getConnection()) {

            // 2. BUSCA OS PEDIDOS USANDO O DAO
            PedidoDAO pedidoDao = new PedidoDAO(conn);
            pedidos = pedidoDao.listarPedidosCompletosPorPizzaria(pizzaria.getId());

        } catch (Exception e) {
            e.printStackTrace();
            mensagem = "Erro ao carregar pedidos: " + e.getMessage();
        }

        request.setAttribute("pedidos", pedidos);
        request.setAttribute("mensagem", mensagem);
        
        // 3. Encaminha para o JSP
        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/exibirPedidos.jsp");
        rd.forward(request, response);
    }
}