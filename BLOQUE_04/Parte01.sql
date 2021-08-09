--04.01

--(1) Inserción de 1 fila sin especificar columnas

insert into dbo.PlanInternet 
output inserted.codplan,inserted.nombre --OPCIONAL
values ('GOLD IV',110.00,'Solicitado por comité agosto 2021')

--() Inserción vía SSMS

select * from dbo.PlanInternet  where codplan=7

--(2) Inserción múltiple
/*
insert into Telefono(tipo,numero,codcliente,estado)values('LLA','915703551',1,1) --OK
go
insert into Telefono(tipo,numero,codcliente,estado)values('SMS','900670335',1,0) --NO
go
insert into Telefono(tipo,numero,codcliente,estado)values('SMS','946909800',1,0) --OK
go
*/
insert into Telefono(tipo,numero,codcliente,estado)
values
('LLA','111111111',1,1), --OK
('LLA','222222222',1,'A'), --NO
('LLA','333333333',1,0)  --OK

SELECT * FROM Telefono
where tipo='WSP' and numero='900670339'

insert into dbo.PlanInternet 
output inserted.codplan,inserted.nombre --OPCIONAL
values 
('PREMIUM II',140.00,'Solicitado por comité agosto 2021'),
('PREMIUM III',160.00,'Solicitado por comité agosto 2021'),
('PREMIUM IV',180.00,'Solicitado por comité agosto 2021')

--(3) Inserción con cambios en orden de columnas
insert into dbo.PlanInternet(precioref,descripcion,nombre) 
output inserted.codplan,inserted.nombre --OPCIONAL
values 
(190.00,'Solicitado por comité agosto 2021','STAR I')

--Eliminar codplan=12

delete from PlanInternet
where codplan=12

--Reseteo de IDENTITY

DBCC CHECKIDENT ('dbo.PlanInternet', RESEED, 10);  

--Insert después RESEED

insert into dbo.PlanInternet(precioref,descripcion,nombre) 
output inserted.codplan,inserted.nombre --OPCIONAL
values 
(190.00,'Solicitado por comité agosto 2021','STAR I')

--(4) Inserción sobre columnas con valor predeterminado		

alter table dbo.PlanInternet add fechoraregistro datetime default getdate()

insert into dbo.PlanInternet(precioref,descripcion,nombre) 
output inserted.codplan,inserted.nombre --OPCIONAL
values 
(200.00,'Solicitado por comité agosto 2021','STAR II')

alter table dbo.PlanInternet add estado bit default 0

insert into dbo.PlanInternet(precioref,descripcion,nombre,fechoraregistro) 
output inserted.codplan,inserted.nombre --OPCIONAL
values 
(210.00,'Solicitado por comité agosto 2021','STAR III','2021-07-27 12:20:00.000')

select * from dbo.PlanInternet

--04.02

--(a)
--(5) Inserción desde una consulta
--Tabla_Destino: Zona - Columnas: nombre,estado
--Tabla_Origen : Zona_Carga
insert into Zona (nombre,estado,codubigeo)
output inserted.codzona,inserted.nombre
select nombre,1 as estado,u.codubigeo
/*NO PRACTICO:case when departamento='LIMA' and provincia='HUAURA' and distrito='CHECRAS' then 1*/
from Zona_Carga zc
inner join Ubigeo u 
on upper(trim(zc.departamento))=upper(trim(u.nom_dpto)) and 
   upper(trim(zc.provincia))=upper(trim(u.nom_prov))    and
   upper(trim(zc.distrito))=upper(trim(u.nom_dto)) 
where estado='ACTIVO'

--(b) Destino:Zona | Origen: procedimiento almacenado

--Creación de procedure
create procedure dbo.usp_selzonasinac as
select nombre,0 as estado,u.codubigeo
from   Zona_Carga zc
inner  join Ubigeo u 
on upper(trim(zc.departamento))=upper(trim(u.nom_dpto)) and 
   upper(trim(zc.provincia))=upper(trim(u.nom_prov))    and
   upper(trim(zc.distrito))=upper(trim(u.nom_dto)) 
where estado='INACTIVO'

alter procedure dbo.usp_selzonasact as
select nombre,1 as estado,u.codubigeo
from   Zona_Carga zc
inner  join Ubigeo u 
on upper(trim(zc.departamento))=upper(trim(u.nom_dpto)) and 
   upper(trim(zc.provincia))=upper(trim(u.nom_prov))    and
   upper(trim(zc.distrito))=upper(trim(u.nom_dto)) 
where estado='ACTIVO'

--Ejecución de procedimiento
execute dbo.usp_selzonasinac

--Inserción con procedimiento almacenado
insert into Zona (nombre,estado,codubigeo)
execute dbo.usp_selzonasinac

alter procedure dbo.usp_rutina_01 as
begin
	--01: 
	execute dbo.usp_selzonasinac
	--02: 
	execute dbo.usp_selzonasact
end

execute usp_rutina_01

--04.03

ALTER TABLE [dbo].[Zona] NOCHECK CONSTRAINT [RefUbigeo2]

select * from Ubigeo where codubigeo=18

select * from Zona where codubigeo=18

SET IDENTITY_INSERT Zona ON  --Habilitar registro sobre codzona

insert into Zona(codzona,nombre,estado,codubigeo)
output inserted.codzona,inserted.nombre
values 
(12,'CAJATAMBO-A',1,18),
(13,'CAJATAMBO-B',1,18),
(14,'CAJATAMBO-C',1,18)

SET IDENTITY_INSERT Zona OFF --Comportamiento defecto

select * from Zona where codubigeo=18

--04.05

--(984 rows affected)

begin tran
	delete from Contrato
	output deleted.codcliente,deleted.codplan
	where codcliente=1
