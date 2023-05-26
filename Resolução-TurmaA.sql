create database formativaHogwarts;

use formativaHogwarts;

create table nivelAcesso(
	id bigint not null auto_increment,
    nivel varchar(100) not null,
    descricao varchar(200),
    primary key(id)
);

insert into nivelAcesso (nivel,descricao) values 
('Admin','blablá'),('Gestor','blablá'),
('Usuário','blablá'),('Visitante','blablá');

select *from nivelAcesso;



create table ocupacao(
	id bigint not null auto_increment,
    titulo varchar(150) not null,
    nivelAcessoFk bigint not null,
    primary key(id),
    foreign key(nivelAcessoFk) references nivelAcesso(id)
);

insert into ocupacao (titulo,nivelAcessoFk) values 
('Professor',3),('Secretaria',3),
('Coordenador',2),('Orientador',2),
('Aluno',4),('TI',1);

select *from ocupacao;

create table usuarios(
	id bigint not null auto_increment,
    nome varchar(150) not null,
    email varchar(150) not null,
	dataNascimento date not null,
    senha varchar(30) not null,
    dataCadastro datetime not null default now(),
    ocupacaoFk bigint not null,
    status boolean not null default true,    
    primary key(id),
    foreign key(ocupacaoFk) references ocupacao(id)
);

insert into usuarios (nome,email,senha,dataNascimento,ocupacaoFk) values 
('João','joao@gmail.com','55s888ff','2000-01-01',1),
('Mara','mara@gmail.com','554333','1986-01-03',2),
('Clarice','clarice@gmail.com','54455s888ff','1999-03-01',3),
('Roberto','roberto@gmail.com','6666444','2001-01-21',4),
('Miguel','miguel@gmail.com','3354','1995-03-03',1),
('Lúcia','lucia@gmail.com','abbbcdd','1970-05-25',2);

select *from usuarios;


create table locais(
	id bigint not null auto_increment,
    nome varchar(150) not null,
    bloco enum('A','B','C','D') not null,
    lotacao int not null,
    primary key(id)
);

insert into locais (nome,bloco,lotacao) values 
('Laboratório Eletrônica 01','A',16),
('Auditório','C',100),
('Laboratório Eletrônica 02','B',16),
('Laboratório Mecânica 01','A',30),
('Laboratório Informática 01','D',32);

select *from locais;

create table item(
	id bigint not null auto_increment,
    nome varchar(150) not null,    
    primary key(id)
);

insert into item (nome) values 
('Projetor'),
('Ar condicionado'),
('Lousa digital'),
('Home Theater'),
('Ipad'),
('Ferro de Solda');


create table checkList(
	id bigint not null auto_increment,
    localFk bigint not null,
    itemFk bigint not null,
    qtd int not null default 1,
    primary key(id),
    foreign key(localFk) references locais(id),
    foreign key(itemFk) references item(id)
);
alter table checkList add column qtd int not null default 1;

insert into checkList (localFk,itemFk) values 
(1,1),(1,2),(1,5),
(2,1),(2,5),
(3,3),(3,2),
(4,1),(4,2),(4,3),(4,5);

select *from checkList;

create table eventos(
	id bigint not null auto_increment,
    nome varchar(200) not null,
    localFk bigint not null,
    inicio datetime not null,
    fim datetime not null,
    inicioCheckIn datetime not null,
    fimCheckIn datetime not null,
    vagas int not null,    
    primary key(id),
    foreign key(localFk) references locais(id)
);

select *from locais;

insert into eventos (nome,localFk,inicio,fim,inicioCheckIn,fimCheckIn,vagas) values 
('Workshop Cloud Básico', 5,'2023-07-07 18:45:00','2023-07-07 23:10:00', '2023-06-07 18:45:00','2023-07-07 18:45:00',32),
('Desenho Técnico SolidWorks', 5,'2023-08-01 18:45:00','2023-08-02 23:10:00', '2023-06-08 18:45:00','2023-08-01 18:45:00',32),
('Ensaios Mecânicos Avançados', 4,'2023-12-01 18:45:00','2023-12-02 23:10:00', '2023-12-08 18:45:00','2023-12-01 18:45:00',30),
('Conquistando o primeiro milhão', 2,'2023-12-12 18:45:00','2023-12-12 23:10:00', '2023-12-12 18:45:00','2023-12-12 18:45:00',100);


insert into eventos (nome,localFk,inicio,fim,inicioCheckIn,fimCheckIn,vagas) values 
('Como fazer ovo de pascoa', 1,'2023-01-01 18:45:00','2023-01-01 23:10:00', '2023-01-01 18:45:00','2023-01-01 18:45:00',16);



