--03.01

--a
--Código de clientes

select codcliente from Cliente  --1000

--Código de planes

select codplan from PlanInternet --5

select codcliente,codplan,codubigeo
from   Cliente cross join PlanInternet
cross join Ubigeo

--b

--Código de clientes empresa

select codcliente 
from   Cliente  
where  tipo_cliente='E'--400

--Código de planes

select codplan from PlanInternet --5

select codcliente,codplan
from   Cliente cross join PlanInternet 
where  tipo_cliente='E'

--03.02

select * from Ubigeo 

select 'Z'+cast(codzona as varchar(10)) as CODZONA,nombre as ZONA,estado as ESTADO,Ubigeo.cod_dpto+Ubigeo.cod_prov+Ubigeo.cod_dto
from Zona inner join Ubigeo 
on Zona.codubigeo=Ubigeo.codubigeo

--Alias de tabla
select 'Z'+cast(codzona as varchar(10)) as CODZONA,nombre as ZONA,estado as ESTADO,
u.cod_dpto+u.cod_prov+u.cod_dto as UBIGEO,
--u.ubigeo as UBIGEO,
'La Zona '+nombre+'  del ubigeo '+u.cod_dpto+u.cod_prov+u.cod_dto+' se encuentra '+IIF(estado=1,'activa','inactiva') as mensaje
from Zona z inner join Ubigeo u
on z.codubigeo=u.codubigeo