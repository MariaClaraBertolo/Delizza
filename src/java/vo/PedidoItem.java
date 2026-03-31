package vo;

/**
 * Representa um item de linha da tabela 'pedido_itens'.
 * É usado para exibir os detalhes do que foi comprado em um pedido.
 */
public class PedidoItem {

    private int id;
    private int pedidoId;
    private String tipoItem; // Ex: PIZZA, BEBIDA
    private int itemId;      // ID do item pronto no item_cardapio (ou 0 para personalizada)
    private int quantidade;
    private double valorUnitario;

    // Campos auxiliares obtidos via JOIN no DAO (para exibir no JSP)
    private String nomeItem;        // Nome do item (Pizza Calabresa, Coca-Cola, etc.)
    private String descricaoItem;   // Descrição curta ou observações
    
    // Construtor padrão
    public PedidoItem() {
    }

    // --- Getters e Setters ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPedidoId() {
        return pedidoId;
    }

    public void setPedidoId(int pedidoId) {
        this.pedidoId = pedidoId;
    }

    public String getTipoItem() {
        return tipoItem;
    }

    public void setTipoItem(String tipoItem) {
        this.tipoItem = tipoItem;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }

    public double getValorUnitario() {
        return valorUnitario;
    }

    public void setValorUnitario(double valorUnitario) {
        this.valorUnitario = valorUnitario;
    }

    public String getNomeItem() {
        return nomeItem;
    }

    public void setNomeItem(String nomeItem) {
        this.nomeItem = nomeItem;
    }

    public String getDescricaoItem() {
        return descricaoItem;
    }

    public void setDescricaoItem(String descricaoItem) {
        this.descricaoItem = descricaoItem;
    }

    // Opcional: toString para debug
    @Override
    public String toString() {
        return "PedidoItem{" +
                "nomeItem='" + nomeItem + '\'' +
                ", quantidade=" + quantidade +
                ", valorUnitario=" + valorUnitario +
                '}';
    }
}