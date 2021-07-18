declare @a int=10 --Declarar variable a del tipo entero con valor 10
declare @b int=3

--C�lculos matem�ticos
select 'suma'=@a+@b,'resta'=@a-@b,'multiplica'=@a*@b,'cociente'=@a/@b,'resto'=@a%@b

--Concatenaci�n
declare @sujeto varchar(50)='El estudiante',@predicado varchar(50)=' asisti� a clases'

select @sujeto+@predicado

--Progresi�n aritm�tica creciente
declare @t1 int=1,@n int=500,@r int=3 --RAND()+

select 'tn'=@t1+(@n-1)*@r

--02.01

declare @n1 int=15,@n2 int=7

select 'F(n1,n2)'=power(@n1,2)+10*@n1*@n2+power(@n2,2)

--Elementos SELECT

--�Cuales son los ubigeos que tienen como provincia 'HUAURA'?
--ESCRITURA: SELECT - FROM -WHERE | EVALUACI�N: FROM - WHERE -SELECT
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

--b. Los diferentes c�digos de ubigeo a nivel de zona

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