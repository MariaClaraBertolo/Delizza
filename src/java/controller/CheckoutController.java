package controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import connection.Conexao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vo.*;
import dao.PedidoDAO;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("finalizarPedido.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String acao = request.getParameter("acao");

        if ("confirmar".equals(acao)) {
            confirmarPedido(request, response);
        } else {
            response.sendRedirect("verCarrinho.jsp");
        }
    }

    private void confirmarPedido(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<ItemCarrinho> carrinho = (List<ItemCarrinho>) session.getAttribute("carrinho");
        
        Pizzaria pizzaria = (Pizzaria) session.getAttribute("pizzaria");
        int pizzariaId = (pizzaria != null) ? pizzaria.getId() : 5; 

        if (carrinho == null || carrinho.isEmpty()) {
            response.sendRedirect("verCarrinho.jsp");
            return;
        }

        String nomeCliente = request.getParameter("nomeCliente");
        String endereco = request.getParameter("endereco");
        String telefone = request.getParameter("telefone");
        String formaPagamento = request.getParameter("formaPagamento");
        String trocoParaStr = request.getParameter("trocoPara");

        double troco = 0.0;
        try {
            if (formaPagamento != null && formaPagamento.equalsIgnoreCase("dinheiro") && trocoParaStr != null && !trocoParaStr.trim().isEmpty()) {
                troco = Double.parseDouble(trocoParaStr.replace(",", ".").trim());
            }
        } catch (NumberFormatException e) {
             session.setAttribute("statusMensagem", "Formato de troco inválido.");
             response.sendRedirect(request.getContextPath() + "/finalizarPedido.jsp");
             return;
        }

        double valorTotal = carrinho.stream().mapToDouble(ItemCarrinho::getSubtotal).sum();

        Connection conn = null;

        try {
            conn = Conexao.getConnection();
            conn.setAutoCommit(false); // Início da transação

            PedidoDAO pedidoDao = new PedidoDAO(conn);

            // 1. Cadastrar/Achar Cliente - PASSANDO O pizzariaId
            int clienteId = cadastrarOuBuscarCliente(conn, nomeCliente, endereco, telefone, pizzariaId); 

            // 2. Criar Pedido Principal
            Pedido pedido = new Pedido();
            pedido.setClienteId(clienteId);
            pedido.setValorTotal(valorTotal);
            
            if (formaPagamento != null) pedido.setMetodoPagamento(formaPagamento.toUpperCase());
            else pedido.setMetodoPagamento("CARTAO");
            
            pedido.setTroco(troco);
            pedido.setEnderecoEntrega(endereco);
            pedido.setStatus("PENDENTE");

            int pedidoId = pedidoDao.cadastrar(pedido);

            // 3. Salvar Itens e Detalhes Personalizados
            for (ItemCarrinho item : carrinho) {
                
                double valorUnitario = item.getQuantidade() > 0 ? item.getSubtotal() / item.getQuantidade() : item.getSubtotal();
                
                String tipoItem;

                if (item.isItemPersonalizado()) {
                    tipoItem = "PIZZA"; // Pizzas personalizadas são sempre PIZZA
                } else if (item.getItemPronto() != null) {
                    // Mapeia a categoria do cardápio para o ENUM (PIZZA, BEBIDA, PORCAO)
                    tipoItem = mapearCategoriaParaTipoDB(item.getItemPronto().getCategoria()); 
                } else {
                    // Fallback para item genérico (caso não seja personalizado nem do cardápio)
                    tipoItem = "PIZZA";
                }

                // Mapeia o ItemCarrinho para PedidoItem 
                PedidoItem pedidoItem = new PedidoItem();
                pedidoItem.setPedidoId(pedidoId);
                pedidoItem.setTipoItem(tipoItem); // <--- VALOR CORRIGIDO
                pedidoItem.setItemId(item.getItemId()); 
                pedidoItem.setQuantidade(item.getQuantidade());
                pedidoItem.setValorUnitario(valorUnitario);
                
                // Salva o item na tabela pedido_itens e obtém o ID gerado
                int pedidoItemId = pedidoDao.cadastrarPedidoItem(pedidoItem, pedidoId); 
                
                // TRATAMENTO DA PIZZA PERSONALIZADA
                if (item.isItemPersonalizado()) {
                    pedidoDao.cadastrarPizzaPersonalizada(
                        pedidoItemId, 
                        item.getNomePersonalizado(), 
                        item.getIngredientesSelecionados(),
                        item.getSubtotal() 
                    );
                }
            }

            // 4. Finalização
            conn.commit(); // Confirma a transação
            session.removeAttribute("carrinho");

            request.setAttribute("pedidoId", pedidoId);
            request.setAttribute("valorTotal", valorTotal);
            request.setAttribute("nomeCliente", nomeCliente);
            request.getRequestDispatcher("pedidoConfirmado.jsp").forward(request, response);

        } catch (Exception e) {
            // Rollback em caso de falha
            if (conn != null) try { conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
            
            // Passa a mensagem de erro detalhada para o JSP
            String erroDetalhado = "Erro de DB desconhecido.";
            if (e.getMessage() != null) {
                erroDetalhado = e.getMessage().substring(0, Math.min(e.getMessage().length(), 150)); 
            }
            
            request.setAttribute("statusMensagem", "Falha ao confirmar o pedido: " + erroDetalhado);
            request.getRequestDispatcher("finalizarPedido.jsp").forward(request, response);
            
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
    
    /**
     * NOVO MÉTODO: Mapeia categorias do ItemCardapio (Ex: "Porção") para o ENUM do DB (Ex: "PORCAO").
     */
    private String mapearCategoriaParaTipoDB(String categoria) {
        if (categoria == null) return "PIZZA";
        
        String tipo = categoria.toUpperCase();
        
        if (tipo.contains("PIZZA") || tipo.contains("MONTADA")) {
            return "PIZZA";
        }
        if (tipo.contains("BEBIDA") || tipo.contains("AGUA") || tipo.contains("COCA")) {
            return "BEBIDA";
        }
        if (tipo.contains("PORÇÃO") || tipo.contains("PORCAO") || tipo.contains("FRITA")) {
            return "PORCAO";
        }
        
        return "PIZZA"; // Valor de fallback seguro para ENUM
    }

    // Método auxiliar cadastrarOuBuscarCliente - MANTIDO
    private int cadastrarOuBuscarCliente(Connection conn, String nome, String endereco, String telefone, int pizzariaId) throws Exception {
        
        // 1. Tenta buscar o cliente existente
        String sql = "SELECT id FROM clientes WHERE nome = ? AND endereco = ? AND telefone = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
             ps.setString(1, nome);
             ps.setString(2, endereco);
             ps.setString(3, telefone);
             try (ResultSet rs = ps.executeQuery()) {
                 if (rs.next()) return rs.getInt("id");
             }
        }

        // 2. Insere o novo cliente usando a pizzariaId fornecida
        String insert = "INSERT INTO clientes (nome, endereco, telefone, pizzaria_id) VALUES (?, ?, ?, ?)"; 
        try (PreparedStatement psInsert = conn.prepareStatement(insert, PreparedStatement.RETURN_GENERATED_KEYS)) {
            psInsert.setString(1, nome);
            psInsert.setString(2, endereco);
            psInsert.setString(3, telefone);
            psInsert.setInt(4, pizzariaId); 
            
            psInsert.executeUpdate();
            try (ResultSet keys = psInsert.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        throw new Exception("Erro ao cadastrar cliente.");
    }
}