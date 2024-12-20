DROP TABLE IF EXISTS reembolsos;
DROP TABLE IF EXISTS vendas;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS produtos;

-- Tabela produtos
create table produtos (
    cod_prod        int primary key,
    nome_prod       VARCHAR(50) not null,
    categoria       ENUM('azeitonas', 'tremoços', 'azeitonas e tremoços') not null,
    tipo_prod       ENUM('sem recheio', 'com recheio', 'processado', 'natural') not null,
    preco           decimal(6,2) not null,
    quantidade      int not null CHECK (quantidade >= 0)

);

-- Tabela clientes
create table clientes (
    cod_cliente     int primary key auto_increment,
    nome            VARCHAR(50) not null,
    morada          VARCHAR(100) not null,
    localidade      VARCHAR(50) not null,
    email           VARCHAR(100) not null,
    nif             char(9),
    contacto        char(9) not null, 
    
    unique (email),
    unique (nif)
);

-- Tabela Vendas
create table vendas (
    cod_venda       VARCHAR(5) primary key,
    cod_cliente     int not null,
    cod_prod        int not null,
    qtd_venda       int not null CHECK (qtd_venda > 0),
    preco_venda     decimal(6,2) not null,
    data            date not null,
    status_pedido   ENUM('a preparar', 'em espera', 'enviado', 'cancelado') not null,

    foreign key (cod_cliente) 
    references clientes (cod_cliente)
        on update cascade 
        on delete restrict,
        
    foreign key (cod_prod) 
    references produtos (cod_prod)
        on update cascade 
        on delete restrict
);

-- Tabela reembolsos
create table reembolsos (
    cod_reembolso   VARCHAR(5) primary key,
    cod_cliente     int not null,
    cod_venda       VARCHAR(5) not null,
    cod_prod        int not null,
    valor_reemb     decimal(6,2) not null,
    data_reem       date not null,

    foreign key (cod_cliente) 
    references clientes (cod_cliente)
        on update cascade 
        on delete restrict,
    
    foreign key (cod_venda) 
    references vendas (cod_venda)
        on update cascade 
        on delete restrict,
        
    foreign key (cod_prod) 
    references produtos (cod_prod)
        on update cascade 
        on delete restrict
);

INSERT INTO produtos (cod_prod, nome_prod, categoria, tipo_prod, preco, quantidade) VALUES
(1234, 'Azeitonas descaroçadas (345g)', 'azeitonas', 'sem recheio', 1.75, 2000),
(1235, 'Azeitonas com orégãos e alho (150g)', 'azeitonas', 'sem recheio', 2.25, 2000),
(1236, 'Azeitonas com salsa e alho (150g)', 'azeitonas', 'sem recheio', 2.25, 1000),
(1237, 'Azeitonas com Piri-Piri (345g)', 'azeitonas', 'sem recheio', 2.45, 2500),
(1238, 'Azeitonas com sabor a limão (345g)', 'azeitonas', 'sem recheio', 2.45, 1000),
(1239, 'Azeitonas recheadas com pasta de pimento (345g)', 'azeitonas', 'com recheio', 2.45, 3000),
(1240, 'Azeitonas recheadas com queijo (150g)', 'azeitonas', 'com recheio', 2.99, 1500),
(1241, 'Azeitonas fritas recheadas com queijo (345g)', 'azeitonas', 'com recheio', 2.99, 2000),
(1242, 'Hambúrguer de azeitona (200g)', 'azeitonas', 'processado', 2.99, 1500),
(1243, 'Tremoços simples (300g)', 'tremoços', 'natural', 1.55, 750),
(1244, 'Tremoços temperados (150g)', 'tremoços', 'natural', 2.45, 1000),
(1245, 'Tremoços doces (150g)', 'tremoços', 'natural', 2.45, 1000),
(1246, 'Tremoços crocantes (200g)', 'tremoços', 'natural', 2.85, 1500),
(1247, 'Tremoços crocantes sabor a churrasco (200g)', 'tremoços', 'natural', 2.99, 2000),
(1248, 'Tremoços crocantes picantes (200g)', 'tremoços', 'natural', 2.99, 2000),
(1249, 'Tremoços crocantes com pimenta-de-Sichuan (200g)', 'tremoços', 'natural', 2.99, 2500),
(1250, 'Tremoços com algas e sementes de sésamo (200g)', 'tremoços', 'natural', 3.45, 1500),
(1251, 'Tremoços torrados com mel (200g)', 'tremoços', 'natural', 3.45, 1500),
(1252, 'Húmus de tremoço (200g)', 'tremoços', 'processado', 2.45, 2500),
(1253, 'Farinha de tremoço (330g)', 'tremoços', 'processado', 2.75, 1500),
(1254, 'Hambúrguer de tremoço (200g)', 'tremoços', 'processado', 2.99, 1000),
(1255, 'Hambúrguer de azeitona e tremoço (200g)', 'azeitonas e tremoços', 'processado', 2.99, 1000),
(1256, 'Pasta de azeitona e tremoço (200g)', 'azeitonas e tremoços', 'processado', 2.99, 1500);


