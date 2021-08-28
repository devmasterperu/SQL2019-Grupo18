--05.12
select eomonth('2021-11-02')
select eomonth('2021-11-02',-1)
select eomonth('2021-11-02',1)

select coalesce('primero',NULL,'defecto')
select coalesce(NULL,'segundo','defecto')
select coalesce(NULL,NULL,'defecto')

--1.Obtener precio promedio de contratos activos
select avg(preciosol) from Contrato where estado=1 --84.840595

--2.Contratos con precio actual mayor al precio promedio de los contratos activos
select coalesce(trim(c.nombres)+' '+trim(c.ape_paterno)+' '+trim(c.ape_materno),c.razon_social,'SIN DATO') as CLIENTE,
isnull(p.nombre,'SIN DATO') as [PLAN],
isnull(co.fec_contrato,'9999-12-31') as FECHA,
isnull(co.preciosol,0.00) as PRECIO,
cast(round((select avg(preciosol) from Contrato where estado=1),2) as decimal(9,2))as PROMEDIO,
eomonth(getdate()) as F_CIERRE
from Contrato co
left join Cliente c on co.codcliente=c.codcliente
left join PlanInternet p on co.codplan=p.codplan
where preciosol>(select avg(preciosol) from Contrato where estado=1)
order by preciosol desc

--3.Vista
create view dbo.vw_ReporteContratos as
select coalesce(trim(c.nombres)+' '+trim(c.ape_paterno)+' '+trim(c.ape_materno),c.razon_social,'SIN DATO') as CLIENTE,
isnull(p.nombre,'SIN DATO') as [PLAN],
isnull(co.fec_contrato,'9999-12-31') as FECHA,
isnull(co.preciosol,0.00) as PRECIO,
cast(round((select avg(preciosol) from Contrato where estado=1),2) as decimal(9,2))as PROMEDIO,
eomonth(getdate()) as F_CIERRE
from Contrato co
left join Cliente c on co.codcliente=c.codcliente
left join PlanInternet p on co.codplan=p.codplan
where preciosol>(select avg(preciosol) from Contrato where estado=1)

select * from dbo.vw_ReporteContratos
order by PRECIO desc

--4.Función valor tabla
create function dbo.uf_ReporteContratos() returns table as
return
	select coalesce(trim(c.nombres)+' '+trim(c.ape_paterno)+' '+trim(c.ape_materno),c.razon_social,'SIN DATO') as CLIENTE,
	isnull(p.nombre,'SIN DATO') as [PLAN],
	isnull(co.fec_contrato,'9999-12-31') as FECHA,
	isnull(co.preciosol,0.00) as PRECIO,
	cast(round((select avg(preciosol) from Contrato where estado=1),2) as decimal(9,2))as PROMEDIO,
	eomonth(getdate()) as F_CIERRE
	from Contrato co
	left join Cliente c on co.codcliente=c.codcliente
	left join PlanInternet p on co.codplan=p.codplan
	where preciosol>(select avg(preciosol) from Contrato where estado=1)

select * from dbo.uf_ReporteContratos()
order by PRECIO desc