package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import vo.Ingrediente;

public class IngredienteDAO {
    private final Connection conn;

    public IngredienteDAO(Connection conn) {
        this.conn = conn;
    }

    // --- CADASTRAR / LISTAR / ATUALIZAR / EXCLUIR (Mantidos) ---
    // ... (Mantenha aqui os métodos de CRUD que você já tem) ...

    // --- LISTAR POR PIZZARIA --- 
    public List<Ingrediente> listarPorPizzaria(int pizzariaId) throws SQLException {
        List<Ingrediente> lista = new ArrayList<>();
        String sql = "SELECT id, nome, tipo, pizzaria_id, quantidade_estoque, unidade_medida, preco " +
                     "FROM ingrediente WHERE pizzaria_id = ? ORDER BY tipo, nome";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, pizzariaId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    // Usa o método auxiliar
                    lista.add(mapearIngrediente(rs));
                }
            }
        }
        return lista;
    }
    
    // --- NOVO MÉTODO CRUCIAL PARA CÁLCULO DE PREÇO NO SERVIDOR ---
    /**
     * Busca os precos de um conjunto de IDs para cálculo de preço total.
     * @param ids Uma lista de IDs de ingredientes selecionados.
     * @return Um Map<Integer, Double> mapeando ID do ingrediente para seu Preço.
     */
    public Map<Integer, Double> buscarPrecosPorIds(List<Integer> ids) throws SQLException {
        Map<Integer, Double> precoPorId = new HashMap<>();
        if (ids == null || ids.isEmpty()) {
            return precoPorId;
        }

        // Converte a lista de IDs em uma string de placeholders (?, ?, ?)
        String placeholders = String.join(",", Collections.nCopies(ids.size(), "?"));
        
        String sql = "SELECT id, preco FROM ingrediente WHERE id IN (" + placeholders + ")";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < ids.size(); i++) {
                stmt.setInt(i + 1, ids.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    precoPorId.put(rs.getInt("id"), rs.getDouble("preco"));
                }
            }
        }
        return precoPorId;
    }


    // --- Métodos de Busca por ID (Unificados) ---
    public Ingrediente buscarPorId(int id, int pizzariaId) throws SQLException {
        String sql = "SELECT id, nome, tipo, quantidade_estoque, unidade_medida, preco, pizzaria_id " +
                     "FROM ingrediente WHERE id = ? AND pizzaria_id = ?";
        // ... (Corpo do método, usando mapearIngrediente)
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.setInt(2, pizzariaId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapearIngrediente(rs);
                }
            }
        }
        return null;
    }
    
    public Ingrediente buscarPorId(int id) throws SQLException {
        String sql = "SELECT id, nome, tipo, pizzaria_id, quantidade_estoque, unidade_medida, preco " +
                     "FROM ingrediente WHERE id = ?";
        // ... (Corpo do método, usando mapearIngrediente)
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapearIngrediente(rs);
                }
            }
        }
        return null;
    }
    
    // --- Método auxiliar para mapear o ResultSet ---
    private Ingrediente mapearIngrediente(ResultSet rs) throws SQLException {
        Ingrediente ing = new Ingrediente();
        ing.setId(rs.getInt("id"));
        ing.setNome(rs.getString("nome"));
        ing.setTipo(rs.getString("tipo"));
        ing.setPizzariaId(rs.getInt("pizzaria_id")); 
        ing.setQuantidadeEstoque(rs.getDouble("quantidade_estoque"));
        ing.setUnidadeMedida(rs.getString("unidade_medida"));
        ing.setPreco(rs.getDouble("preco"));
        return ing;
    }

    public void excluir(int id, int id0) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void atualizar(Ingrediente ingrediente) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void cadastrar(Ingrediente novo) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}