package dao;

import java.sql.*;
import vo.Pizzaria;

public class PizzariaDAO {
    private Connection conn;

    public PizzariaDAO(Connection conn) {
        this.conn = conn;
    }

    public void cadastrar(Pizzaria p) throws SQLException {
        String sql = "INSERT INTO pizzaria (nome, email, senha) VALUES (?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, p.getNome());
        stmt.setString(2, p.getEmail());
        stmt.setString(3, p.getSenha());
        stmt.executeUpdate();
        stmt.close();
    }

    public Pizzaria login(String email, String senha) throws SQLException {
        String sql = "SELECT * FROM pizzaria WHERE email=? AND senha=?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, email);
        stmt.setString(2, senha);
        ResultSet rs = stmt.executeQuery();
        Pizzaria p = null;
        if (rs.next()) {
            p = new Pizzaria();
            p.setId(rs.getInt("id"));
            p.setNome(rs.getString("nome"));
            p.setEmail(rs.getString("email"));
        }
        rs.close();
        stmt.close();
        return p;
    }
}