rollback

select * from Contrato where codcliente=1

begin tran
	 delete from Telefono
	 output deleted.numero,deleted.codcliente
	 where codcliente=18 and tipo<>'LLA'
rollback --commit

select * from Telefono
where codcliente=18 and tipo<>'LLA'

--04.07

select co.* from Contrato co
inner join Cliente c on co.codcliente=c.codcliente
inner join Zona z on c.codzona=z.codzona
inner join Ubigeo u on z.codubigeo=u.codubigeo
where c.tipo_cliente='P' and c.estado=0 and u.cod_dpto='15' and u.cod_prov='08' and u.cod_dto='01'

select co.* from Contrato co
inner join Cliente c on co.codcliente=c.codcliente and c.tipo_cliente='P' and c.estado=0
inner join Zona z on c.codzona=z.codzona
inner join Ubigeo u on z.codubigeo=u.codubigeo and u.cod_dpto='15' and u.cod_prov='08' and u.cod_dto='01'

begin tran
	delete con
	output deleted.codcliente,deleted.codplan
	from  Contrato con
	inner join Cliente c on con.codcliente=c.codcliente and c.tipo_cliente='P' and c.estado=0
	inner join Zona z on c.codzona=z.codzona
	inner join Ubigeo u on z.codubigeo=u.codubigeo and u.cod_dpto='15' and u.cod_prov='08' and u.cod_dto='01'
rollback

--04.09

begin tran
	update Cliente
	set    nombres='MARIA'
	output deleted.nombres,  --Antiguo valor
	       inserted.nombres  --Nuevo valor
	where  codcliente=1
rollback

select nombres 
from   Cliente 
where  codcliente=1

--Cliente 500

select * 
from   Cliente 
where  codcliente=500

begin tran
	update Cliente
	set    numdoc='46173385', nombres='DOMITILA CAMILA', ape_paterno='LOPEZ',ape_materno='MORALES',
	       fec_nacimiento='1980-01-09',sexo='F',email='DOMITILA_LOPEZ@GMAIL.COM',direccion='URB. LOS CIPRESES M-24'
		   --codzona=2,estado=0
		   --edad=DATEDIFF(day,fec_nacimiento,getdate())/360
	output deleted.numdoc,inserted.numdoc,             --Antiguo|nuevo valor
		   deleted.nombres,inserted.nombres,           --Antiguo|nuevo valor
		   deleted.ape_paterno,inserted.ape_paterno    --Antiguo|nuevo valor
	where  codcliente=500
rollback

select fec_nacimiento,DATEDIFF(day,fec_nacimiento,getdate())/360 as edad
from   Cliente 
where  tipo_cliente='P'

SET IDENTITY_INSERT Zona OFF 

begin tran
	update Zona
	set codzona=4
	where codzona=3
rollback

begin tran
	update Contrato
	set codplan=5,codcliente=275,fec_contrato='2019-01-01'
	where codplan=5 and codcliente=275 and fec_contrato='2019-11-25'
rollback

select * from Contrato
where codplan=2 and codcliente=124

select * from Contrato
where codplan=5 and codcliente=275

--04.11

select * from PlanInternet

--El nuevo precio calculado debe ser almacenado en la tabla contrato
alter table Contrato add nuevopreciosol decimal(9,2)

--Manera con varios updates
begin tran
	update co
	set   nuevopreciosol=0.95*p.precioref --5% dcto sobre precio referencial
	from  Contrato co
	join  PlanInternet p on co.codplan=p.codplan
	where co.codplan in (1,2,3,4,5,8) and co.periodo='Q'
rollback

begin tran
	update co
	set   nuevopreciosol=0.90*p.precioref --10% dcto sobre precio referencial
	from  Contrato co
	join  PlanInternet p on co.codplan=p.codplan
	where co.codplan in (1,2,3,4,5,8) and co.periodo='M'
rollback

begin tran
	update co
	set   nuevopreciosol=0.98*p.precioref --2% dcto sobre precio referencial
	from  Contrato co
	join  PlanInternet p on co.codplan=p.codplan
	where NOT((co.codplan in (1,2,3,4,5,8) and co.periodo='M') or 
	         (co.codplan in (1,2,3,4,5,8) and co.periodo='Q'))
rollback

--Usando 1 UPDATE

begin tran
	update co
	set   nuevopreciosol= case 
						  when co.codplan in (1,2,3,4,5,8) and co.periodo='Q' then 0.95*p.precioref --5% dcto sobre precio referencial
						  when co.codplan in (1,2,3,4,5,8) and co.periodo='M' then 0.90*p.precioref --10% dcto sobre precio referencial
						  else 0.98*p.precioref                                                     --2% dcto sobre precio referencial
						  end
	output deleted.nuevopreciosol,inserted.nuevopreciosol
	from  Contrato co
	join  PlanInternet p on co.codplan=p.codplan
rollback

--Quiénes son los clientes a los cuales NO les conviene este nuevo precio
select codcliente,codplan,preciosol,nuevopreciosol from Contrato
where nuevopreciosol>preciosol

--Quiénes son los clientes a los cuales SI les conviene este nuevo precio
select codcliente,codplan,preciosol,nuevopreciosol from Contrato
where nuevopreciosol<preciosol

--Quiénes son los clientes a los cuales le es indistinto el nuevo precio
select codcliente,codplan,preciosol,nuevopreciosol from Contrato
where nuevopreciosol=preciosol

--¿Quiénes son los clientes detectados con un diferencial de S/50.00 a más entre el nuevo precio y el precio actual?
select codcliente,codplan,preciosol,nuevopreciosol,abs(nuevopreciosol-preciosol) as diferencial
from Contrato
where abs(nuevopreciosol-preciosol)>=50