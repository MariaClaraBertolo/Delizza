package controller;

import java.sql.Connection;
import dao.PizzariaDAO;
import vo.Pizzaria;
import connection.Conexao;
import jakarta.servlet.RequestDispatcher;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PizzariaController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String acao = request.getParameter("acao");

    try (Connection conn = Conexao.getConnection()) {
           PizzariaDAO dao = new PizzariaDAO(conn);


            if ("cadastrar".equals(acao)) {
                Pizzaria p = new Pizzaria();
                p.setNome(request.getParameter("nome"));
                p.setEmail(request.getParameter("email"));
                p.setSenha(request.getParameter("senha"));
                dao.cadastrar(p);
                response.sendRedirect("loginPizzaria.jsp");

            } else if ("login".equals(acao)) {
                String email = request.getParameter("email");
                String senha = request.getParameter("senha");
                Pizzaria p = dao.login(email, senha);

                if (p != null) {
                    HttpSession sessao = request.getSession();
                    sessao.setAttribute("pizzaria", p);
                    response.sendRedirect("painelPizzaria.jsp");
                } else {
                    request.setAttribute("erro", "E-mail ou senha inválidos!");
                    RequestDispatcher rd = request.getRequestDispatcher("loginPizzaria.jsp");
                    rd.forward(request, response);
                }
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