INSERT INTO clientes (cod_cliente, morada, localidade, nome, email, contacto, nif) VALUES
(1, 'R. Xavier Pacheco, 585, 0971-326, Cadaval, Braga', 'Cadaval', 'Gustavo Pinheiro', 'gustavo.pinheiro@hotmail.com', '910065092', '995811296'),
(2, 'Alameda do Parque, 75, 1960-813, Lourinhã, Braga', 'Lourinhã', 'Juliana-Nicole Vicente', 'juliana-nicole.vicente@clix.pt', '963534559', '181384981'),
(3, 'Avenida Borges, 904, 4753-819, Cinfães, Évora', 'Cinfães', 'Inês Cunha', 'ines.cunha@sapo.pt', '962028680', '970590008'),
(4, 'Travessa de Neptuno, 652, 6165-023, Moita, Lisboa', 'Moita', 'André do Vaz', 'andre.vaz@clix.pt', '939951745', '257457828'),
(5, 'Rua Rui Amaral, 51, 8281-575, Porto Moniz, Lisboa', 'Porto Moniz', 'Sandro Valente', 'sandro.valente@gmail.com', '242173337', '960859896'),
(6, 'Rua de D. João II, 75, 4165-793, Vieira do Minho, Bragança', 'Vieira do Minho', 'Caetana-Melissa Jesus', 'caetana-melissa.jesus@clix.pt', '926400695', '628884605'),
(7, 'Avenida Leite, S/N, 6660-383, Matosinhos, Beja', 'Matosinhos', 'Laura Neto', 'laura.neto@clix.pt', '961715883', '997868732'),
(8, 'R. de Moura, 184, 4346-452, Ílhavo, Bragança', 'Ílhavo', 'Carlos Monteiro', 'carlos.monteiro@sapo.pt', '928519046', '545892023'),
(9, 'Avenida de Torres, S/N, 3086-206, Sertã, Leiria', 'Sertã', 'Vera Brito-Pacheco', 'vera.brito-pacheco@hotmail.com', '922121089', '561374627'),
(10, 'R. do Bolhão, 50, 7626-455, São João da Pesqueira, Leiria', 'São João da Pesqueira', 'Sofia Neves', 'sofia.neves@clix.pt', '229780324', '197310354'),
(11, 'Alameda Monteiro, 897, 0686-759, Benavente, Viseu', 'Benavente', 'Ângela Freitas', 'angela.freitas@clix.pt', '968341474', '935439498'),
(12, 'R. Baptista, 79, 6977-803, Ferreira do Zêzere, Porto', 'Ferreira do Zêzere', 'Francisco Azevedo', 'francisco.azevedo@gmail.com', '929426192', '810518619'),
(13, 'Avenida das Mimosas, 55, 6216-497, Monchique, Viana do Castelo', 'Monchique', 'Tomás Pereira', 'tomas.pereira@gmail.com', '293158515', '886811368'),
(14, 'Alameda Futebol Clube do Porto, 68, 7996-294, Fundão, Braga', 'Fundão', 'Tatiana da Figueiredo', 'tatiana.figueiredo@sapo.pt', '292399493', NULL),
(15, 'Avenida de Faria, S/N, 0209-834, Alcochete, Coimbra', 'Alcochete', 'Flor Cruz', 'flor.cruz@sapo.pt', '921495801', NULL),
(16, 'Praça Baptista, 6, 5911-064, Ponte da Barca, Guarda', 'Ponte da Barca', 'Yara Henriques', 'yara.henriques@sapo.pt', '935361216', NULL),
(17, 'R. das Naus, 904, 2818-898, Bragança, Aveiro', 'Bragança', 'Artur Almeida', 'artur.almeida@gmail.com', '935868481', NULL),
(18, 'Rua de Pereira, 2, 2625-298, Marco de Canaveses, Braga', 'Marco de Canaveses', 'Rodrigo Ferreira', 'rodrigo.ferreira@gmail.com', '910421608', NULL),
(19, 'Av de Assunção, 933, 7623-353, Vila Real, Portalegre', 'Vila Real', 'Joaquim Miranda', 'joaquim.miranda@hotmail.com', '963254162', NULL),
(20, 'Largo de Jesus, S/N, 9951-290, Vila Franca do Campo, Leiria', 'Vila Franca do Campo', 'Tomás Freitas', 'tomas.freitas@gmail.com', '932958628', NULL),
(21, 'Praça das Necessidades, 27, 6801-519, Gavião, Viseu', 'Gavião', 'Benjamim Maia-Moura', 'benjamim.maia-moura@gmail.com', '937156110', NULL),
(22, 'Praça Vaz, 56, 3223-599, Vila Nova de Foz Côa, Setúbal', 'Vila Nova de Foz Côa', 'Marco do Castro', 'marco.castro@gmail.com', '920404398', NULL),
(23, 'Largo de Nunes, 95, 6330-013, Carregal do Sal, Beja', 'Carregal do Sal', 'Mário Loureiro', 'mario.loureiro@sapo.pt', '932863830', NULL),
(24, 'Avenida de Domingues, 951, 9527-965, Vila Nova da Barquinha, Lisboa', 'Vila Nova da Barquinha', 'Pedro Vieira', 'pedro.vieira@gmail.com', '962641219', NULL),
(25, 'Travessa de Baptista, 83, 2872-251, Corvo, Castelo Branco', 'Corvo', 'Isabel-Flor Assunção', 'isabel-flor.assuncao@sapo.pt', '923748442', NULL),
(26, 'Av João Domingues, 599, 4843-273, Maia, Leiria', 'Maia', 'Marco Guerreiro-Branco', 'marco.guerreiro-branco@sapo.pt', '926730989', NULL),
(27, 'Alameda Benedita Carneiro, S/N, 8333-371, Sintra, Portalegre', 'Sintra', 'Filipa Barros', 'filipa.barros@hotmail.com', '923620991', NULL),
(28, 'Praça Afonso de Albuquerque, 56, 4534-097, Torres Vedras, Bragança', 'Torres Vedras', 'Isaac Figueiredo', 'isaac.figueiredo@hotmail.com', '231999575', NULL),
(29, 'Av Matilde Magalhães, 18, 0345-649, Porto, Aveiro', 'Porto', 'Enzo Oliveira', 'enzo.oliveira@gmail.com', '963669552', NULL),
(30, 'Travessa de Borges, 979, 9707-402, São Brás de Alportel, Aveiro', 'São Brás de Alportel', 'Kelly Machado', 'kelly.machado@gmail.com', '916120168', NULL);

