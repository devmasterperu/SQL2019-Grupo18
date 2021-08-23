--05.01

--El total de contratos.
select count(*) from Contrato
--El total de contratos pertenecientes a clientes empresa.
select count(*) from Contrato co inner join
Cliente c on co.codcliente=c.codcliente
where c.tipo_cliente='E'
--El total de contratos pertenecientes a clientes persona.
select count(*) from Contrato co inner join
Cliente c on co.codcliente=c.codcliente
where c.tipo_cliente='P'
--El total de contratos pertenecientes a clientes de tipo desconocido.
select count(*) from Contrato co left join
Cliente c on co.codcliente=c.codcliente
where c.tipo_cliente is NULL

select co.codcliente,c.codcliente,c.tipo_cliente from Contrato co left join
Cliente c on co.codcliente=c.codcliente
where c.tipo_cliente is NULL

/*Consulta padre*/
select count(*) as TOT_C,
	   (select count(*) from Contrato co inner join
		Cliente c on co.codcliente=c.codcliente
		where c.tipo_cliente='E') as TOT_C_E,    --/*Consulta hijo*/
	   (select count(*) from Contrato co inner join
		Cliente c on co.codcliente=c.codcliente
		where c.tipo_cliente='P') as TOT_C_P,    --/*Consulta hijo*/
	   (select count(*) from Contrato co left join
		Cliente c on co.codcliente=c.codcliente
		where c.tipo_cliente is NULL) as TOT_C_O --/*Consulta hijo*/
from   Contrato

--05.03
--GOLD_IV
select count(*) from Contrato where codplan=6
--PLAN_TOTAL_I
select count(*) from Contrato where codplan=1
--GOLD_III
select count(*) from Contrato where codplan=5

--SUBCONSULTAS_SELECT
/*Consulta padre*/
select p.codplan,upper(replace(nombre,' ','_')) as [PLAN],
       (select count(*) from Contrato where codplan=p.codplan and estado=1) as TOTAL, /*Consulta hijo*/
	    case 
		when (select count(*) from Contrato where codplan=p.codplan) between 0 and 99 then 'Plan de baja demanda.'
		when (select count(*) from Contrato where codplan=p.codplan) between 100 and 199 then 'Plan de mediana demanda.'
		when (select count(*) from Contrato where codplan=p.codplan) >= 200 then 'Plan de alta demanda.'
		else 'No es posible obtener mensaje'
		end as MENSAJE
from PlanInternet p
order by TOTAL asc

--CODCLIENTE | NUM_CONTRATOS | NUM_TELEFONOS
--select codcliente,
--	   (select count(*) from Contrato where codcliente=c.codcliente),
--	   (select count(*) from Telefono where codcliente=c.codcliente)
--from   Cliente c

--SUBCONSULTAS_FROM

/*Consulta abuelo*/
select [PLAN],TOTAL,
case 
			when TOTAL between 0 and 99 then 'Plan de baja demanda.'
			when TOTAL between 100 and 199 then 'Plan de mediana demanda.'
			when TOTAL >= 200 then 'Plan de alta demanda.'
			else 'No es posible obtener mensaje'
			end as MENSAJE
from
(	/*Consulta padre*/
	select p.codplan,nombre as [PLAN],
		   (select count(*) from Contrato where codplan=p.codplan) as TOTAL /*Consulta hijo*/
	from PlanInternet p
) plan_inter
order by TOTAL asc

--BEGIN TRAN
--	update PlanInternet
--	set    nombre = upper(replace(nombre,' ','_'))
--	output inserted.nombre,deleted.nombre
--	where  codplan=1
--ROLLBACK

--05.05

select cast(round(35*100.00/120,2) as decimal(7,2))

select codplan as [CODPLAN], nombre as [PLAN],
       (select count(*) from Contrato where codplan=p.codplan) as [TOTAL-P],
	   (select count(*) from Contrato) as TOTAL,
	   cast(
		   round(
				   (select count(*) from Contrato where codplan=p.codplan)*100.00/
				   (select count(*) from Contrato),2
				)
		   as decimal(7,2)
		   ) as PORCENTAJE
from   PlanInternet p
order by PORCENTAJE desc

--05.07

--SUBCONSULTAS_SELECT

select codplan as [CODPLAN], nombre as [PLAN],
       isnull((select count(*) from Contrato where codplan=p.codplan),0) as [CO-TOTAL],
	   isnull((select avg(preciosol) from Contrato where codplan=p.codplan),0) as [CO-PROM],
	   isnull((select min(fec_contrato) from Contrato where codplan=p.codplan),'9999-12-31') as [CO-ANTIGUO],
	   isnull((select max(fec_contrato) from Contrato where codplan=p.codplan),'9999-12-31') as [CO-RECIENTE]
from   PlanInternet p

--SUBCONSULTAS_FROM

