--06.09
--a
create view vw_Ubigeo_Conso as
select cod_dpto as CODIGO_DPTO,cod_prov as CODIGO_PROV,cod_dto as CODIGO_DTO from DEVWIFI18ED.dbo.Ubigeo
union all
select cod_dpto,cod_prov,cod_dto from DevWifi2019.comercial.Ubigeo

select * from vw_Ubigeo_Conso
order by CODIGO_DPTO,CODIGO_PROV,CODIGO_DTO

--b
create function uf_Ubigeo_Conso() returns table as
return
	select cod_dpto as CODIGO_DPTO,cod_prov as CODIGO_PROV,cod_dto as CODIGO_DTO from DEVWIFI18ED.dbo.Ubigeo
	union 
	select cod_dpto,cod_prov,cod_dto from DevWifi2019.comercial.Ubigeo

select * from uf_Ubigeo_Conso()
order by CODIGO_DPTO,CODIGO_PROV,CODIGO_DTO

--06.11

--a
--2. Definir CTE para join
with cte_tel_i as
(
	--1. Obtener combinaciones comunes.
	select tipo,numero,codcliente,estado from DEVWIFI18ED.dbo.Telefono
	intersect
	select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
)
--3. Join para info adicional
select ti.tipo,ti.numero,ti.codcliente,ti.estado,
coalesce(c.razon_social,c.nombres+' '+c.ape_paterno+' '+c.ape_materno,'SIN INFO') as CLIENTE,
--4. Obtener posición irrepetible x cliente
row_number() over(partition by ti.codcliente order by ti.numero asc) as POSICION
from cte_tel_i ti
left join Cliente c on ti.codcliente=c.codcliente

--b

--2. Definir CTE para join
with cte_tel_i as
(
	--1.1 Obtener lo que está en dbo y no en comercial.
	/*
	select tipo,numero,codcliente,estado from DEVWIFI18ED.dbo.Telefono
	except
	select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
	*/
	--1.2 Obtener lo que está en comercial y no en dbo.
	select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
	except
	select tipo,numero,codcliente,estado from DEVWIFI18ED.dbo.Telefono 
)
--3. Join para info adicional
select ti.tipo,ti.numero,ti.codcliente,ti.estado,
coalesce(c.razon_social,c.nombres+' '+c.ape_paterno+' '+c.ape_materno,'SIN INFO') as CLIENTE,
--4. Obtener posición irrepetible x cliente
row_number() over(partition by ti.codcliente order by ti.numero asc) as POSICION
from cte_tel_i ti
left join Cliente c on ti.codcliente=c.codcliente

--06.12
--b

select codcliente,numdoc,nombres,ape_paterno,ape_materno from DevWifi2019.comercial.cliente
except
select codcliente,numdoc,nombres,ape_paterno,ape_materno from DEVWIFI18ED.dbo.Cliente 