INSERT INTO vendas (cod_venda, cod_cliente, cod_prod, qtd_venda, preco_venda, data, status_pedido) VALUES 
('V0001', 22, 1243, 10, 15.5, '2024-09-22', 'a preparar'),
('V0002', 20, 1253, 2, 5.5, '2024-07-16', 'enviado'),
('V0003', 7, 1248, 8, 23.92, '2024-07-29', 'enviado'),
('V0004', 14, 1249, 6, 17.94, '2024-04-15', 'enviado'),
('V0005', 1, 1255, 4, 11.96, '2024-07-24', 'cancelado'),
('V0006', 8, 1248, 10, 29.9, '2023-05-30', 'enviado'),
('V0007', 4, 1242, 1, 2.99, '2023-12-21', 'enviado'),
('V0008', 7, 1241, 10, 29.9, '2024-02-26', 'enviado'),
('V0009', 16, 1246, 9, 25.65, '2023-04-18', 'a preparar'),
('V0010', 6, 1238, 6, 14.7, '2023-02-27', 'enviado'),
('V0011', 7, 1248, 6, 17.94, '2023-08-30', 'enviado'),
('V0012', 25, 1248, 1, 2.99, '2023-01-02', 'enviado'),
('V0013', 20, 1250, 10, 34.5, '2024-10-08', 'a preparar'),
('V0014', 8, 1249, 3, 8.97, '2024-04-22', 'a preparar'),
('V0015', 13, 1255, 5, 14.95, '2023-06-19', 'a preparar'),
('V0016', 27, 1245, 2, 4.9, '2023-01-23', 'enviado'),
('V0017', 9, 1254, 5, 14.95, '2024-08-06', 'enviado'),
('V0018', 26, 1253, 7, 19.25, '2023-12-03', 'enviado'),
('V0019', 16, 1235, 7, 15.75, '2023-04-09', 'a preparar'),
('V0020', 5, 1250, 5, 17.25, '2023-11-09', 'enviado'),
('V0021', 22, 1250, 8, 27.6, '2024-08-16', 'enviado'),
('V0022', 9, 1251, 5, 17.25, '2023-07-27', 'a preparar'),
('V0023', 28, 1243, 3, 4.65, '2024-06-05', 'enviado'),
('V0024', 28, 1251, 8, 27.6, '2024-02-27', 'a preparar'),
('V0025', 13, 1236, 7, 15.75, '2024-03-05', 'enviado'),
('V0026', 21, 1242, 6, 17.94, '2023-11-15', 'enviado'),
('V0027', 15, 1247, 5, 14.95, '2023-01-28', 'enviado'),
('V0028', 23, 1237, 8, 19.6, '2023-04-29', 'enviado'),
('V0029', 22, 1249, 1, 2.99, '2023-01-20', 'enviado'),
('V0030', 28, 1237, 1, 2.45, '2023-11-15', 'a preparar'),
('V0031', 20, 1253, 5, 13.75, '2024-06-13', 'enviado'),
('V0032', 1, 1238, 3, 7.35, '2023-05-28', 'a preparar'),
('V0033', 27, 1245, 6, 14.7, '2024-03-27', 'a preparar'),
('V0034', 24, 1250, 9, 31.05, '2023-05-03', 'cancelado'),
('V0035', 27, 1252, 2, 4.9, '2024-04-16', 'enviado'),
('V0036', 15, 1250, 6, 20.7, '2023-11-25', 'enviado'),
('V0037', 25, 1242, 1, 2.99, '2023-11-03', 'cancelado'),
('V0038', 26, 1234, 8, 14.0, '2023-09-10', 'enviado'),
('V0039', 18, 1250, 10, 34.5, '2023-05-25', 'enviado'),
('V0040', 9, 1234, 5, 8.75, '2024-08-16', 'enviado'),
('V0041', 7, 1240, 6, 17.94, '2023-09-04', 'cancelado'),
('V0042', 15, 1236, 8, 18.0, '2023-08-19', 'enviado'),
('V0043', 9, 1242, 7, 20.93, '2024-01-25', 'enviado'),
('V0044', 30, 1251, 1, 3.45, '2023-01-30', 'enviado'),
('V0045', 5, 1240, 7, 20.93, '2024-10-25', 'enviado'),
('V0046', 11, 1240, 3, 8.97, '2023-07-28', 'a preparar'),
('V0047', 9, 1246, 5, 14.25, '2024-11-23', 'a preparar'),
('V0048', 17, 1255, 7, 20.93, '2024-10-25', 'a preparar'),
('V0049', 2, 1248, 2, 5.98, '2024-06-23', 'a preparar'),
('V0050', 4, 1243, 5, 7.75, '2024-09-17', 'a preparar'),
('V0051', 1, 1235, 1, 2.25, '2023-01-03', 'enviado'),
('V0052', 26, 1247, 8, 23.92, '2024-04-25', 'a preparar'),
('V0053', 10, 1249, 1, 2.99, '2023-04-04', 'enviado'),
('V0054', 21, 1243, 3, 4.65, '2023-09-17', 'cancelado'),
('V0055', 9, 1255, 9, 26.91, '2024-04-10', 'a preparar'),
('V0056', 1, 1244, 8, 19.6, '2024-04-11', 'a preparar'),
('V0057', 8, 1243, 8, 12.4, '2024-06-13', 'a preparar'),
('V0058', 6, 1241, 1, 2.99, '2023-10-25', 'cancelado'),
('V0059', 20, 1238, 4, 9.8, '2023-07-13', 'cancelado'),
('V0060', 11, 1236, 5, 11.25, '2024-10-15', 'cancelado'),
('V0061', 29, 1235, 10, 22.5, '2023-03-11', 'enviado'),
('V0062', 6, 1253, 6, 16.5, '2023-11-22', 'enviado'),
('V0063', 29, 1244, 5, 12.25, '2024-07-13', 'enviado'),
('V0064', 7, 1255, 10, 29.9, '2024-05-13', 'a preparar'),
('V0065', 21, 1251, 6, 20.7, '2024-09-03', 'cancelado'),
('V0066', 1, 1240, 6, 17.94, '2023-02-10', 'enviado'),
('V0067', 30, 1246, 1, 2.85, '2023-09-27', 'cancelado'),
('V0068', 13, 1242, 1, 2.99, '2023-10-07', 'enviado'),
('V0069', 6, 1249, 6, 17.94, '2024-05-30', 'a preparar'),
('V0070', 28, 1235, 10, 22.5, '2024-06-15', 'enviado'),
('V0071', 14, 1242, 5, 14.95, '2023-12-30', 'a preparar'),
('V0072', 7, 1236, 1, 2.25, '2023-08-04', 'enviado'),
('V0073', 10, 1256, 6, 17.94, '2024-02-27', 'enviado'),
('V0074', 14, 1237, 6, 14.7, '2023-07-26', 'a preparar'),
('V0075', 14, 1234, 10, 17.5, '2023-01-26', 'cancelado');

INSERT INTO reembolsos (cod_reembolso, cod_cliente, cod_venda, cod_prod, valor_reemb, data_reem) VALUES
('R0038', 18, 'V0039', 1250, 34.5, '2023-06-23'),
('R0005', 8, 'V0006', 1248, 29.9, '2023-06-23'),
('R0026', 15, 'V0027', 1247, 14.95, '2023-02-26'),
('R0010', 7, 'V0011', 1248, 17.94, '2023-09-16'),
('R0028', 22, 'V0029', 1249, 2.99, '2023-02-02'),
('R0069', 28, 'V0070', 1235, 22.5, '2024-06-20'),
('R0009', 6, 'V0010', 1238, 14.7, '2023-03-15'),
('R0035', 15, 'V0036', 1250, 20.7, '2023-12-24'),
('R0022', 28, 'V0023', 1243, 4.65, '2024-07-03'),
('R0042', 9, 'V0043', 1242, 20.93, '2024-01-29'),
('R0011', 25, 'V0012', 1248, 2.99, '2023-02-01');
