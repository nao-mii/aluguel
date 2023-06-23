drop database if exists AC2;
create database AC2;
use AC2;


drop table if EXISTS Viagens;
drop table if EXISTS Distancia;
drop table if EXISTS Condutor;
drop table if EXISTS Veiculos;
drop table if EXISTS Cidades;


create TABLE Condutor(
  	CNH			varchar(15)			PRIMARY KEY,
  	nome			varchar(45),
  	salario			decimal(10,2)
);

create table Telefone(
	idCondutor		varchar(15)			primary key,
    	telefone		varchar(45),
    
    	FOREIGN KEY (idCondutor) REFERENCES Condutor(CNH)
);

create TABLE Veiculos(
  	placa			varchar(10) 			PRIMARY KEY,
  	marca			varchar(45),
  	cor			varchar(45),
  	tipo			varchar(45)
);

create TABLE Cidades(
  	idCidades		int 				primary key AUTO_INCREMENT,
  	nome			varchar(45),
  	estado			varchar(45)
);

create TABLE Distancia(
  	cod_rota		int				PRIMARY KEY AUTO_INCREMENT,
  	cidade1			int,
  	cidade2 		int,
	KM			varchar(6),
  
  	FOREIGN key (cidade1) REFERENCES Cidades(idCidades),
  	FOREIGN key (cidade2) REFERENCES Cidades(idCidades)
);

CREATE TABLE Viagens(
  	id_viagem			int 			PRIMARY KEY auto_increment,
  	data_saida			date,
	veiculo				varchar(10),
  	condutor			varchar(15),
  	cidade_origem_id		int,
  	cidade_destino_id		int,
  	cod_rota			int,
  
  	FOREIGN KEY (veiculo) REFERENCES Veiculos(placa),
  	FOREIGN KEY (condutor) REFERENCES Condutor(CNH),
  	FOREIGN KEY (cidade_origem_id) REFERENCES Cidades(idCidades),
  	FOREIGN KEY (cidade_destino_id) REFERENCES Cidades(idCidades),
  	FOREIGN KEY (cod_rota) REFERENCES Distancia(cod_rota)
);

INSERT INTO Condutor VALUES ('144378773267', 'Julio', 2703.90);
INSERT INTO Condutor VALUES ('133787778071', 'Luciana', 2073.00);
INSERT INTO Condutor VALUES ('180237673267', 'Amanda', 1003.10);
INSERT INTO Condutor VALUES ('100371262167', 'Marcio', 1706.05);
INSERT INTO Condutor VALUES ('189000342119', 'Fabio', 3308.50);

INSERT INTO Telefone VALUES ('144378773267', '(15) 99808-6654');
INSERT INTO Telefone VALUES ('133787778071', '(15) 99654-2541');
INSERT INTO Telefone VALUES ('180237673267', '(11) 97682-7821');
INSERT INTO Telefone VALUES ('100371262167', '(11) 96544-5469');
INSERT INTO Telefone VALUES ('189000342119', '(19) 94524-4000');

INSERT INTO Veiculos VALUES ('KIG-7871', 'Gol', 'Vermelho', 'Carro');
INSERT INTO Veiculos VALUES ('NEJ-0835', 'BMW', 'Branco', 'Moto');
INSERT INTO Veiculos VALUES ('GZS-8331', 'Mercedes-Benz', 'Cinza', 'Caminhão');
INSERT INTO Veiculos VALUES ('LVZ-2847', 'Audi', 'Verde', 'Carro');
INSERT INTO Veiculos VALUES ('KAE-1785', 'Harley Davidson', 'Preto', 'Moto');

INSERT INTO Cidades VALUES (null, 'Sorocaba', 'Sao Paulo');
INSERT INTO Cidades VALUES (null, 'Salto de Pirapora', 'Sao Paulo');
INSERT INTO Cidades VALUES (null, 'Sao Paulo', 'Sao Paulo');
INSERT INTO Cidades VALUES (null, 'Campinas', 'Sao Paulo');
INSERT INTO Cidades VALUES (null, 'Guarulhos', 'Sao Paulo');

INSERT INTO Distancia VALUES (null, 1, 2, '27 KM');
INSERT INTO Distancia VALUES (null, 1, 3, '103 KM');
INSERT INTO Distancia VALUES (null, 1, 4, '88 KM');
INSERT INTO Distancia VALUES (null, 1, 5, '116 KM');

