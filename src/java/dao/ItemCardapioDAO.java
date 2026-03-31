package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import vo.ItemCardapio; // Importe o seu VO

public class ItemCardapioDAO {
    
    private Connection conn;

    public ItemCardapioDAO(Connection conn) {
        this.conn = conn;
    }

    // --- 1. CADASTRAR ---
    public void cadastrar(ItemCardapio item) throws SQLException {
        // SQL alinhado com as colunas do banco (MySQL)
        String sql = "INSERT INTO item_cardapio (pizzaria_id, nome, categoria, preco, descricao, imagem_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        
        // Define os parâmetros
        stmt.setInt(1, item.getPizzariaId());
        stmt.setString(2, item.getNome());
        stmt.setString(3, item.getCategoria());
        stmt.setDouble(4, item.getPreco());
        stmt.setString(5, item.getDescricao());
        stmt.setString(6, item.getImagemUrl());
        
        stmt.executeUpdate();
        
        // Pega o ID gerado pelo banco
        try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
            if (generatedKeys.next()) {
                item.setId(generatedKeys.getInt(1));
            }
        }
        stmt.close();
    }

    // --- 2. LISTAR POR PIZZARIA ---
    public List<ItemCardapio> listarPorPizzaria(int pizzariaId) throws SQLException {
        List<ItemCardapio> itens = new ArrayList<>();
        
        // SQL alinhado com as colunas do banco
        String sql = "SELECT id, nome, categoria, preco, descricao, imagem_url " +
                     "FROM item_cardapio WHERE pizzaria_id = ? " +
                     "ORDER BY categoria, nome";
                     
        PreparedStatement stmt = conn.prepareStatement(sql);
        // CORREÇÃO AQUI: O índice do primeiro '?' é 1.
        stmt.setInt(1, pizzariaId); 
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            ItemCardapio item = new ItemCardapio();
            item.setId(rs.getInt("id"));
            item.setNome(rs.getString("nome"));
            item.setCategoria(rs.getString("categoria"));
            item.setPreco(rs.getDouble("preco"));
            item.setDescricao(rs.getString("descricao"));
            item.setImagemUrl(rs.getString("imagem_url")); // Banco usa snake_case
            item.setPizzariaId(pizzariaId); // Já sabemos o ID da pizzaria
            
            itens.add(item);
        }
        rs.close();
        stmt.close();
        return itens;
    }

    // --- 3. ATUALIZAR ---
    public void atualizar(ItemCardapio item) throws SQLException {
        String sql = "UPDATE item_cardapio SET nome = ?, categoria = ?, preco = ?, " +
                     "descricao = ?, imagem_url = ? " +
                     "WHERE id = ? AND pizzaria_id = ?"; // Segurança
                     
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, item.getNome());
        stmt.setString(2, item.getCategoria());
        stmt.setDouble(3, item.getPreco());
        stmt.setString(4, item.getDescricao());
        stmt.setString(5, item.getImagemUrl());
        stmt.setInt(6, item.getId());
        stmt.setInt(7, item.getPizzariaId()); // Garante que só atualize o item da pizzaria certa
        
        stmt.executeUpdate();
        stmt.close();
    }

    // --- 4. EXCLUIR ---
    public void excluir(int id, int pizzariaId) throws SQLException {
        String sql = "DELETE FROM item_cardapio WHERE id = ? AND pizzaria_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, id);
        stmt.setInt(2, pizzariaId); // Garante que só exclua o item da pizzaria certa
        stmt.executeUpdate();
        stmt.close();
    }
    
    // --- 5. BUSCAR POR ID (Necessário para a edição) ---
    public ItemCardapio buscarPorId(int id) throws SQLException {
        String sql = "SELECT id, pizzaria_id, nome, categoria, preco, descricao, imagem_url " +
                     "FROM item_cardapio WHERE id = ?";
                     
        PreparedStatement stmt = conn.prepareStatement(sql);
        // CORREÇÃO AQUI: O índice do primeiro '?' é 1.
        stmt.setInt(1, id);
        ResultSet rs = stmt.executeQuery();
        
        ItemCardapio item = null;
        
        if (rs.next()) {
            item = new ItemCardapio();
            item.setId(rs.getInt("id"));
            item.setPizzariaId(rs.getInt("pizzaria_id")); // Precisamos do pizzaria_id para segurança no Controller
            item.setNome(rs.getString("nome"));
            item.setCategoria(rs.getString("categoria"));
            item.setPreco(rs.getDouble("preco"));
            item.setDescricao(rs.getString("descricao"));
            item.setImagemUrl(rs.getString("imagem_url"));
        }
        
        rs.close();
        stmt.close();
        return item; // Retorna o item encontrado ou null se não encontrar
    }
}