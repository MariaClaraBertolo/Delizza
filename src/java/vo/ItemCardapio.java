package vo;

public class ItemCardapio {

    // Exatamente os campos da sua tabela MySQL
    private int id;
    private int pizzariaId;
    private String nome;
    private String categoria;
    private double preco;
    private String descricao;
    private String imagemUrl; // Java usa camelCase (imagemUrl)

    // Construtor vazio
    public ItemCardapio() {
    }

    // --- Getters e Setters ---
    // (Necessários para o DAO e a JSP acessarem os dados)

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPizzariaId() {
        return pizzariaId;
    }

    public void setPizzariaId(int pizzariaId) {
        this.pizzariaId = pizzariaId;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public double getPreco() {
        return preco;
    }

    public void setPreco(double preco) {
        this.preco = preco;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getImagemUrl() {
        return imagemUrl;
    }

    public void setImagemUrl(String imagemUrl) {
        this.imagemUrl = imagemUrl;
    }
}