create table checkIn(
	id bigint not null auto_increment,    
    eventoFk bigint not null,
    usuarioFk bigint not null,
    data datetime not null default now(),
    primary key(id),
    foreign key(eventoFk) references eventos(id),
    foreign key(usuarioFk) references usuarios(id)
);

insert into checkIn (eventoFk,usuarioFk) values 
(1,1), (1,2), (1,5), 
(2,2), (2,4), (2,5),(2,6), 
(3,1), (3,6),
(4,3), (4,4), (4,5);

select *from checkIn;


insert into checkIn (eventoFk,usuarioFk) values 
(1,5), (1,6);


-- Crie uma consulta que mostre todos os locais que já tiveram ao menos um evento;

select distinct l.nome, l.bloco from locais l 
inner join eventos e on e.localFk = l.id;

select l.nome, l.bloco from locais l where l.id in (
select e.localFk from eventos e);

-- Crie uma consulta que mostre todos os locais que não tiveram associação a nenhum evento
select l.nome, l.bloco from locais l where l.id not in (
select e.localFk from eventos e);


-- Crie uma consulta que mostre todos eventos filtrando por uma data inicial e data final (esse tipo de consulta será usada quando o usuário buscar os eventos por data);

select *from eventos where inicio >= '2023-11-11 00:00:00';

select *from eventos where inicio between '2023-11-11 00:00:00' and '2023-12-11 00:00:00';


-- Crie uma consulta que mostre todos os usuários que já participaram de ao menos um evento;

select distinct u.nome, u.email from usuarios u
where u.id in (select c.usuarioFk from checkIn c);

select distinct u.nome, u.email from usuarios u
join checkIn c on c.usuarioFk = u.id;

-- Crie uma consulta que mostre todos os eventos ainda não iniciados com a relação de seus usuários que já fizeram check-in;
select e.nome as nomeEvento, e.inicio as inicioEvento, u.nome as participante from eventos e 
join checkIn c on c.eventoFk = e.id
join usuarios u on c.usuarioFk = u.id
where inicio > now();

-- Crie uma consulta que mostre todos os usuários e a quantidade de vezes que o mesmo já se registrou em algum evento;
select c.usuarioFk, u.nome, u.email, count(*) as totalEventos from checkIn c
join usuarios u on u.id = c.usuarioFk
group by c.usuarioFk;

-- Crie uma consulta que mostre o evento com maior número de check-in e o com o menor
select c.eventoFk, e.nome, count(*) as totalCheckIn from checkIn c
join eventos e on e.id = c.eventoFk
group by c.eventoFk
having totalCheckIn in (
	(select max(totalCheckIn) from (
	select c.eventoFk, e.nome, count(*) as totalCheckIn from checkIn c
	join eventos e on e.id = c.eventoFk
	group by c.eventoFk ) tabelaMax),
	(select min(totalCheckIn) from (
	select c.eventoFk, e.nome, count(*) as totalCheckIn from checkIn c
	join eventos e on e.id = c.eventoFk
	group by c.eventoFk ) tabelaMin)
);


-- Crie uma consulta que mostre a média de participantes por local

select local, avg(totalParticipacoes) from (
	select l.id local, c.eventoFk evento, count(*) totalParticipacoes from checkIn c
	join eventos e on e.id = c.eventoFk
	join locais l on l.id = e.localFk
	group by c.eventoFk, l.id
) subtabela group by local;


-- Crie uma consulta que mostre todos os usuários e seu perfil de nível de acesso;
select u.nome, u.email, n.nivel, n.descricao from usuarios u
join ocupacao o on o.id = u.ocupacaoFk
join nivelAcesso n on n.id = o.nivelAcessoFk;


-- Crie uma consulta que mostre todos os eventos que tenham vagas disponíveis e cujo período de liberação de check-in está aberto;
select *from eventos
where vagas > 0 and inicioCheckIn < now() 
and fimCheckIn > now();

-- Crie uma consulta que mostre todos os eventos que já alcançaram o seu número máximo de participantes (esgotaram) mas que ainda não aconteceram
select *from eventos where vagas = 0 and inicio > now();



-- Crie uma consulta que mostre todos os usuários que foram cadastrados em um determinado período mas que contenham ao mínimo dois check-ins;

select c.usuarioFk, u.nome, u.email, u.dataCadastro, count(*) as totalCheckin from checkIn c 
join usuarios u on u.id = c.usuarioFk
group by c.usuarioFk having totalCheckin > 2 and 
date(u.dataCadastro) between '2023-03-22'
and '2023-04-23';






























































