Use DEVWIFI18ED
go

/*Antes de ejecutar deshabilitar el FK desde Zona a Ubigeo*/

ALTER TABLE [dbo].[Zona] NOCHECK CONSTRAINT [RefUbigeo2] --Cambiar x su constraint
GO
insert into Zona(nombre,estado,codubigeo) values ('CAJATAMBO-A',1,18)
go
insert into Zona(nombre,estado,codubigeo) values ('CAJATAMBO-B',1,18)
go
insert into Zona(nombre,estado,codubigeo) values ('CAJATAMBO-C',1,18)
go
insert into Zona(nombre,estado,codubigeo) values ('COPA ZA',1,19)
go
insert into Zona(nombre,estado,codubigeo) values ('COPA ZB',0,19)
go
insert into Zona(nombre,estado,codubigeo) values ('COPA ZC',1,19)
go
insert into Zona(nombre,estado,codubigeo) values ('GORGOR ZA',1,20)
go
insert into Zona(nombre,estado,codubigeo) values ('GORGOR ZB',1,20)
go
insert into Zona(nombre,estado,codubigeo) values ('GORGOR ZC',1,20)
go
insert into Zona(nombre,estado,codubigeo) values ('GORGOR ZD',1,20)
go
insert into Zona(nombre,estado,codubigeo) values ('GORGOR ZE',1,20)
go
ALTER TABLE [dbo].[Zona] CHECK CONSTRAINT [RefUbigeo2]
GO

select * from Zona