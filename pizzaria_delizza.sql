-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 31/03/2026 às 03:21
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `pizzaria_delizza`
--
CREATE DATABASE IF NOT EXISTS `pizzaria_delizza` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `pizzaria_delizza`;

-- --------------------------------------------------------

--
-- Estrutura para tabela `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `endereco` varchar(255) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `numero_pedido` int(11) DEFAULT NULL,
  `pizzaria_id` int(11) NOT NULL DEFAULT 5
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `clientes`
--

INSERT INTO `clientes` (`id`, `nome`, `endereco`, `telefone`, `numero_pedido`, `pizzaria_id`) VALUES
(1, 'lula mulusco', 'Rua Domingos Pedraci, 67\r\nnsoasoidas', '11986325741', NULL, 5),
(4, 'hanna montana', 'bla bla bla', '14998562356', NULL, 5),
(5, 'teste', 'sfsdf', '165489451202', NULL, 5),
(20, 'Teste23548959', 'asdewea', '11984610641', NULL, 5),
(21, 'Teste23548960', 'scfhsdfunfhsdhh', '11984610641', NULL, 5),
(22, 'luana', 'antonio marcato 212', '14998940708', NULL, 5),
(23, 'Elisandra', 'Rua Antônio Marcato, 10\r\n', '14998562356', NULL, 5);

-- --------------------------------------------------------

--
-- Estrutura para tabela `ingrediente`
--

CREATE TABLE `ingrediente` (
  `id` int(11) NOT NULL,
  `pizzaria_id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `tipo` enum('Massa','Borda','Recheio Salgado','Recheio Doce','Outro') NOT NULL,
  `quantidade_estoque` decimal(10,2) DEFAULT 0.00,
  `unidade_medida` varchar(20) DEFAULT NULL,
  `preco` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `ingrediente`
--

INSERT INTO `ingrediente` (`id`, `pizzaria_id`, `nome`, `tipo`, `quantidade_estoque`, `unidade_medida`, `preco`) VALUES
(8, 5, 'queijo', 'Recheio Salgado', 5.00, 'kg', 4.00),
(9, 5, 'Nutella ', 'Recheio Doce', 1.00, 'kg', 5.50),
(11, 5, 'Mandioca ', 'Massa', 60.00, 'unidades', 30.00),
(12, 5, 'Catupiry ', 'Borda', 5.00, 'kg', 3.00),
(13, 5, 'azeitona', 'Outro', 5.00, 'kg', 1.50),
(14, 5, 'frango', 'Recheio Salgado', 10.00, 'kg', 6.00),
(15, 5, 'calabresa', 'Recheio Salgado', 4.00, 'kg', 5.50),
(16, 5, 'chocolate branco', 'Recheio Doce', 3.00, 'kg', 6.50),
(17, 5, 'chocolate', 'Borda', 3.00, 'kg', 4.00),
(18, 5, 'batata', 'Massa', 90.00, 'unidaades', 30.00),
(19, 5, 'cheddar ', 'Borda', 2.00, 'kg', 3.00),
(20, 5, 'farinha de trigo', 'Massa', 60.00, 'unidades', 27.00);

-- --------------------------------------------------------

--
-- Estrutura para tabela `item_cardapio`
--