select p.codplan as [CODPLAN], nombre as [PLAN],
       --isnull((select count(*) from Contrato where codplan=p.codplan),0) as [CO-TOTAL],
	   isnull(rp.[CO-TOTAL],0) as [CO-TOTAL],
	   --isnull((select avg(preciosol) from Contrato where codplan=p.codplan),0) as [CO-PROM],
	   isnull(rp.[CO-PROM],0) as [CO-PROM],
	   --isnull((select min(fec_contrato) from Contrato where codplan=p.codplan),'9999-12-31') as [CO-ANTIGUO],
	   isnull(rp.[CO-ANTIGUO],'9999-12-31') as [CO-ANTIGUO],
	   --isnull((select max(fec_contrato) from Contrato where codplan=p.codplan),'9999-12-31') as [CO-RECIENTE]
	   isnull(rp.[CO-RECIENTE],'9999-12-31') as [CO-RECIENTE]
from   PlanInternet p
left join
(
select codplan,count(*) as [CO-TOTAL],avg(preciosol) as [CO-PROM],min(fec_contrato) as [CO-ANTIGUO],max(fec_contrato) as [CO-RECIENTE]
from   Contrato
group by codplan
) rp on p.codplan=rp.codplan

--CTE
with CTE_RP as
(
	select codplan,count(*) as [CO-TOTAL],avg(preciosol) as [CO-PROM],min(fec_contrato) as [CO-ANTIGUO],max(fec_contrato) as [CO-RECIENTE]
	from   Contrato
	group by codplan
)
select p.codplan as [CODPLAN], nombre as [PLAN],
       --isnull((select count(*) from Contrato where codplan=p.codplan),0) as [CO-TOTAL],
	   isnull(rp.[CO-TOTAL],0) as [CO-TOTAL],
	   --isnull((select avg(preciosol) from Contrato where codplan=p.codplan),0) as [CO-PROM],
	   isnull(rp.[CO-PROM],0) as [CO-PROM],
	   --isnull((select min(fec_contrato) from Contrato where codplan=p.codplan),'9999-12-31') as [CO-ANTIGUO],
	   isnull(rp.[CO-ANTIGUO],'9999-12-31') as [CO-ANTIGUO],
	   --isnull((select max(fec_contrato) from Contrato where codplan=p.codplan),'9999-12-31') as [CO-RECIENTE]
	   isnull(rp.[CO-RECIENTE],'9999-12-31') as [CO-RECIENTE]
from   PlanInternet p
left join CTE_RP rp on p.codplan=rp.codplan
order by [CO-TOTAL] desc
--select top(1) * from CTE_RP

--05.09

--SUBCONSULTAS_SELECT
select codcliente as [COD-CLIENTE],trim(nombres)+' '+trim(ape_paterno)+' '+trim(ape_materno) as CLIENTE,
       (select count(*) from Telefono where codcliente=c.codcliente) as [TOT-TE],
	   (select count(*) from Contrato where codcliente=c.codcliente) as [TOT-CO]
from Cliente c
where tipo_cliente='P'

--SUBCONSULTAS_FROM
select c.codcliente as [COD-CLIENTE],trim(nombres)+' '+trim(ape_paterno)+' '+trim(ape_materno) as CLIENTE,
       --(select count(*) from Telefono where codcliente=c.codcliente) as [TOT-TE],
	   isnull(rt.[TOT-TE],0) as [TOT-TE],
	   --(select count(*) from Contrato where codcliente=c.codcliente) as [TOT-CO]
	   isnull(rc.[TOT-CO],0) as [TOT-CO] 
from Cliente c
left join
(
	select codcliente,count(*) as [TOT-TE] 
	from Telefono
	group by codcliente
) rt on c.codcliente=rt.codcliente
left join
(
	select codcliente,count(*) as [TOT-CO] 
	from Contrato
	group by codcliente
) rc on c.codcliente=rc.codcliente
where tipo_cliente='P'

--CTES
with CTE_RT as
(
	select codcliente,count(*) as [TOT-TE] 
	from Telefono
	group by codcliente
), CTE_RC as
(
	select codcliente,count(*) as [TOT-CO] 
	from Contrato
	group by codcliente
) 
select c.codcliente as [COD-CLIENTE],trim(nombres)+' '+trim(ape_paterno)+' '+trim(ape_materno) as CLIENTE,
	   z.nombre as ZONA,
       --(select count(*) from Telefono where codcliente=c.codcliente) as [TOT-TE],
	   isnull(rt.[TOT-TE],0) as [TOT-TE],
	   (select sum([TOT-TE]) from CTE_RT) as #TEL,
	   --(select count(*) from Contrato where codcliente=c.codcliente) as [TOT-CO]
	   isnull(rc.[TOT-CO],0) as [TOT-CO],
	   (select sum([TOT-CO]) from CTE_RC) as #CON
from Cliente c
left join CTE_RT rt on c.codcliente=rt.codcliente
left join CTE_RC rc on c.codcliente=rc.codcliente
left join Zona z on c.codzona=z.codzona
where tipo_cliente='P'

--VISTAS

/*Vista RT*/
create view vw_RT as
select codcliente,count(*) as [TOT-TE] 
from Telefono
group by codcliente

select * from vw_RT

/*Vista RC*/
create view vw_RC as
select codcliente,count(*) as [TOT-CO] 
from Contrato
group by codcliente

select * from vw_RC

