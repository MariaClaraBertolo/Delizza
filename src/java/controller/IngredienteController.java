package controller;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import java.util.Collections; // Para Collections.emptyList()
import dao.IngredienteDAO;
import vo.Pizzaria;
import vo.Ingrediente;
import connection.Conexao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // Adicionado, se necessário mapear no web.xml
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Adicione o mapeamento (se não estiver no web.xml)
@WebServlet("/gerenciarIngredientes") 
public class IngredienteController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processaRequisicao(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processaRequisicao(request, response);
    }

    private void processaRequisicao(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pizzaria pizzaria = (Pizzaria) session.getAttribute("pizzaria");
        
        // Garante que o encoding é UTF-8 para nomes e strings
        request.setCharacterEncoding("UTF-8"); 

        if (pizzaria == null) {
            response.sendRedirect("loginPizzaria.jsp");
            return;
        }

        String acao = request.getParameter("acao");
        String mensagem = null;
        List<Ingrediente> ingredientes = Collections.emptyList(); // Inicializa como lista vazia
        
        // Declaração externa para ser usada no finally
        Connection conn = null; 

        try {
            conn = Conexao.getConnection();
            IngredienteDAO dao = new IngredienteDAO(conn);

            // --- PREPARAR ALTERAÇÃO ---
            if ("prepararAlteracao".equals(acao)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.trim().isEmpty()) {
                    int id = Integer.parseInt(idStr);
                    // Usa o método buscarPorId com segurança (ID e Pizzaria ID)
                    Ingrediente ingrediente = dao.buscarPorId(id, pizzaria.getId()); 
                    if (ingrediente != null) {
                        request.setAttribute("ingredienteEdicao", ingrediente);
                        mensagem = "Editando: " + ingrediente.getNome();
                    } else {
                        mensagem = "Erro: Ingrediente não encontrado ou não pertence a esta pizzaria.";
                    }
                }
            }

            // --- CADASTRAR / ATUALIZAR / EXCLUIR --- (A lógica de parsing está correta aqui)

            else if ("cadastrar".equals(acao) && "POST".equalsIgnoreCase(request.getMethod())) {
                // ... (Lógica de Cadastro - Mantida) ...
                String nome = request.getParameter("nome");
                String tipo = request.getParameter("tipo");
                String quantidadeStr = request.getParameter("quantidadeEstoque");
                String unidade = request.getParameter("unidadeMedida");
                String precoStr = request.getParameter("preco");

                if (nome != null && !nome.trim().isEmpty() &&
                    tipo != null && !tipo.trim().isEmpty() &&
                    quantidadeStr != null && !quantidadeStr.trim().isEmpty() &&
                    unidade != null && !unidade.trim().isEmpty() &&
                    precoStr != null && !precoStr.trim().isEmpty()) {

                    double quantidade = Double.parseDouble(quantidadeStr.replace(",", "."));
                    double preco = Double.parseDouble(precoStr.replace(",", "."));

                    Ingrediente novo = new Ingrediente();
                    novo.setNome(nome);
                    novo.setTipo(tipo);
                    novo.setPizzariaId(pizzaria.getId());
                    novo.setQuantidadeEstoque(quantidade);
                    novo.setUnidadeMedida(unidade);
                    novo.setPreco(preco);

                    dao.cadastrar(novo);
                    mensagem = "Sucesso: Ingrediente '" + nome + "' cadastrado!";
                } else {
                    mensagem = "Erro: Todos os campos são obrigatórios.";
                }
            }

            else if ("atualizar".equals(acao) && "POST".equalsIgnoreCase(request.getMethod())) {
                // ... (Lógica de Atualização - Mantida) ...
                String idStr = request.getParameter("id");
                String nome = request.getParameter("nome");
                String tipo = request.getParameter("tipo");
                String quantidadeStr = request.getParameter("quantidadeEstoque");
                String unidade = request.getParameter("unidadeMedida");
                String precoStr = request.getParameter("preco");

                if (idStr != null && !idStr.trim().isEmpty() &&
                    nome != null && !nome.trim().isEmpty() &&
                    tipo != null && !tipo.trim().isEmpty() &&
                    quantidadeStr != null && !quantidadeStr.trim().isEmpty() &&
                    unidade != null && !unidade.trim().isEmpty() &&
                    precoStr != null && !precoStr.trim().isEmpty()) {

                    int id = Integer.parseInt(idStr);
                    double quantidade = Double.parseDouble(quantidadeStr.replace(",", "."));
                    double preco = Double.parseDouble(precoStr.replace(",", "."));

                    Ingrediente ingrediente = new Ingrediente();
                    ingrediente.setId(id);
                    ingrediente.setNome(nome);
                    ingrediente.setTipo(tipo);
                    ingrediente.setQuantidadeEstoque(quantidade);
                    ingrediente.setUnidadeMedida(unidade);
                    ingrediente.setPreco(preco);
                    ingrediente.setPizzariaId(pizzaria.getId());

                    dao.atualizar(ingrediente);
                    mensagem = "Sucesso: Ingrediente atualizado!";
                } else {
                    mensagem = "Erro: Falha ao atualizar. Todos os campos são obrigatórios.";
                }
            }

            else if ("excluir".equals(acao)) {
                // ... (Lógica de Exclusão - Mantida) ...
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.trim().isEmpty()) {
                    int id = Integer.parseInt(idStr);
                    dao.excluir(id, pizzaria.getId());
                    mensagem = "Sucesso: Ingrediente excluído.";
                }
            }
            
            // --- LISTAR SEMPRE (No final do bloco try) ---
            ingredientes = dao.listarPorPizzaria(pizzaria.getId());

        } catch (NumberFormatException e) {
            mensagem = "Erro: Formato inválido (número). Use ponto como separador decimal. Detalhe: " + e.getMessage();
            // Mantém a lista vazia para evitar NullPointer no JSP, se houver um erro de conexão/dados antes
        } catch (Exception e) {
            e.printStackTrace();
            mensagem = "Erro no servidor: Falha de DB/Sistema. Detalhe: " + e.getMessage();
            // Mantém a lista vazia
        } finally {
             // 5. Fecha a conexão
             if (conn != null) {
                 try {
                    conn.close();
                 } catch (Exception e) {
                     e.printStackTrace();
                 }
             }
        }

        request.setAttribute("mensagem", mensagem);
        request.setAttribute("ingredientes", ingredientes);
        RequestDispatcher rd = request.getRequestDispatcher("gerenciarIngredientes.jsp");
        rd.forward(request, response);
    }

    // O método recarregarLista foi integrado ao try/catch principal e removido.
}