CREATE TABLE `item_cardapio` (
  `id` int(11) NOT NULL,
  `pizzaria_id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `categoria` varchar(50) NOT NULL,
  `preco` decimal(10,2) NOT NULL DEFAULT 0.00,
  `descricao` varchar(255) DEFAULT NULL,
  `imagem_url` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Despejando dados para a tabela `item_cardapio`
--

INSERT INTO `item_cardapio` (`id`, `pizzaria_id`, `nome`, `categoria`, `preco`, `descricao`, `imagem_url`) VALUES
(1, 5, 'Pizza Calabresa', 'Pizza Salgada', 70.00, 'Massa, Molho, Mussarela, Calabresa, Cebola, azeitona.', 'https://www.sabornamesa.com.br/media/k2/items/cache/513d7a0ab11e38f7bd117d760146fed3_XL.jpg'),
(4, 5, 'Água Mineral ', 'Bebida', 3.00, 'Água Mineral S\\Gás', 'https://tse4.mm.bing.net/th/id/OIP.f3a6uHIXMeK8OFVUiUy40gHaHa?rs=1&pid=ImgDetMain&o=7&rm=3'),
(5, 5, 'Coca Cola', 'Bebida', 5.00, 'Coca Lata 350ml', 'https://cdn.dooca.store/418/products/coca.jpg?v=1589835707&webp=0'),
(6, 5, 'Batata Frita c\\ Bacon Cheddar', 'Porção', 25.00, 'Porção de batata com bacon e cheddar 350 gramas', 'https://tse4.mm.bing.net/th/id/OIP.u4VRic2fMonLJjnIV8EcFwHaHa?rs=1&pid=ImgDetMain&o=7&rm=3'),
(8, 5, 'Pizza 4 Queijos', 'Pizza Salgada', 80.00, 'Massa, Molho, Mussarela, Provolone, Catupiry, Parmesão. ', 'https://tse3.mm.bing.net/th/id/OIP.A-rG3XC6lqK-mLF-KLPF6QHaE8?rs=1&pid=ImgDetMain&o=7&rm=3');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pedidos`
--

CREATE TABLE `pedidos` (
  `id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `data_pedido` datetime DEFAULT current_timestamp(),
  `valor_total` decimal(10,2) DEFAULT 0.00,
  `metodo_pagamento` enum('CARTAO','PIX','DINHEIRO') NOT NULL,
  `troco` decimal(10,2) DEFAULT 0.00,
  `endereco_entrega` varchar(255) DEFAULT NULL,
  `status` enum('PENDENTE','CONFIRMADO','ENTREGUE') DEFAULT 'PENDENTE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `pedidos`
--

INSERT INTO `pedidos` (`id`, `cliente_id`, `data_pedido`, `valor_total`, `metodo_pagamento`, `troco`, `endereco_entrega`, `status`) VALUES
(15, 20, '2025-11-23 14:53:19', 41.50, 'DINHEIRO', 50.00, 'asdewea', 'ENTREGUE'),
(16, 21, '2025-11-23 14:57:13', 117.50, 'CARTAO', 0.00, 'scfhsdfunfhsdhh', 'ENTREGUE'),
(17, 22, '2025-11-23 15:10:02', 49.00, 'CARTAO', 0.00, 'antonio marcato 212', 'ENTREGUE'),
(18, 23, '2025-11-24 13:58:03', 48.00, 'DINHEIRO', 100.00, 'Rua Antônio Marcato, 10\r\nblabla', 'ENTREGUE');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pedido_itens`
--

CREATE TABLE `pedido_itens` (
  `id` int(11) NOT NULL,
  `pedido_id` int(11) NOT NULL,
  `tipo_item` enum('PIZZA','BEBIDA','PORCAO') NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL DEFAULT 1,
  `valor_unitario` decimal(10,2) NOT NULL,
  `pizza_personalizada_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `pedido_itens`
--

INSERT INTO `pedido_itens` (`id`, `pedido_id`, `tipo_item`, `item_id`, `quantidade`, `valor_unitario`, `pizza_personalizada_id`) VALUES
(12, 15, 'PIZZA', 0, 1, 41.50, NULL),
(13, 16, 'BEBIDA', 5, 1, 5.00, NULL),
(14, 16, 'PIZZA', 0, 1, 50.00, NULL),
(15, 16, 'PORCAO', 6, 1, 25.00, NULL),
(16, 16, 'PIZZA', 0, 1, 37.50, NULL),
(17, 17, 'BEBIDA', 5, 1, 5.00, NULL),
(18, 17, 'PIZZA', 0, 1, 44.00, NULL),
(19, 18, 'BEBIDA', 5, 1, 5.00, NULL),
(20, 18, 'PIZZA', 0, 1, 43.00, NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `pizzaria`
--

CREATE TABLE `pizzaria` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pizzaria`
--

INSERT INTO `pizzaria` (`id`, `nome`, `email`, `senha`) VALUES
(5, 'Pizza', 'pizza@gmail.com', 'pizza');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pizzas_personalizadas`
--

CREATE TABLE `pizzas_personalizadas` (
  `id` int(11) NOT NULL,
  `pedido_item_id` int(11) NOT NULL,
  `nome_personalizado` varchar(100) DEFAULT 'Pizza Personalizada',
  `tamanho` varchar(50) DEFAULT NULL,
  `borda` varchar(100) DEFAULT NULL,
  `ingredientes_selecionados` text NOT NULL COMMENT 'Lista de ingredientes selecionados, formatada com quebras de linha',
  `valor_calculado` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `pizzas_personalizadas`
--

INSERT INTO `pizzas_personalizadas` (`id`, `pedido_item_id`, `nome_personalizado`, `tamanho`, `borda`, `ingredientes_selecionados`, `valor_calculado`) VALUES
(1, 12, 'Pizza Montada (farinha de trigo) c/ frango', NULL, NULL, 'Pizza Montada\r\nMassa: farinha de trigo\r\nBorda: Catupiry \r\nRecheios: frango, queijo\r\nOutros: azeitona', 41.50),
(2, 14, 'Pizza Montada (batata) c/ calabresa', NULL, NULL, 'Pizza Montada\r\nMassa: batata\r\nBorda: Catupiry \r\nRecheios: calabresa, frango, queijo\r\nOutros: azeitona', 50.00),
(3, 16, 'Pizza Montada (farinha de trigo) c/ chocolate branco', NULL, NULL, 'Pizza Montada\r\nMassa: farinha de trigo\r\nBorda: chocolate\r\nRecheios: chocolate branco', 37.50),
(4, 18, 'Pizza Montada (batata) c/ calabresa', NULL, NULL, 'Pizza Montada\r\nMassa: batata\r\nBorda: Catupiry \r\nRecheios: calabresa, queijo\r\nOutros: azeitona', 44.00),
(5, 20, 'Pizza Montada (farinha de trigo) c/ calabresa', NULL, NULL, 'Pizza Montada\r\nMassa: farinha de trigo\r\nBorda: Catupiry \r\nRecheios: calabresa, frango\r\nOutros: azeitona', 43.00);

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_cliente_pizzaria` (`pizzaria_id`);

--
-- Índices de tabela `ingrediente`
--
ALTER TABLE `ingrediente`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pizzaria_id` (`pizzaria_id`);

--
-- Índices de tabela `item_cardapio`
--
ALTER TABLE `item_cardapio`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pizzaria_id` (`pizzaria_id`);

--
-- Índices de tabela `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cliente_id` (`cliente_id`);

--
-- Índices de tabela `pedido_itens`
--
ALTER TABLE `pedido_itens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pedido_id` (`pedido_id`),
  ADD KEY `fk_pedido_item_personalizada` (`pizza_personalizada_id`);

--
-- Índices de tabela `pizzaria`
--
ALTER TABLE `pizzaria`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Índices de tabela `pizzas_personalizadas`
--
ALTER TABLE `pizzas_personalizadas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ux_pedido_item_pizza_personalizada` (`pedido_item_id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de tabela `ingrediente`
--
ALTER TABLE `ingrediente`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de tabela `item_cardapio`
--
ALTER TABLE `item_cardapio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de tabela `pedido_itens`
--
ALTER TABLE `pedido_itens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de tabela `pizzaria`
--
ALTER TABLE `pizzaria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `pizzas_personalizadas`
--
ALTER TABLE `pizzas_personalizadas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `fk_cliente_pizzaria` FOREIGN KEY (`pizzaria_id`) REFERENCES `pizzaria` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `ingrediente`
--
ALTER TABLE `ingrediente`
  ADD CONSTRAINT `ingrediente_ibfk_1` FOREIGN KEY (`pizzaria_id`) REFERENCES `pizzaria` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `item_cardapio`
--
ALTER TABLE `item_cardapio`
  ADD CONSTRAINT `item_cardapio_ibfk_1` FOREIGN KEY (`pizzaria_id`) REFERENCES `pizzaria` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `pedido_itens`
--
ALTER TABLE `pedido_itens`
  ADD CONSTRAINT `fk_pedido_item_personalizada` FOREIGN KEY (`pizza_personalizada_id`) REFERENCES `pizzas_personalizadas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `pedido_itens_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `pizzas_personalizadas`
--
ALTER TABLE `pizzas_personalizadas`
  ADD CONSTRAINT `pizzas_personalizadas_ibfk_1` FOREIGN KEY (`pedido_item_id`) REFERENCES `pedido_itens` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