/*Vista Clientes*/
create or alter view vw_Clientes as
select c.codcliente as [COD-CLIENTE],trim(nombres)+' '+trim(ape_paterno)+' '+trim(ape_materno) as CLIENTE,
	   z.nombre as ZONA,
       --(select count(*) from Telefono where codcliente=c.codcliente) as [TOT-TE],
	   isnull(rt.[TOT-TE],0) as [TOT-TE],
	   (select sum([TOT-TE]) from vw_RT) as #TEL,
	   --(select count(*) from Contrato where codcliente=c.codcliente) as [TOT-CO]
	   isnull(rc.[TOT-CO],0) as [TOT-CO],
	   (select sum([TOT-CO]) from vw_RC) as #CON,
	   getdate() as fec_consulta
from Cliente c
left join vw_RT rt on c.codcliente=rt.codcliente
left join vw_RC rc on c.codcliente=rc.codcliente
left join Zona z on c.codzona=z.codzona
where tipo_cliente='P'

select co.codplan,vc.* from vw_Clientes vc
inner join Contrato co on vc.[COD-CLIENTE]=co.codcliente

select * from INFORMATION_SCHEMA.TABLES
select * from INFORMATION_SCHEMA.COLUMNS

--FUNCION_VALOR_TABLA

create or alter function uf_Clientes(@COD_CLIENTE int) returns table as
return
	select c.codcliente as [COD-CLIENTE],trim(nombres)+' '+trim(ape_paterno)+' '+trim(ape_materno) as CLIENTE,
		   z.nombre as ZONA,
		   --(select count(*) from Telefono where codcliente=c.codcliente) as [TOT-TE],
		   isnull(rt.[TOT-TE],0) as [TOT-TE],
		   (select sum([TOT-TE]) from vw_RT) as #TEL,
		   --(select count(*) from Contrato where codcliente=c.codcliente) as [TOT-CO]
		   isnull(rc.[TOT-CO],0) as [TOT-CO],
		   (select sum([TOT-CO]) from vw_RC) as #CON,
		   getdate() as fec_consulta
	from Cliente c
	left join vw_RT rt on c.codcliente=rt.codcliente
	left join vw_RC rc on c.codcliente=rc.codcliente
	left join Zona z on c.codzona=z.codzona
	where tipo_cliente='P' and c.codcliente=IIF(@COD_CLIENTE=0,c.codcliente,@COD_CLIENTE)

create or alter function uf_Clientes(@TEXTO varchar(100),@ESTADO bit) returns table as
return
	select c.codcliente as [COD-CLIENTE],trim(nombres)+' '+trim(ape_paterno)+' '+trim(ape_materno) as CLIENTE,
		   z.nombre as ZONA,
		   --(select count(*) from Telefono where codcliente=c.codcliente) as [TOT-TE],
		   isnull(rt.[TOT-TE],0) as [TOT-TE],
		   (select sum([TOT-TE]) from vw_RT) as #TEL,
		   --(select count(*) from Contrato where codcliente=c.codcliente) as [TOT-CO]
		   isnull(rc.[TOT-CO],0) as [TOT-CO],
		   (select sum([TOT-CO]) from vw_RC) as #CON,
		   getdate() as fec_consulta
	from Cliente c
	left join vw_RT rt on c.codcliente=rt.codcliente
	left join vw_RC rc on c.codcliente=rc.codcliente
	left join Zona z on c.codzona=z.codzona
	where tipo_cliente='P' and trim(nombres)+' '+trim(ape_paterno)+' '+trim(ape_materno) LIKE '%'+@TEXTO+'%' and c.estado=@ESTADO--LIKE '%TEXTO%'

select * from uf_Clientes('MAR',1)

--05.10

select codcliente,count(*) as total
from Telefono
where tipo='LLA'
group by codcliente

select codcliente,count(*) as total
from Telefono
where tipo='SMS'
group by codcliente

select codcliente,count(*) as total
from Telefono
where tipo='WSP'
group by codcliente

--SUBCONSULTAS_FROM
select c.codcliente as CODIGO,razon_social as EMPRESA,
isnull(rlla.total,0)+isnull(rsms.total,0)+isnull(rwsp.total,0) as [TOT-TE],
isnull(rlla.total,0) as [TOT-LLA],
isnull(rsms.total,0) as [TOT-SMS],
isnull(rwsp.total,0) as [TOT-WSP]
from Cliente c
left join
(
	select codcliente,count(*) as total
	from Telefono
	where tipo='LLA'
	group by codcliente
)   rlla on c.codcliente=rlla.codcliente
left join
(
	select codcliente,count(*) as total
	from Telefono
	where tipo='SMS'
	group by codcliente
)   rsms on c.codcliente=rsms.codcliente
left join
(
	select codcliente,count(*) as total
	from Telefono
	where tipo='WSP'
	group by codcliente
)   rwsp on c.codcliente=rwsp.codcliente
where tipo_cliente='E'
order by [TOT-TE] desc, [TOT-LLA] desc

--CTES (TAREA)
--VISTAS (TAREA)
--FUNCION VALOR TABLA (TAREA)