--07.01
/*Función escalar*/
--Variables 
declare @n1 int=5,@n2 int=7
select 'F(N1,N2)'= power(@n1,2)+10*@n1*@n2+power(@n2,2)
--Función escalar
create or alter function dbo.uf_Polinomio(@n1 int,@n2 int) returns integer
as
begin
	return power(@n1,2)+10*@n1*@n2+power(@n2,2)
end

select dbo.uf_Polinomio(5,7) as 'F(N1,N2)'

--Función escalar
create or alter function dbo.uf_nombreCliente(
@tipo_cliente char(1),
@nombres varchar(100),
@ape_paterno varchar(70),
@ape_materno varchar(70), 
@razon_social varchar(300)) 
returns varchar(300)
as
begin
	--declare @edad int = (select dbo.uf_edad())
	declare @nombreCliente varchar(300) = (select case when @tipo_cliente='E' then @razon_social 
												       when @tipo_cliente='P' then trim(@nombres)+' '+trim(@ape_paterno)+' '+trim(@ape_materno)
										  end)
	return @nombreCliente+' '--+cast(@edad as varchar(100))
end

select dbo.uf_nombreCliente('P','MARIA','MORALES','MANRIQUE','DEVMASTER')

select tipo_cliente,nombres,ape_paterno,ape_materno,razon_social,
dbo.uf_nombreCliente(tipo_cliente,nombres,ape_paterno,ape_materno,razon_social) as nombreCliente
from Cliente

create or alter function dbo.uf_edad() returns integer
as
begin
	return 31
end

select dbo.uf_edad()

--Función escalar sobre columnas

select codplan,codcliente,dbo.uf_Polinomio(codplan,codcliente) as 'F(N1,N2)'
from Contrato

/*Procedimiento almacenado*/

create or alter procedure dbo.usp_Polinomio(@n1 int,@n2 int) as
begin
	select 'POLINOMIO'= power(@n1,2)+10*@n1*@n2+power(@n2,2)
end

create or alter procedure dbo.usp_Polinomio2 as
begin
	select codplan,codcliente,'POLINOMIO'= power(codplan,2)+10*codplan*codcliente+power(codcliente,2)
	from Contrato
end

execute dbo.usp_Polinomio2

--07.03
--Hola, no olvide realizar el pago de su servicio de Internet
--Hola, muchas gracias por su preferencia. Tenemos excelentes promociones para usted.

declare @mensaje varchar(100)='Hola, muchas gracias por su preferencia. Tenemos excelentes promociones para usted'
select tipo,numero,@mensaje as MENSAJE
from Telefono

create or alter procedure dbo.USP_REPORTE_TEL(@tipo varchar(4),@mensajito varchar(100)) as
begin
	select tipo,numero,@mensajito as MENSAJE
	from Telefono
	where tipo=@tipo and estado=1--tipo='LLA'
end

create or alter procedure dbo.USP_REPORTE_TEL_2(@tipo varchar(4)) as
begin
	select tipo,numero,case when tipo='LLA' then 'Hola, no olvide realizar el pago de su servicio de Internet' end as MENSAJE
	from Telefono
	where tipo=@tipo --tipo='LLA'
end

EXECUTE USP_REPORTE_TEL @tipo= 'LLA', @mensajito= 'Hola, no olvide realizar el pago de su servicio de Internet hasta el 30/09'
EXECUTE USP_REPORTE_TEL @tipo= 'SMS', @mensajito= 'Hola, muchas gracias por su preferencia. Tenemos excelentes promociones para usted'
EXECUTE USP_REPORTE_TEL @tipo= 'WSP', @mensajito= 'Hola, hasta el 15/07 recibe un 20% de descuento en tu facturación'

--07.05
--Configuración
create table dbo.Configuracion
(
codigo int identity(1,1) primary key,
parametro varchar(1000) not null,
valor varchar(1000) not null
)
--Variables
declare @codcliente int=600
select getdate() as 'Consulta al:',
	   dbo.uf_nombreCliente(tipo_cliente,nombres,ape_paterno,ape_materno,razon_social) as 'Cliente:',
	   direccion as 'Direccion:',
	   z.nombre as 'Zona:',
	   c.codcliente
from Cliente c 
join Zona z on c.codzona=z.codzona
where c.codcliente=@codcliente

--Procedimiento almacenado
create or alter procedure dbo.usp_ticketCliente(@codcliente int) as
begin
	if exists (select codcliente from Cliente where codcliente=@codcliente) 
	begin
	 --Existe cliente
		select getdate() as 'Consulta al:',
			   dbo.uf_nombreCliente(tipo_cliente,nombres,ape_paterno,ape_materno,razon_social) as 'Cliente:',
			   direccion as 'Direccion:',
			   z.nombre as 'Zona:',
			   c.codcliente,
			   --'DEV MASTER PERÚ SAC' as 'Razón social:',
			   --'20602275320' as 'Ruc:'
			   (select valor from Configuracion where parametro='RAZON_SOCIAL_DEVWIFI') as 'Razón social:',
			   (select valor from Configuracion where parametro='RUC_DEVWIFI') as 'RUC:'
		from Cliente c 
		join Zona z on c.codzona=z.codzona
		where c.codcliente=@codcliente
	end
	else -- No existe cliente  
	begin
		select 'El cliente no ha sido encontrado en la Base de Datos' as mensaje
	end

	select 'El cliente no ha sido encontrado en la Base de Datos 2' as mensaje
