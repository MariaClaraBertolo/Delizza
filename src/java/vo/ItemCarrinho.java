package vo;

import java.util.List;

public class ItemCarrinho {
    
    // Campos principais do carrinho
    private String tipo; // "pronto" ou "personalizada"
    private ItemCardapio itemPronto;
    private int quantidade;
    private double precoBase;
    private double subtotal;
    
    // Campos de composição (se for pizza personalizada)
    private Ingrediente massa;
    private Ingrediente borda;
    private List<Ingrediente> recheios;
    
    // Campos para personalização e persistência
    private boolean itemPersonalizado = false;
    private String nomePersonalizado;
    private String ingredientesSelecionados;

    // Campos adicionais para compatibilidade com PedidoItem/DAO
    private int itemId; // ID do ItemCardapio ou 0 para personalizado
    private double valorUnitario; // Preço por unidade (Subtotal / Quantidade)

    // --- Getters e Setters dos Campos Principais ---
    
    public String getTipo() { 
        return tipo; 
    }
    public void setTipo(String tipo) { 
        this.tipo = tipo; 
    }

    public ItemCardapio getItemPronto() { 
        return itemPronto; 
    }
    public void setItemPronto(ItemCardapio itemPronto) { 
        this.itemPronto = itemPronto; 
    }

    public Ingrediente getMassa() { 
        return massa; 
    }
    public void setMassa(Ingrediente massa) { 
        this.massa = massa; 
    }

    public Ingrediente getBorda() { 
        return borda; 
    }
    public void setBorda(Ingrediente borda) { 
        this.borda = borda; 
    }

    public List<Ingrediente> getRecheios() { 
        return recheios; 
    }
    public void setRecheios(List<Ingrediente> recheios) { 
        this.recheios = recheios; 
    }

    public int getQuantidade() { 
        return quantidade; 
    }
    public void setQuantidade(int quantidade) { 
        this.quantidade = quantidade; 
    }

    public double getPrecoBase() { 
        return precoBase; 
    }
    public void setPrecoBase(double precoBase) { 
        this.precoBase = precoBase; 
    }

    public double getSubtotal() { 
        return subtotal; 
    }
    public void setSubtotal(double subtotal) { 
        this.subtotal = subtotal; 
    }
    
    // --- Getters e Setters de Personalização ---

    public boolean isItemPersonalizado() {
        return itemPersonalizado;
    }

    public void setItemPersonalizado(boolean itemPersonalizado) {
        this.itemPersonalizado = itemPersonalizado;
    }

    public String getNomePersonalizado() {
        return nomePersonalizado;
    }

    public void setNomePersonalizado(String nomePersonalizado) {
        this.nomePersonalizado = nomePersonalizado;
    }

    public String getIngredientesSelecionados() {
        return ingredientesSelecionados;
    }

    public void setIngredientesSelecionados(String ingredientesSelecionados) {
        this.ingredientesSelecionados = ingredientesSelecionados;
    }
    
    // --- MÉTODOS DE ADAPTAÇÃO PARA O CHECKOUT/DAO ---
    
    /**
     * Retorna o tipo de item para o ENUM do DB (ex: PIZZA, BEBIDA).
     * O valor é setado no Controller (MontarPizzaController) ou lido do cardápio.
     */
    public String getTipoItem() { 
        // Se o tipo for nulo, tenta inferir do item pronto ou usa "PIZZA" como fallback
        if (this.tipo != null && !this.tipo.isEmpty()) {
            return this.tipo;
        }
        // Se item pronto existe, usa a categoria dele (assumindo que já foi mapeada)
        if (this.itemPronto != null && this.itemPronto.getCategoria() != null) {
            return this.itemPronto.getCategoria();
        }
        return "PIZZA"; 
    }
    
    public void setTipoItem(String tipoItem) {
        // Armazena o tipo de DB no campo 'tipo'
        this.tipo = tipoItem; 
    }

    /**
     * Retorna o ID do Item (do Cardapio) ou 0/ID interno para item personalizado.
     */
    public int getItemId() {
        if (itemPronto != null) {
            return itemPronto.getId(); 
        }
        return itemId;
    }
    
    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public double getValorUnitario() {
        return valorUnitario;
    }

    public void setValorUnitario(double valorUnitario) {
        this.valorUnitario = valorUnitario;
    }
}