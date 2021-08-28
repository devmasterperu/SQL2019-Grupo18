--06.01
--OVER + AGRUPAMIENTO
select codplan,codcliente,preciosol,
sum(preciosol) over(partition by codplan) as PRE_SUM,
avg(preciosol) over(partition by codplan) as PRE_PROM,
count(*)    over(partition by codplan) as PRE_TOT,
min(preciosol) over(partition by codplan) as PRE_MIN,
max(preciosol) over(partition by codplan) as PRE_MAX
from Contrato
order by codplan

--SUBCONSULTAS
select co.codplan,preciosol,
rco.PRE_SUM as PRE_SUM,
rco.PRE_PROM as PRE_PROM,
rco.PRE_TOT as PRE_TOT,
rco.PRE_MIN as PRE_MIN,
rco.PRE_MAX as PRE_MAX
from Contrato co 
left join
(
	select codplan,sum(preciosol) as PRE_SUM,avg(preciosol) as PRE_PROM,
	       count(*) as PRE_TOT,min(preciosol) as PRE_MIN,max(preciosol) as PRE_MAX
	from Contrato
	group by codplan
) rco on co.codplan=rco.codplan
order by codplan

--VISTA
create view vw_Contrato_Grupo as
select codplan,codcliente,preciosol,
sum(preciosol) over(partition by codplan) as PRE_SUM,
avg(preciosol) over(partition by codplan) as PRE_PROM,
count(*)    over(partition by codplan) as PRE_TOT,
min(preciosol) over(partition by codplan) as PRE_MIN,
max(preciosol) over(partition by codplan) as PRE_MAX
from Contrato

select * from vw_Contrato_Grupo
order by codplan,preciosol

--06.03
--Consulta
select codcliente as CODIGO,razon_social as EMPRESA,fec_inicio as FEC_INICIO,
row_number() over(order by fec_inicio asc) as RN,
rank() over(order by fec_inicio asc) as RK,
dense_rank() over(order by fec_inicio asc) as DRK,
ntile(5) over(order by fec_inicio asc) as N5
from Cliente
where tipo_cliente='E'
order by fec_inicio asc

--Función valor tabla
create function uf_cliente_ranking() returns table as
return
	select codcliente as CODIGO,razon_social as EMPRESA,fec_inicio as FEC_INICIO,
	row_number() over(order by fec_inicio asc) as RN,
	rank() over(order by fec_inicio asc) as RK,
	dense_rank() over(order by fec_inicio asc) as DRK,
	ntile(5) over(order by fec_inicio asc) as N5
	from Cliente
	where tipo_cliente='E'

select * from uf_cliente_ranking()
order by fec_inicio asc

--06.05

select c.codcliente as CODIGO,
trim(c.nombres)+' '+trim(c.ape_paterno)+' '+trim(c.ape_materno) as CLIENTE,
codzona as ZONA,
isnull(rc.tel,0) as N_TEL,
row_number() over(partition by codzona order by isnull(rc.tel,0) asc) as R1,
rank() over(partition by codzona order by isnull(rc.tel,0) asc) as R2,
dense_rank() over(partition by codzona order by isnull(rc.tel,0) asc) as R3,
ntile(4) over(partition by codzona order by isnull(rc.tel,0) asc) as R4
from Cliente c
left join (
	select codcliente,count(*) as tel from Telefono
	group by codcliente
) rc on c.codcliente=rc.codcliente
where tipo_cliente='P'

--CTE
with CTE_Ranking as
(
	select codcliente,count(*) as tel from Telefono
	group by codcliente
)
select c.codcliente as CODIGO,
trim(c.nombres)+' '+trim(c.ape_paterno)+' '+trim(c.ape_materno) as CLIENTE,
codzona as ZONA,
isnull(rc.tel,0) as N_TEL,
row_number() over(partition by codzona order by isnull(rc.tel,0) asc) as R1,
rank() over(partition by codzona order by isnull(rc.tel,0) asc) as R2,
dense_rank() over(partition by codzona order by isnull(rc.tel,0) asc) as R3,
ntile(4) over(partition by codzona order by isnull(rc.tel,0) asc) as R4
from Cliente c
left join CTE_Ranking rc on c.codcliente=rc.codcliente
where tipo_cliente='P'
order by ZONA,N_TEL

--06.07
with cte_rc as
(
	select codcliente,count(*) as total from Contrato
	group by codcliente
)
select c.codcliente as #,razon_social as CLIENTE,codzona as ZONA,
       isnull(rc.total,0) as TOTAL,
	   row_number() over(partition by codzona order by isnull(rc.total,0) asc) as E1,
	   lag(c.razon_social) over(partition by codzona order by isnull(rc.total,0) asc) as E2,
	   lead(c.razon_social) over(partition by codzona order by isnull(rc.total,0) asc) as E3,
	   first_value(c.razon_social) over(partition by codzona order by isnull(rc.total,0) asc) as E4,
	   last_value(c.razon_social) over(partition by codzona order by isnull(rc.total,0) asc) as E5
from Cliente c left join
cte_rc rc on c.codcliente=rc.codcliente
where tipo_cliente='E'

--Función valor tabla
create or alter function uf_rcliente() returns table as
return
	with cte_rc as
	(
		select codcliente,count(*) as total from Contrato
		group by codcliente
	)
	select c.codcliente as #,razon_social as CLIENTE,codzona as ZONA,
		   isnull(rc.total,0) as TOTAL,
		   row_number() over(partition by codzona order by isnull(rc.total,0) asc) as E1,
		   lag(c.razon_social) over(partition by codzona order by isnull(rc.total,0) asc) as E2,
		   lead(c.razon_social) over(partition by codzona order by isnull(rc.total,0) asc) as E3,
		   first_value(c.numdoc+ '-' +c.razon_social) over(partition by codzona order by isnull(rc.total,0) asc) as E4,
		   last_value(c.razon_social) over(partition by codzona order by isnull(rc.total,0) asc) as E5,
		   lag(c.numdoc) over(partition by codzona order by isnull(rc.total,0) asc) as E6,
		   lead(c.numdoc) over(partition by codzona order by isnull(rc.total,0) asc) as E7
	from Cliente c left join
	cte_rc rc on c.codcliente=rc.codcliente
	where tipo_cliente='E'

select * from uf_rcliente()
order by ZONA,TOTAL