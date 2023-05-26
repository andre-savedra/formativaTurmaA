create database formativa;
use formativa;

create table nivelAcesso(
	id bigint not null auto_increment,
    nivel varchar(100) not null,
    descricao varchar(150),
    primary key(id)
);

insert into nivelAcesso (nivel) values 
('ADMIN'),('GESTOR'),('USUARIO'),('VISITANTE');
select *from nivelAcesso;

create table ocupacao(
	id bigint not null auto_increment,
    titulo varchar(150) not null,
    nivelAcessoFK bigint not null,
    primary key(id),
    foreign key(nivelAcessoFK) references nivelAcesso(id)
);

insert into ocupacao (titulo, nivelAcessoFK) values 
('Professor', 3),('Secretária', 3),('Coordenador', 2),('Orientador', 2),
('Aluno', 4),('Analista de Sistemas', 1),('Diretor', 1);

select *from ocupacao;

create table usuario(
	id bigint not null auto_increment,
    nome varchar(150) not null,
    email varchar(100) not null,
    dataNascimento date not null,
    senha varchar(50) not null,
    dataCadastro datetime default now(),
    status boolean default true,
    ocupacaoFK bigint not null,
    primary key(id),
    foreign key(ocupacaoFK) references ocupacao(id)
);

insert into usuario (nome, email, dataNascimento, senha, ocupacaoFK) values 
('João', 'joao@gmail.com', '2000-01-01', 'dsdknoidn393943', 5),
('Maria', 'maria@gmail.com', '2002-05-11', 'dsdkner4553', 2),
('Clara', 'clara@gmail.com', '1999-01-01', 'wewer3434', 5),
('Roberto', 'roberto@gmail.com', '1998-12-01', '3434343ref', 1),
('Carlos', 'carlos@gmail.com', '1995-01-01', '343refefe', 6),
('Alex', 'alex@gmail.com', '2004-01-11', '448ffjfff', 2),
('José', 'jose@gmail.com', '1985-01-01', '4488fjjf', 5);


insert into usuario (nome, email, dataNascimento, senha, ocupacaoFK) values 
('Jéssica', 'jessica@gmail.com', '1997-01-01', 'ahhfhhff', 4);

select *from usuario;

create table item(
	id bigint not null auto_increment,
    nome varchar(100) not null,
    primary key(id)
);

insert into item (nome) values 
('Projetor'),('Tablet'),('Ar condicionado'),('Monitor'),('TV Smart'),('Som');

create table local(
	id bigint not null auto_increment,
    nome varchar(100) not null,
    lotacao int not null,
    bloco enum('A','B','C','D') not null,    
    primary key(id)
);

insert into local (nome, lotacao, bloco) values 
('Laboratório Eletrônica 01', 16, 'A'),
('Laboratório Informática 02', 30, 'C'),
('Laboratório Metalmecânica', 16, 'B'),
('Auditório', 100, 'A'),
('Laboratório Eletrônica 02', 16, 'A'),
('Laboratório Ensaios Mecânicos', 32, 'D');

create table checkList(
	id bigint not null auto_increment,
    localFK bigint not null,
    itemFK bigint not null,
    primary key(id),
    foreign key(localFK) references local(id),
    foreign key(itemFK) references item(id)
);


insert into checkList(localFK, itemFK) values
(1,2),(1,5),(1,6),(1,3),
(2,1),(2,2),
(3,3),(3,4),(3,5),
(4,1),(4,3),(4,5),(4,6);

create table evento(
	id bigint not null auto_increment,
    nome varchar(150) not null,
    inicio datetime not null,
    fim datetime not null,
    inicioCheckin datetime not null,
    fimCheckin datetime not null,
    vagas int not null,    
    localFK bigint not null,
    responsavelFK bigint not null,    
    primary key(id),
    foreign key(localFK) references local(id),
    foreign key(responsavelFK) references usuario(id)
);

select *from local;

insert into evento (nome, inicio,fim, inicioCheckin, fimCheckin, vagas, localFk, responsavelFk)
values
('Workshop Cloud Básico', '2023-05-26 18:45:00', '2023-05-26 23:45:00', '2023-05-26 18:45:00', '2023-05-26 23:45:00', 30, 2, 1), 
('Workshop Desenho SolidWorks', '2023-06-26 18:45:00', '2023-06-26 23:45:00', '2023-06-01 18:45:00', '2023-06-01 23:45:00', 16, 3, 2),
('Blockchain Básico', '2023-08-12 18:45:00', '2023-08-15 23:45:00', '2023-05-26 18:45:00', '2023-05-26 23:45:00', 0, 1, 1),
('Decolando sua carreira', '2023-12-12 18:45:00', '2023-12-12 23:45:00', '2023-08-26 18:45:00', '2023-08-26 23:45:00', 59, 4, 1),
('Desmistificando Spring Framework', '2024-01-26 18:45:00', '2024-01-30 23:45:00', '2024-01-01 18:45:00', '2024-01-01 23:45:00', 16, 1, 1),
('Criptomoedas e Web3', '2023-05-30 18:45:00', '2023-05-30 23:45:00', '2023-05-30 18:45:00', '2023-05-30 23:45:00', 10, 1, 2);

insert into evento (nome, inicio,fim, inicioCheckin, fimCheckin, vagas, localFk, responsavelFk)
values
('Workshop Cloud Avançado', '2023-05-26 18:45:00', '2023-05-26 23:45:00', '2023-05-26 18:45:00', '2023-05-26 23:45:00', 30, 4, 1);


