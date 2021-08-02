--04.01

--(1) Inserci�n de 1 fila sin especificar columnas

insert into dbo.PlanInternet 
output inserted.codplan,inserted.nombre --OPCIONAL
values ('GOLD IV',110.00,'Solicitado por comit� agosto 2021')

--() Inserci�n v�a SSMS

select * from dbo.PlanInternet  where codplan=7

--(2) Inserci�n m�ltiple
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
('PREMIUM II',140.00,'Solicitado por comit� agosto 2021'),
('PREMIUM III',160.00,'Solicitado por comit� agosto 2021'),
('PREMIUM IV',180.00,'Solicitado por comit� agosto 2021')

--(3) Inserci�n con cambios en orden de columnas
insert into dbo.PlanInternet(precioref,descripcion,nombre) 
output inserted.codplan,inserted.nombre --OPCIONAL
values 
(190.00,'Solicitado por comit� agosto 2021','STAR I')

--Eliminar codplan=12

delete from PlanInternet
where codplan=12

--Reseteo de IDENTITY

DBCC CHECKIDENT ('dbo.PlanInternet', RESEED, 10);  

--Insert despu�s RESEED

insert into dbo.PlanInternet(precioref,descripcion,nombre) 
output inserted.codplan,inserted.nombre --OPCIONAL
values 
(190.00,'Solicitado por comit� agosto 2021','STAR I')

--(4) Inserci�n sobre columnas con valor predeterminado		

alter table dbo.PlanInternet add fechoraregistro datetime default getdate()

insert into dbo.PlanInternet(precioref,descripcion,nombre) 
output inserted.codplan,inserted.nombre --OPCIONAL
values 
(200.00,'Solicitado por comit� agosto 2021','STAR II')

alter table dbo.PlanInternet add estado bit default 0

insert into dbo.PlanInternet(precioref,descripcion,nombre,fechoraregistro) 
output inserted.codplan,inserted.nombre --OPCIONAL
values 
(210.00,'Solicitado por comit� agosto 2021','STAR III','2021-07-27 12:20:00.000')

select * from dbo.PlanInternet