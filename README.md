# 🍕 Delizza - Sistema de Gerenciamento de Pizzaria

**Delizza** é uma aplicação web desenvolvida em **Java** com **JSP e Servlets** que permite a gestão de uma pizzaria, oferecendo dois perfis de acesso:

- **Pizzaria (administrador)** – responsável por cadastrar pizzas prontas e ingredientes disponíveis para montagem personalizada.
- **Cliente** – visualiza o cardápio e pode montar sua própria pizza a partir dos ingredientes cadastrados.

O projeto foi desenvolvido no **Apache NetBeans** e utiliza o padrão MVC (Model-View-Controller) com persistência em banco de dados relacional.

---

## 🚀 Tecnologias Utilizadas

- **Java 11+**
- **JSP / Servlets** (páginas dinâmicas)
- **Apache Tomcat** (servidor de aplicação)
- **MySQL** (banco de dados)
- **HTML5, CSS3** (front-end)
- **NetBeans IDE** (ambiente de desenvolvimento)

---

## 📋 Pré-requisitos

Antes de executar o projeto, certifique-se de ter instalado:

- JDK 11 ou superior
- Apache Tomcat 9+
- MySQL Server
- NetBeans IDE (recomendado para importar o projeto)

---

## ⚙️ Como Executar

1. **Clone o repositório**  
   ```bash
   git clone https://github.com/seu-usuario/delizza.git
   ```

2. **Importe o projeto no NetBeans**  
   - Abra o NetBeans → `File` → `Open Project` → selecione a pasta do projeto.

3. **Configure o banco de dados**  
   - Crie um banco de dados MySQL (ex.: `pizzaria_delizza_db`).  
   - Execute o script SQL localizado em `/db/pizzaria_delizza.sql` para criar as tabelas e inserir dados iniciais.  
   - Configure as credenciais de acesso no arquivo `src/main/java/util/Conexao.java`.

4. **Configure o servidor Tomcat**  
   - No NetBeans, adicione o Apache Tomcat em `Services` → `Servers` → `Add Server`.  
   - Selecione o Tomcat e defina a pasta de instalação.

5. **Execute o projeto**  
   - Clique com o botão direito sobre o projeto → `Run`.  
   - Acesse a aplicação em: [http://localhost:8080/delizza/](http://localhost:8080/delizza/)

---


## 👩‍💻 Contribuidores

- **Elisandra Carol da Silva** – Desenvolvimento completo do sistema, desde a modelagem do banco até a implementação das regras de negócio e interface.
- **Maria Clara Bertolo Soares** – Desenvolvimento completo do sistema, desde a modelagem do banco até a implementação das regras de negócio e interface.

---

## 📄 Licença

Este projeto é de uso acadêmico e não possui licença definida. Para mais informações, entre em contato com os autores.
