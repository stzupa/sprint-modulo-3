-- CREAR BASE DE DATOS ---------------------------------------------------------------------------
--
create schema sprint_modulo_3;
--
-- POSICIONAR BASE DE DATOS ----------------------------------------------------------------------
--
use sprint_modulo_3;
--
-- CREAR USUARIO ---------------------------------------------------------------------------------
--
create user 'sprint3'@'localhost' identified by '1234';
--
-- ASIGNANDO PRIVILEGIOS AL USUARIO --------------------------------------------------------------
--
grant create, drop, delete, insert, select, update on sprint_modulo_3.* to 'sprint3'@'localhost';
--
-- ELIMINAR TABLA CATEGORIA SI EXISTE ------------------------------------------------------------
--
drop table if exists categoria;
--
-- CREANDO TABLA CATEGORIA -----------------------------------------------------------------------
--
create table categoria(
	id_cat mediumint auto_increment,
    nombre_cat varchar(30) not null,
    primary key(id_cat)
);
--
-- ELIMINAR TABLA PROBEEDOR SI EXISTE ------------------------------------------------------------
--
drop table if exists proveedor;
--
-- CREAR TABLA PROVEEDOR -------------------------------------------------------------------------
--
create table proveedor(
	id_prov mediumint auto_increment,
    nombre_prov varchar(50) not null,
    nombre_rep_prov varchar(30) not null,
    apellido_rep_prov varchar(30) not null,
    tel1 varchar(15) not null,
    tel2 varchar(15) not null,
    telefonista varchar(50) not null,
    correo_electronico varchar(40),
    id_cat mediumint not null,
    primary key(id_prov)
);
--
-- ELIMINAR TABLA CLIENTE SI EXISTE ---------------------------------------------------------------
--
drop table if exists cliente;
--
-- CREANDO TABLA CLIENTE --------------------------------------------------------------------------
--
create table cliente(
	id_cli mediumint auto_increment,
    nombre_cli varchar(30) not null,
    apellido_cli varchar(30) not null,
    direccion_cli varchar(50) not null,
    primary key(id_cli)
);
--
-- ELIMINAR TABLA PRODUCTO SI EXISTE --------------------------------------------------------------
--
drop table if exists producto;
--
-- CREAR TABLA PRODUCTO ---------------------------------------------------------------------------
-- 
create table producto(
	id_prod mediumint auto_increment,
    nombre_prod varchar(50) not null,
    id_cat mediumint not null,
    id_prov mediumint not null,
    color varchar(20) not null,
    precio int not null,
    stock mediumint not null,
    primary key(id_prod)    
);
--
-- AGREGAR RESTRICCION A TABLA PRODUCTO
--
alter table producto
add constraint prod_prov_fk foreign key(id_prov)
	references proveedor(id_prov);
--
-- AGREGAR RESTRICCION A TABLA PROVEEDOR
--
alter table proveedor
add 
	constraint prov_cat_fk foreign key(id_cat)
	references categoria(id_cat);
--
-- POBLAR TABLA CATEGORIA ---------------------------------------------------------------------------------
--
insert into categoria(nombre_cat)
values('Computación'),('Electrónica'),('Oficina'),('Hogar');
--
-- POBLAR TABLA PROVEEDOR ---------------------------------------------------------------------------------
--
insert into proveedor(nombre_prov,nombre_rep_prov,apellido_rep_prov,tel1,tel2,telefonista,correo_electronico,id_cat)
values
('Provilec','Juan','Perez','+562554789','+56985698547','Maria Pia','contacto@provilec.cl',2),
('EcoHogar','Mariana','Pereira','+56912545698','+56255442325','Lorena Flores','ventas@ecohogar.cl',4),
('Compupro','Lucía','Méndez','+56974568521','+56325642589','Laura Salinas','vv@compupro.cl',1),
('ElPro','Manuel','López','+56954448888','+56955556666','Paola García','contacto@elpro.cl',3),
('LaMula','Mabel','Ruíz','+56922256669','+56944441254','Claudia Moya','ventas@lamula.cl',1);
--
-- POBLAR TABLA CLIENTE ------------------------------------------------------------------------------------
--
insert into cliente(nombre_cli,apellido_cli,direccion_cli)
values
('Daniel','Pereira','Los Lirios 456'),
('Maria','Pozzo','Prat 477'),
('Ximena','Guerrero','Jaraquemada 236'),
('Manuel','Cuadra','Matta 877'),
('Rubén','Vilchez','Amalia Paz 46');
--
-- POBLAR TABLA PRODUCTO ----------------------------------------------------------------------------------
--
insert into producto(nombre_prod,id_cat,id_prov,color,precio,stock)
values
('Lámpara',3,4,'Blanca',15000,5),
('Mouse Genius',1,3,'Negro',8500,119),
('Comedor 6 sillas',4,2,'Marrón',750000,5),
('Notebook Acer 15',1,5,'Azul',689000,25),
('Monitor FullHD',1,3,'Blanco',165000,23),
('Box Spring 2 plazas',4,2,'Gris',545650,12),
('Televisor 55',2,1,'Negro',358000,5),
('Disco duro externo 1 tb',1,5,'Negro',85000,63),
('Silla reclinable',3,4,'Azul y blanco',65000,34),
('Ram 8 GB',1,5,'Rojo',30000,89),
('Disco SSD 512 GB',1,5,'Verde',45000,68);
--
-- CATEGORIA DE PRODUCTO MAS REPETIDA ----------------------------------------------------------------
--
select c.nombre_cat as Producto, count(p.id_cat) as Cantidad from producto as p
inner join proveedor as pr on(p.id_prov = pr.id_prov)
inner join categoria as c on(pr.id_cat = c.id_cat)
group by c.nombre_cat order by Cantidad desc limit 1;
--
-- PRODUCTOS CON MAYOR STOCK -------------------------------------------------------------------------
--
select nombre_prod as Producto, stock as Stock from producto
group by stock order by stock desc limit 3;
--
-- COLOR DE PRODUCTO MAS COMUN ------------------------------------------------------------------------
--
select color, count(color) as cantidad from producto
group by color order by cantidad desc limit 1;
--
-- CUAL O CUALES SON LOS PROVEEDORES CON MENOR STOCK --------------------------------------------------
--
select pr.nombre_prov as Nombre, sum(pd.stock) as Stock from proveedor as pr
inner join producto as pd on(pr.id_prov = pd.id_prov)
group by pr.nombre_prov order by Stock limit 1;
--
-- PROCEDIMIENTO PARA CAMBIAR CATEGORIA MAS POPULAR ---------------------------------------------------
-- DEBE GUARDAR EL PROCEDIMIENTO PARAA FUNCIONAR ------------------------------------------------------
--
DELIMITER $$
USE `sprint_modulo_3`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `modifica_categoria`()
BEGIN
	set @n_cat = (select c.nombre_cat as Producto from producto as p
				inner join proveedor as pr on(p.id_prov = pr.id_prov)
				inner join categoria as c on(pr.id_cat = c.id_cat)
				group by c.nombre_cat limit 1);                        
	update categoria set nombre_cat = 'Electrónica y computación'
    where nombre_cat = @n_cat;
END$$

call modifica_categoria();

