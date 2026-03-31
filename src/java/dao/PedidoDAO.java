package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import vo.PedidoCompleto;
import vo.Pedido; 
import vo.PedidoItem; 

public class PedidoDAO {
    
    private Connection conn;

    public PedidoDAO(Connection conn) {
        this.conn = conn;
    }

    // ==========================================================
    // MÉTODOS ORIGINAIS (CORRIGIDOS PARA COMPILAÇÃO)
    // ==========================================================
    
    // 1. CADASTRAR NOVO PEDIDO 
    public int cadastrar(Pedido pedido) throws SQLException {
        String sql = "INSERT INTO pedidos (cliente_id, valor_total, metodo_pagamento, troco, endereco_entrega, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        int pedidoId = 0;

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, pedido.getClienteId());
            stmt.setDouble(2, pedido.getValorTotal());
            stmt.setString(3, pedido.getMetodoPagamento()); 
            stmt.setDouble(4, pedido.getTroco());
            stmt.setString(5, pedido.getEnderecoEntrega());
            stmt.setString(6, pedido.getStatus()); 
            
            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    pedidoId = generatedKeys.getInt(1);
                    pedido.setId(pedidoId);
                }
            }
        }
        return pedidoId;
    }

    // 2. LISTAR PEDIDOS COMPLETOS POR PIZZARIA (Resolvendo o erro no PedidoController)
    public List<PedidoCompleto> listarPedidosCompletosPorPizzaria(int pizzariaId) throws SQLException {
        List<PedidoCompleto> pedidos = new ArrayList<>();
        
        String sql = "SELECT p.id, p.data_pedido, p.valor_total, p.metodo_pagamento, p.troco, p.endereco_entrega, p.status, " +
                     "c.nome AS nome_cliente, c.telefone " +
                     "FROM pedidos p " +
                     "JOIN clientes c ON p.cliente_id = c.id " +
                     "WHERE c.pizzaria_id = ? " + 
                     "ORDER BY p.data_pedido DESC"; 
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, pizzariaId); 
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PedidoCompleto p = new PedidoCompleto();
                    p.setId(rs.getInt("id"));
                    p.setDataPedido(rs.getTimestamp("data_pedido"));
                    p.setValorTotal(rs.getDouble("valor_total"));
                    p.setMetodoPagamento(rs.getString("metodo_pagamento"));
                    p.setTroco(rs.getDouble("troco"));
                    p.setEnderecoEntrega(rs.getString("endereco_entrega"));
                    p.setStatus(rs.getString("status"));
                    p.setNomeCliente(rs.getString("nome_cliente"));
                    p.setTelefone(rs.getString("telefone"));
                    
                    pedidos.add(p);
                }
            }
        }
        return pedidos;
    }

    // 3. ATUALIZAR STATUS DO PEDIDO (Resolvendo o erro no AtualizarPedidoController)
    public boolean atualizarStatus(int pedidoId, String novoStatus) throws SQLException {
        if (!novoStatus.equals("CONFIRMADO") && !novoStatus.equals("ENTREGUE") && !novoStatus.equals("PENDENTE")) {
            throw new IllegalArgumentException("Status inválido: " + novoStatus);
        }
        
        String sql = "UPDATE pedidos SET status = ? WHERE id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novoStatus); 
            stmt.setInt(2, pedidoId); 
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
        }
    }

    // 4. BUSCAR POR ID E PIZZARIA (Resolvendo o erro no DetalhePedidoController)
    public PedidoCompleto buscarPorIdEPizzaria(int pedidoId, int pizzariaId) throws SQLException {
        String sql = "SELECT p.id, p.data_pedido, p.valor_total, p.metodo_pagamento, p.troco, p.endereco_entrega, p.status, " +
                     "c.nome AS nome_cliente, c.telefone " +
                     "FROM pedidos p " +
                     "JOIN clientes c ON p.cliente_id = c.id " +
                     "WHERE p.id = ? AND c.pizzaria_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, pedidoId);
            stmt.setInt(2, pizzariaId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    PedidoCompleto p = new PedidoCompleto();
                    p.setId(rs.getInt("id"));
                    p.setDataPedido(rs.getTimestamp("data_pedido"));
                    p.setValorTotal(rs.getDouble("valor_total"));
                    p.setMetodoPagamento(rs.getString("metodo_pagamento"));
                    p.setTroco(rs.getDouble("troco"));
                    p.setEnderecoEntrega(rs.getString("endereco_entrega"));
                    p.setStatus(rs.getString("status"));
                    p.setNomeCliente(rs.getString("nome_cliente"));
                    p.setTelefone(rs.getString("telefone"));
                    return p;
                }
            }
        }
        return null;
    }
    
    // ==========================================================
    // MÉTODOS PARA MANIPULAÇÃO DE ITENS E PIZZAS PERSONALIZADAS (Novos)
    // ==========================================================

    /**
     * Insere um item de pedido na tabela pedido_itens e retorna o ID gerado.
     * Essencial para ligar a pizza personalizada.
     */
    public int cadastrarPedidoItem(PedidoItem item, int pedidoId) throws SQLException {
        String sql = "INSERT INTO pedido_itens (pedido_id, tipo_item, item_id, quantidade, valor_unitario) " +
                     "VALUES (?, ?, ?, ?, ?)";
        int pedidoItemId = 0;

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, pedidoId);
            stmt.setString(2, item.getTipoItem());
            stmt.setInt(3, item.getItemId());
            stmt.setInt(4, item.getQuantidade());
            stmt.setDouble(5, item.getValorUnitario());
            
            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    pedidoItemId = generatedKeys.getInt(1);
                }
            }
        }
        return pedidoItemId;
    }

    /**
     * Insere os detalhes da pizza personalizada na tabela pizzas_personalizadas.
     */
    public void cadastrarPizzaPersonalizada(int pedidoItemId, String nomePersonalizado, String ingredientesSelecionados, double valorCalculado) throws SQLException {
        String sql = "INSERT INTO pizzas_personalizadas (pedido_item_id, nome_personalizado, ingredientes_selecionados, valor_calculado) " +
                     "VALUES (?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, pedidoItemId);
            stmt.setString(2, nomePersonalizado);
            stmt.setString(3, ingredientesSelecionados);
            stmt.setDouble(4, valorCalculado);
            
            stmt.executeUpdate();
        }
    }

    /**
     * Busca os itens detalhados (linha a linha) de um pedido específico.
     * CORRIGIDO: Usa LEFT JOIN e COALESCE para buscar nome e descrição de itens do cardápio E personalizados.
     */
    public List<PedidoItem> buscarItensDoPedido(int pedidoId) throws SQLException {
        List<PedidoItem> itens = new ArrayList<>();
        
        String sql = "SELECT pi.id, pi.tipo_item, pi.item_id, pi.quantidade, pi.valor_unitario, " +
                     // COALESCE para pegar o NOME: 1. Pizza Personalizada | 2. Item Cardapio | 3. Default
                     "COALESCE(pp.nome_personalizado, ic.nome, 'Item Desconhecido (ID: ' || pi.item_id || ')') AS nome_item_final, " +
                     // COALESCE para pegar a DESCRIÇÃO: 1. Ingredientes Personalizados | 2. Descrição Cardapio | 3. NULL
                     "COALESCE(pp.ingredientes_selecionados, ic.descricao, NULL) AS descricao_item_final " +
                     "FROM pedido_itens pi " +
                     // LEFT JOIN para Itens do Cardápio (pizzas, bebidas, etc)
                     "LEFT JOIN item_cardapio ic ON pi.item_id = ic.id " +
                     // NOVO LEFT JOIN para Pizzas Personalizadas (liga pela chave 'pi.id')
                     "LEFT JOIN pizzas_personalizadas pp ON pi.id = pp.pedido_item_id " +
                     "WHERE pi.pedido_id = ?";
                    
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, pedidoId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PedidoItem item = new PedidoItem();
                    item.setId(rs.getInt("id"));
                    item.setTipoItem(rs.getString("tipo_item"));
                    item.setItemId(rs.getInt("item_id")); 
                    item.setQuantidade(rs.getInt("quantidade"));
                    item.setValorUnitario(rs.getDouble("valor_unitario"));
                    
                    item.setNomeItem(rs.getString("nome_item_final"));
                    item.setDescricaoItem(rs.getString("descricao_item_final"));
                    
                    itens.add(item);
                }
            }
        }
        return itens;
    }
}