INSERT INTO Distancia VALUES (null, 2, 3, '467 KM');
INSERT INTO Distancia VALUES (null, 2, 4, '109 KM');
INSERT INTO Distancia VALUES (null, 2, 5, '137 KM');

INSERT INTO Distancia VALUES (null, 3, 4, '93 KM');
INSERT INTO Distancia VALUES (null, 3, 5, '21 KM');

INSERT INTO Distancia VALUES (null, 4, 5, '111 KM');

INSERT INTO Viagens VALUES (null, '2023-01-22', 'NEJ-0835', '180237673267', 1, 4, 3);
INSERT INTO Viagens VALUES (null, '2023-02-04', 'GZS-8331', '100371262167', 3, 1, 2);
INSERT INTO Viagens VALUES (null, '2022-11-28', 'LVZ-2847', '133787778071', 5, 3, 9);
INSERT INTO Viagens VALUES (null, '2023-03-17', 'KIG-7871', '144378773267', 1, 4, 3);
INSERT INTO Viagens VALUES (null, '2023-05-01', 'KAE-1785', '133787778071', 2, 1, 1);
INSERT INTO Viagens VALUES (null, '2023-04-30', 'NEJ-0835', '100371262167', 4, 5, 10);
INSERT INTO Viagens VALUES (null, '2023-01-30', 'KIG-7871', '180237673267', 3, 2, 5);
INSERT INTO Viagens VALUES (null, '2022-12-10', 'GZS-8331', '144378773267', 2, 5, 7);
INSERT INTO Viagens VALUES (null, '2023-04-15', 'KAE-1785', '189000342119', 3, 5, 9);
INSERT INTO Viagens VALUES (null, '2023-02-28', 'GZS-8331', '133787778071', 4, 5, 10);


-- Select que contabiliza a quantidade de viagens que um veículo já realizou
select count(*) as quantidade_viagens from Viagens where veiculo = 'NEJ-0835';

-- Procedure para setar o cadastramento de uma viagem que só ocorrerá no dia seguinte
DELIMITER //
create PROCEDURE RegistrarViagem(
	in pCidadeOrigem 	varchar(45),
    	in pCidadeDestino	varchar(45),
    	in pCondutor		varchar(15),
    	in pVeiculo			varchar(10)
)

begin
	declare dataSaida date;
    
    	set dataSaida = CURDATE() + INTERVAL 1 DAY;
    
    	INSERT INTO Viagens (data_saida, veiculo, condutor, cidade_origem_id, cidade_destino_id, cod_rota)
    	SELECT
	dataSaida,
        pVeiculo,
        pCondutor,
        C1.idCidades,
        C2.idCidades,
        D.cod_rota
	FROM
	Cidades C1
        JOIN Cidades C2 ON C1.nome = pCidadeOrigem AND C2.nome = pCidadeDestino
        JOIN Distancia D ON C1.idCidades = D.cidade1 and C2.idCidades = D.cidade2;

SELECT 'Viagem registrada com sucesso.' as mensagem;

end //

call RegistrarViagem('Sorocaba', 'Campinas', '100371262167', 'NEJ-0835');

-- Select que mostra o extrato de todas as viagens realizadas, utilizando um JOIN para interligar as tabelas e mostrar dados úteis para o usuário
select id_viagem, veiculo, c.nome as nome_condutor, cO.nome as nome_cidade_origem, CD.nome as nome_cidade_destino, D.KM as distancia_km, data_saida
	from Viagens V
	join Condutor C on V.condutor = C.CNH
	join Cidades CO on V.cidade_origem_id = CO.idCidades
	join Cidades CD on V.cidade_destino_id = CD.idCidades
	join Distancia D on V.cod_rota = D.cod_rota
ORDER BY id_viagem;

-- Select que permite ver todas as combinações de origem - destino, mostrando a distância entre as cidades
select c1.nome as cidade_origem, c2.nome as cidade_destino, d.KM
from Distancia d
    join Cidades c1 on d.cidade1 = c1.idCidades
    join Cidades c2 on d.cidade2 = c2.idCidades;

--Select que puxa o cadastro de algum condutor em que a CNH não foi preenchida
select * from Condutor where CNH is null or CNH = 0;
    

    






    
    







