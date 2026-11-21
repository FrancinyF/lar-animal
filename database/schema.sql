-- ============================================================================
-- Lar Animal - schema.sql
-- Banco de Dados do MVP de Adoção e Cuidado Animal (PIE II)
-- ============================================================================

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS lar_animal;
CREATE DATABASE lar_animal
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE lar_animal;

-- ----------------------------------------------------------------------------
-- 1. Tabela de Espécies (ex: Cão, Gato, Coelho)
-- ----------------------------------------------------------------------------
CREATE TABLE especie (
  id_especie INT AUTO_INCREMENT PRIMARY KEY,
  nome       VARCHAR(60) NOT NULL UNIQUE
);

-- ----------------------------------------------------------------------------
-- 2. Tabela de Animais Resgatados
-- ----------------------------------------------------------------------------
CREATE TABLE animal (
  id_animal       INT AUTO_INCREMENT PRIMARY KEY,
  id_especie      INT NOT NULL,
  nome            VARCHAR(100) NOT NULL,
  raca            VARCHAR(80) NOT NULL DEFAULT 'SRD',
  sexo            CHAR(1) NOT NULL CHECK (sexo IN ('M', 'F')),
  porte           VARCHAR(10) NOT NULL CHECK (porte IN ('Pequeno', 'Medio', 'Grande')),
  idade_estimada  INT NOT NULL DEFAULT 0 CHECK (idade_estimada >= 0),
  castrado        BOOLEAN NOT NULL DEFAULT FALSE,
  status_adocao   VARCHAR(15) NOT NULL DEFAULT 'Disponivel'
                  CHECK (status_adocao IN ('Disponivel', 'Em processo', 'Adotado')),
  observacao      VARCHAR(255),
  data_resgate    DATE NOT NULL,
  FOREIGN KEY (id_especie) REFERENCES especie (id_especie)
);

-- ----------------------------------------------------------------------------
-- 3. Tabela de Vacinas / Procedimentos Preventivos
-- ----------------------------------------------------------------------------
CREATE TABLE vacina (
  id_vacina  INT AUTO_INCREMENT PRIMARY KEY,
  nome       VARCHAR(100) NOT NULL UNIQUE,
  descricao  VARCHAR(255)
);

-- ----------------------------------------------------------------------------
-- 4. Tabela Associativa N:N - Carteira de Vacinação do Animal
-- (Se o animal for removido, seu histórico de vacinas deixa de existir)
-- ----------------------------------------------------------------------------
CREATE TABLE animal_vacina (
  id_animal      INT NOT NULL,
  id_vacina      INT NOT NULL,
  data_aplicacao DATE NOT NULL,
  dose           VARCHAR(40) NOT NULL DEFAULT 'Dose unica',
  PRIMARY KEY (id_animal, id_vacina, data_aplicacao),
  FOREIGN KEY (id_animal) REFERENCES animal (id_animal) ON DELETE CASCADE,
  FOREIGN KEY (id_vacina) REFERENCES vacina (id_vacina)
);

-- ----------------------------------------------------------------------------
-- 5. Tabela de Adotantes (LGPD: apenas dados essenciais para contato e triagem)
-- ----------------------------------------------------------------------------
CREATE TABLE adotante (
  id_adotante   INT AUTO_INCREMENT PRIMARY KEY,
  nome          VARCHAR(150) NOT NULL,
  email         VARCHAR(100) NOT NULL UNIQUE,
  telefone      VARCHAR(20) NOT NULL,
  cidade        VARCHAR(100) NOT NULL,
  tipo_moradia  VARCHAR(20) NOT NULL DEFAULT 'Casa'
                CHECK (tipo_moradia IN ('Casa', 'Apartamento', 'Sitio')),
  data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 6. Tabela de Adoções
-- (Liga o adotante ao animal adotado; impede excluir adotante com adoções)
-- ----------------------------------------------------------------------------
CREATE TABLE adocao (
  id_adocao     INT AUTO_INCREMENT PRIMARY KEY,
  id_adotante   INT NOT NULL,
  id_animal     INT NOT NULL UNIQUE,
  data_adocao   DATE NOT NULL,
  status        VARCHAR(15) NOT NULL DEFAULT 'Concluida'
                CHECK (status IN ('Em analise', 'Concluida', 'Cancelada')),
  observacao    VARCHAR(255),
  FOREIGN KEY (id_adotante) REFERENCES adotante (id_adotante),
  FOREIGN KEY (id_animal) REFERENCES animal (id_animal)
);