end

exec dbo.usp_ticketCliente @codcliente=100

--07.06

--Variables
--Procedimiento almacenado
create or alter procedure dbo.usp_InsUbigeo(@cod_dpto char(2),@nom_dpto varchar(100),@cod_prov char(2),
@nom_prov varchar(100),@cod_dto char(2),@nom_dto varchar(150)) as
begin 
	select codubigeo from Ubigeo where cod_dpto=@cod_dpto and cod_prov=@cod_prov and cod_dto=@cod_dto

	if exists (select codubigeo from Ubigeo where cod_dpto=@cod_dpto and cod_prov=@cod_prov and cod_dto=@cod_dto)
	begin
		select 0,'Ubigeo existente'
	end
	else
	begin 
		insert into Ubigeo(cod_dpto,nom_dpto,cod_prov,nom_prov,cod_dto,nom_dto)
		output inserted.codubigeo,'Ubigeo insertado'
		values (@cod_dpto,@nom_dpto,@cod_prov,@nom_prov,@cod_dto,@nom_dto)
	end
end

execute dbo.usp_InsUbigeo @cod_dpto='20',@nom_dpto='PIURA',@cod_prov='04',
@nom_prov='MORROPON',@cod_dto='08',@nom_dto='SANTA CATALINA DE MOSSA'

execute dbo.usp_InsUbigeo @cod_dpto='10',@nom_dpto='HUANUCO',@cod_prov='01',
@nom_prov='HUANUCO',@cod_dto='07',@nom_dto='SAN FRANCISCO..'

/*Bucles en TSQL
declare @n int =10
WHILE @n>0  
BEGIN  
   PRINT 'valor'+cast(@n as varchar);  
   set @n=@n-1
END  
*/

--07.10
--Variables
declare @tipo varchar(4)='SMS',@numero varchar(20)='999999999'
begin tran
	delete from Telefono
	where tipo=@tipo and numero=@numero
rollback

--Procedimiento almacenado
create or alter procedure dbo.usp_DelTelefono(@tipo varchar(4),@numero varchar(20))
as
begin
	print 'Inicio numero'
	select numero from Telefono where tipo=@tipo and numero=@numero
	print 'Fin numero'
	if exists (select numero from Telefono where tipo=@tipo and numero=@numero)
		delete from Telefono
		output deleted.tipo as TIPO,deleted.numero as NUMERO,'Teléfono eliminado' as MENSAJE
		where tipo=@tipo and numero=@numero
	else 
		select 'TTT' as TIPO, '999999999' as NUMERO, 'No es posible identificar al teléfono a eliminar' as MENSAJE
end

execute dbo.usp_DelTelefono @tipo='LLA',@numero='915703551'

select top 10 * from Telefono
where tipo='LLA' and numero='915703551'

execute dbo.usp_DelTelefono @tipo='WSP',@numero='915419909'

--07.08
create or alter procedure dbo.usp_UpdCliente(
@codtipo int,
@numdoc varchar(15),
@razon_social varchar(300),
@fec_inicio date,
@email varchar(254),
@direccion varchar(300),
@codzona int,
@estado bit,
@codcliente int)
as
begin 
	select codcliente from Cliente where codcliente=@codcliente and tipo_cliente='E'

	if exists (select codcliente from Cliente where codcliente=@codcliente and tipo_cliente='E')
	begin
		update c
		set c.codtipo=@codtipo,c.numdoc=@numdoc,c.razon_social=@razon_social,c.fec_inicio=@fec_inicio,
			c.email=@email,c.direccion=@direccion,c.codzona=@codzona,c.estado=@estado
		output inserted.codcliente as CODCLIENTE,'Cliente empresa actualizado' as MENSAJE
		from Cliente c
		where c.tipo_cliente='E' and c.codcliente=@codcliente
	end
	else
	begin
		select @codcliente as CODCLIENTE,'No es posible identificar al cliente empresa a actualizar' as MENSAJE
	end
end

execute usp_UpdCliente @codtipo =1,@numdoc ='123456',@razon_social='DEV MASTER',@fec_inicio='2017-08-01',
                       @email='test@devmaster.pe',@direccion='URB. LOS CIPRESES M24, SANTA MARÍA',
                       @codzona=5, @estado=1, @codcliente=100

execute usp_UpdCliente @codtipo =1,@numdoc ='123456',@razon_social='DEV MASTER',@fec_inicio='2017-08-01',
                       @email='test@devmaster.pe',@direccion='URB. LOS CIPRESES M24, SANTA MARÍA',
                       @codzona=5, @estado=1, @codcliente=999999999