create table checkIn(
	id bigint not null auto_increment,
    eventoFK bigint not null,
    usuarioFK bigint not null,
    dataCheckin datetime not null default now(),
    primary key(id),
    foreign key(eventoFK) references evento(id),
    foreign key(usuarioFK) references usuario(id)
);

insert into checkIn (eventoFK, usuarioFK, dataCheckin) values 
(1,2,now()),
(1,1,'2023-01-01 00:00:00'),
(1,5,now()),
(2,6,now()),
(2,4,now()),
(3,1,'2023-05-05 00:00:00'),
(3,2,now()),
(3,4,now()),
(3,6,'2023-08-08 00:00:00'),
(4,1,now()),
(4,4,now()),(4,6,now());


insert into checkIn (eventoFK, usuarioFK, dataCheckin) values 
(7,2,now());



-- Crie uma consulta que mostre todos os locais que já tiveram ao menos um eventos;
select distinct l.id, l.nome from local l 
inner join evento e on e.localFK = l.id;

select l.id, l.nome from local l where 
l.id in(select e.localFK from evento e);

-- consulta se a pergunta estivesse especificando uma quantidade
select e.localFK, l.nome, count(*) totalEventos from evento e 
join local l on l.id = e.localFK
group by e.localFK
having totalEventos >= 2;

-- Crie uma consulta que mostre todos os locais que não tiveram associação a nenhum evento;
select l.id, l.nome from local l where 
l.id not in(select e.localFK from evento e);


-- Crie uma consulta que mostre todos eventos filtrando por uma data inicial e data final (esse tipo de consulta será usada quando o usuário buscar os eventos por data);
select *from evento where inicio between '2023-05-01 00:00:00'
and '2023-05-31 00:00:00';


-- Crie uma consulta que mostre todos os usuários que já participaram de ao menos um evento;
select distinct u.id, u.nome from checkIn c 
inner join usuario u on u.id= c.usuarioFK;

select u.id, u.nome from usuario u where 
u.id in(select c.usuarioFK from checkIn c);

-- Crie uma consulta que mostre todos os eventos ainda não iniciados com a relação de seus usuários que já fizeram check-in;

select e.nome, e.inicio, e.fim, c.dataCheckin, u.nome, u.email 
from evento e
join checkIn c on e.id = c.eventoFK
join usuario u on c.usuarioFK = u.id
where e.inicio > now();


-- Crie uma consulta que mostre todos os usuários e a quantidade de vezes que o mesmo já se registrou em algum evento

select c.usuarioFK, u.nome, count(*) totalDeEventos from checkIn c 
join usuario u  on u.id = c.usuarioFK
group by c.usuarioFK;


-- Crie uma consulta que mostre o evento com maior número de check-in e o com o menor

select c.eventoFK, e.nome, count(*) qtdCheckIn from checkIn c
join evento e on e.id = c.eventoFK
group by c.eventoFK having qtdCheckIn in(
	(select max(qtdCheckIn) from (
	select c.eventoFK, e.nome, count(*) qtdCheckIn from checkIn c
	join evento e on e.id = c.eventoFK
	group by c.eventoFK) subConsultaMax)
	,
	(select min(qtdCheckIn) from (
	select c.eventoFK, e.nome, count(*) qtdCheckIn from checkIn c
	join evento e on e.id = c.eventoFK
	group by c.eventoFK) subConsultaMin)
);


select c.eventoFK, e.nome, count(*) qtdCheckIn from checkIn c
join evento e on e.id = c.eventoFK
group by c.eventoFK having qtdCheckIn in(
	(select qtdCheckIn from (
	select c.eventoFK, e.nome, count(*) qtdCheckIn from checkIn c
	join evento e on e.id = c.eventoFK
	group by c.eventoFK order by qtdCheckIn desc limit 1) subConsultaMax)
	,
	(select qtdCheckIn from (
    select c.eventoFK, e.nome, count(*) qtdCheckIn from checkIn c
	join evento e on e.id = c.eventoFK
	group by c.eventoFK order by qtdCheckIn asc limit 1) subConsultaMin)
);

-- Crie uma consulta que mostre a média de participantes por local

select local, nomeLocal, avg(qtdCheckIn) from (
	select l.id local, l.nome nomeLocal, c.eventoFK evento, count(*) qtdCheckIn from checkIn c 
	join evento e on e.id = c.eventoFK
	join local l on l.id = e.localFK
	group by c.eventoFK, l.id
) subtabela group by local;


-- Crie uma consulta que mostre todos os usuários e seu perfil de nível de acesso

select u.nome, u.email, n.nivel from usuario u
join ocupacao o on o.id = u.ocupacaoFK
join nivelAcesso n on n.id = o.nivelAcessoFK;

-- Crie uma consulta que mostre todos os eventos que tenham vagas disponíveis e cujo período de liberação de check-in está aberto
select *from evento where vagas > 0 and
inicioCheckin < now() and fimCheckin > now();

-- Crie uma consulta que mostre todos os eventos que já alcançaram o seu número máximo de participantes (esgotaram) mas que ainda não aconteceram
select *from evento where vagas = 0 and
inicioCheckin > now();


select c.usuarioFK, count(*) totalCheckIn, u.dataCadastro from checkIn c 
join usuario u on u.id = c.usuarioFK
group by c.usuarioFK
having totalCheckIn >= 2 and
date(u.dataCadastro) between '2023-05-20' and '2023-05-26';




































	
    


















































