declare @a int=10 --Declarar variable a del tipo entero con valor 10
declare @b int=3

--Cálculos matemáticos
select 'suma'=@a+@b,'resta'=@a-@b,'multiplica'=@a*@b,'cociente'=@a/@b,'resto'=@a%@b

--Concatenación
declare @sujeto varchar(50)='El estudiante',@predicado varchar(50)=' asistió a clases'

select @sujeto+@predicado

--Progresión aritmética creciente
declare @t1 int=1,@n int=500,@r int=3 --RAND()+

select 'tn'=@t1+(@n-1)*@r

--02.01

declare @n1 int=15,@n2 int=7

select 'F(n1,n2)'=power(@n1,2)+10*@n1*@n2+power(@n2,2)

--Elementos SELECT

--¿Cuales son los ubigeos que tienen como provincia 'HUAURA'?
--ESCRITURA: SELECT - FROM -WHERE | EVALUACIÓN: FROM - WHERE -SELECT
select nom_dpto,nom_prov,nom_dto
from Ubigeo
where nom_dpto='LIMA' and nom_prov='HUAURA'

--02.03

--Los departamentos a nivel de ubigeo

select nom_dpto
from Ubigeo

--a. Los diferentes departamentos a nivel de ubigeo

select distinct nom_dpto
from Ubigeo

--b. Los diferentes códigos de ubigeo a nivel de zona

select distinct codubigeo
from Zona

select codubigeo
from Zona

--c. Las diferentes combinaciones de departamento+provincia a nivel de ubigeo
select nom_dpto,nom_prov
from Ubigeo

select distinct nom_dpto,nom_prov
from Ubigeo

select distinct nom_dpto,nom_prov,nom_dto
from Ubigeo

--Uso de alias columnas|tablas

select nom_dpto DPTO,nom_prov as PROV,'DTO'=nom_dto,nom_dpto+' '+nom_prov+ ' '+nom_dto [MI UBIGEO]
from Ubigeo ubi
--from Ubigeo as ubi
where nom_dpto='LIMA' and nom_prov='HUAURA'

--02.04

select nombre as ZONA,codubigeo as [CODIGO UBIGEO],estado as ESTADO,
case when estado=1 then 'Zona activa'
else 'Zon inactiva'
end as [MENSAJE ESTADO]
from Zona
where codubigeo=1

--02.06
--1 DOL = 3.961 SOL
select cast(round(17.666,2) as decimal(10,2))

select nombre as [PLAN],'S/.'+cast(precioref as varchar(100)) as PRECIO_SOL,
cast(round(precioref/3.961,2) as decimal(9,2)) as PRECIO_DOL,
case when precioref>=0 and precioref<70 then '[0,70>'
	 when precioref>=70 and precioref<100 then '[70,100>'
	 when precioref>=100 then '[100, +>'
else 'No es posible determinar'
end as RANGO_SOL
from PlanInternet

--Uso AND-OR

select nom_dpto,nom_prov,nom_dto
from Ubigeo
where nom_dpto='LIMA' and nom_prov='HUAURA'

select nom_dpto,nom_prov,nom_dto
from Ubigeo
where nom_dpto='LIMA' or nom_prov='HUAURA'

--02.08

--A

select codzona as CODZONA,nombre as ZONA,codubigeo as [CODIGO UBIGEO],estado as ESTADO,
case when estado=1 then 'Zona activa'
else 'Zon inactiva'
end as [MENSAJE ESTADO]
from Zona
--where estado=1 and codubigeo=1 or codzona>=4
--where estado=1 and codubigeo=1 and codzona>=4
where estado=1 and (codubigeo=1 and codzona>=4)
order by codzona desc

--B

select codzona as CODZONA,nombre as ZONA,codubigeo as [CODIGO UBIGEO],estado as ESTADO,
case when estado=1 then 'Zona activa'
else 'Zon inactiva'
end as [MENSAJE ESTADO]
from Zona
where estado=1 and codubigeo=1
order by nombre desc

--C

select codzona as CODZONA,nombre as ZONA,codubigeo as [CODIGO UBIGEO],estado as ESTADO,
case when estado=1 then 'Zona activa'
else 'Zon inactiva'
end as [MENSAJE ESTADO]
from Zona
where estado=0 or codubigeo=1
order by estado asc

--D
select codzona as CODZONA,nombre as ZONA,codubigeo as [CODIGO UBIGEO],estado as ESTADO,
case when estado=1 then 'Zona activa'
else 'Zon inactiva'
end as [MENSAJE ESTADO]
from Zona
where estado=1 or codubigeo=1
order by codubigeo desc,nombre asc

--E

select codzona as CODZONA,nombre as ZONA,codubigeo as [CODIGO UBIGEO],estado as ESTADO,
case when estado=1 then 'Zona activa'
else 'Zon inactiva'
end as [MENSAJE ESTADO]
from Zona
--where NOT(estado=1 and codubigeo=1) --Complemento
where NOT(estado=1) or NOT(codubigeo=1) --Complemento
order by codzona asc

--02.10

--A
select * from TipoDocumento

select 
case when codtipo=3 then 'RUC' else 'OTRO TIPO' end as TIPO_DOC,
tipo_cliente as TIPO_CLIENTE,
numdoc as NUM_DOC,
razon_social as RAZON_SOCIAL,
codzona as CODZONA,
fec_inicio as FEC_INICIO
from Cliente
--where tipo_cliente='E' and (codzona=1 or codzona=3 or codzona=5 or codzona=7)
where tipo_cliente='E' and codzona in (1,3,5,7)
order by razon_social desc

--B

select 
case when codtipo=3 then 'RUC' else 'OTRO TIPO' end as TIPO_DOC,
tipo_cliente as TIPO_CLIENTE,
numdoc as NUM_DOC,
razon_social as RAZON_SOCIAL,
codzona as CODZONA,
fec_inicio as FEC_INICIO
from Cliente
/*NO PRACTICO: where tipo_cliente='E' and fec_inicio in ('1998-01-01','1998-01-02','1998-01-03',...)*/
where tipo_cliente='E' and fec_inicio between '1998-01-01' and '1998-12-31'
order by fec_inicio desc --/*más reciente al más antiguo*/

select 
case when codtipo=3 then 'RUC' else 'OTRO TIPO' end as TIPO_DOC,
tipo_cliente as TIPO_CLIENTE,
numdoc as NUM_DOC,
razon_social as RAZON_SOCIAL,
codzona as CODZONA,
fec_inicio as FEC_INICIO,
month(fec_inicio) as MES
from Cliente
/*NO PRACTICO: where tipo_cliente='E' and fec_inicio in ('1998-01-01','1998-01-02','1998-01-03',...)*/
--where tipo_cliente='E' and fec_inicio between '1998-01-01' and '1998-12-31'
where tipo_cliente='E' and month(fec_inicio) between 1 and 5
order by fec_inicio desc --/*más reciente al más antiguo*/
