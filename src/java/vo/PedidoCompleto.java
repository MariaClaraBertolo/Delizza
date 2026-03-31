package vo;

import java.util.Date;

public class PedidoCompleto {
    private int id;
    private Date dataPedido;
    private double valorTotal;
    private String metodoPagamento;
    private double troco;
    private String status;
    private String nomeCliente;
    private String telefone;
    private String enderecoEntrega;

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Date getDataPedido() { return dataPedido; }
    public void setDataPedido(Date dataPedido) { this.dataPedido = dataPedido; }
    public double getValorTotal() { return valorTotal; }
    public void setValorTotal(double valorTotal) { this.valorTotal = valorTotal; }
    public String getMetodoPagamento() { return metodoPagamento; }
    public void setMetodoPagamento(String metodoPagamento) { this.metodoPagamento = metodoPagamento; }
    public double getTroco() { return troco; }
    public void setTroco(double troco) { this.troco = troco; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getNomeCliente() { return nomeCliente; }
    public void setNomeCliente(String nomeCliente) { this.nomeCliente = nomeCliente; }
    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }
    public String getEnderecoEntrega() { return enderecoEntrega; }
    public void setEnderecoEntrega(String enderecoEntrega) { this.enderecoEntrega = enderecoEntrega; }
}