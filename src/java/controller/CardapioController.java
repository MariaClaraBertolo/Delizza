package controller;

import java.sql.Connection;
import dao.ItemCardapioDAO; 
import vo.ItemCardapio;
import vo.Pizzaria;
import connection.Conexao;
import jakarta.servlet.RequestDispatcher;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Lembre-se de adicionar a anotação se ainda não o fez
// @WebServlet("/CardapioController") 
public class CardapioController extends HttpServlet {
    private static final long serialVersionUID = 5L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET é usado para carregar páginas e excluir
        processaRequisicao(request, response, "GET");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST é usado para cadastrar e atualizar dados de formulário
        processaRequisicao(request, response, "POST");
    }

    private void processaRequisicao(HttpServletRequest request, HttpServletResponse response, String metodoHttp)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Pizzaria pizzaria = (Pizzaria) session.getAttribute("pizzaria");

        if (pizzaria == null) {
            response.sendRedirect("loginPizzaria.jsp");
            return;
        }

        String acao = request.getParameter("acao");
        String mensagem = null;
        List<ItemCardapio> itensCardapio = null; 

        try (Connection conn = Conexao.getConnection()) {
            ItemCardapioDAO dao = new ItemCardapioDAO(conn);

            // --- 2. Lógica de Ações ---
            
            // --- CADASTRAR (Método POST) ---
            if ("cadastrar".equals(acao) && "POST".equals(metodoHttp)) {
                
                String nome = request.getParameter("nome");
                String categoria = request.getParameter("categoria");
                String precoStr = request.getParameter("preco");
                String descricao = request.getParameter("descricao");
                String imagemUrl = request.getParameter("imagemUrl"); 

                if (nome != null && !nome.trim().isEmpty() && 
                    categoria != null && !categoria.trim().isEmpty() &&
                    precoStr != null && !precoStr.trim().isEmpty()) {
                    
                    double preco = Double.parseDouble(precoStr.replace(",", "."));

                    ItemCardapio novoItem = new ItemCardapio();
                    novoItem.setNome(nome);
                    novoItem.setCategoria(categoria);
                    novoItem.setPreco(preco);
                    novoItem.setDescricao(descricao);
                    novoItem.setImagemUrl(imagemUrl);
                    novoItem.setPizzariaId(pizzaria.getId()); 
                    
                    dao.cadastrar(novoItem); // Requer DAO
                    mensagem = "Sucesso: Item '" + nome + "' cadastrado!";
                } else {
                    mensagem = "Erro: Nome, Categoria e Preço são obrigatórios.";
                }
            
            // --- ATUALIZAR (Método POST) ---
            } else if ("atualizar".equals(acao) && "POST".equals(metodoHttp)) {
                
                String idStr = request.getParameter("id");
                String nome = request.getParameter("nome");
                String categoria = request.getParameter("categoria");
                String precoStr = request.getParameter("preco");
                String descricao = request.getParameter("descricao");
                String imagemUrl = request.getParameter("imagemUrl");

                if (idStr != null && !idStr.trim().isEmpty() &&
                    nome != null && !nome.trim().isEmpty() && 
                    categoria != null && !categoria.trim().isEmpty() &&
                    precoStr != null && !precoStr.trim().isEmpty()) {
                    
                    int id = Integer.parseInt(idStr);
                    double preco = Double.parseDouble(precoStr.replace(",", "."));

                    ItemCardapio item = new ItemCardapio();
                    item.setId(id);
                    item.setNome(nome);
                    item.setCategoria(categoria);
                    item.setPreco(preco);
                    item.setDescricao(descricao);
                    item.setImagemUrl(imagemUrl);
                    item.setPizzariaId(pizzaria.getId()); 

                    dao.atualizar(item); // Requer DAO
                    mensagem = "Sucesso: Item atualizado!";
                } else {
                    mensagem = "Erro: Falha ao atualizar. Campos obrigatórios inválidos.";
                }

            // --- EXCLUIR (Método GET) ---
            } else if ("excluir".equals(acao) && "GET".equals(metodoHttp)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.excluir(id, pizzaria.getId()); // Requer DAO
                mensagem = "Sucesso: Item excluído do cardápio.";
            
            // --- NOVO: CARREGAR ITEM PARA EDIÇÃO (Método GET) ---
            } else if ("carregarEdicao".equals(acao) && "GET".equals(metodoHttp)) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    
                    // 1. Buscar o item no banco (Este método precisa ser criado no DAO!)
                    ItemCardapio itemParaEditar = dao.buscarPorId(id); // Requer DAO
                    
                    // 2. Verificar se o item pertence à pizzaria logada (Segurança)
                    if (itemParaEditar != null && itemParaEditar.getPizzariaId() == pizzaria.getId()) {
                        // 3. Enviar o item para a página JSP
                        request.setAttribute("itemParaEditar", itemParaEditar);
                        // 4. Encaminhar para a página de edição
                        RequestDispatcher rd = request.getRequestDispatcher("editarItemCardapio.jsp");
                        rd.forward(request, response);
                        return; // Importante: parar a execução aqui
                    } else {
                        // Se não encontrou ou não pertence à pizzaria
                        mensagem = "Erro: Item não encontrado ou não pertence à sua pizzaria.";
                    }
                } catch (Exception e) {
                    mensagem = "Erro ao carregar item para edição.";
                    e.printStackTrace();
                }
            } 
            
            // --- 3. Carregar a lista ATUALIZADA de itens (Ação Padrão) ---
            // Sempre executa se não for 'carregarEdicao'
            itensCardapio = dao.listarPorPizzaria(pizzaria.getId());

        } catch (NumberFormatException e) {
            mensagem = "Erro: Formato de número inválido (ID ou preço).";
            e.printStackTrace(); 
            // Tenta recarregar a lista mesmo se houver erro
            try (Connection conn = Conexao.getConnection()) {
                ItemCardapioDAO dao = new ItemCardapioDAO(conn);
                itensCardapio = dao.listarPorPizzaria(pizzaria.getId());
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace(); 
            mensagem = "Erro: Ocorreu um problema no servidor. " + e.getMessage();
            // Tenta recarregar a lista
            try (Connection conn = Conexao.getConnection()) {
                ItemCardapioDAO dao = new ItemCardapioDAO(conn);
                itensCardapio = dao.listarPorPizzaria(pizzaria.getId());
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        
        // --- 4. Encaminhar para a JSP de listagem ---
        request.setAttribute("mensagem", mensagem);
        request.setAttribute("itensCardapio", itensCardapio); 
        
        // Redireciona para a listagem
        RequestDispatcher rd = request.getRequestDispatcher("gerenciarCardapio.jsp"); 
        rd.forward(request, response);
    }
}