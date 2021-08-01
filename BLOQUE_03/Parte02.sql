--03.04

--L.E. - DNI

select top(100) 
--IIF(codtipo=1,'L.E. - DNI','OTRO'),
t.desc_corta as TIPO_DOC,
c.numdoc as NUM_DOC,
concat(trim(nombres),' ',trim(ape_paterno),' ',trim(ape_materno)) as NOMBRE_COMPLETO,
c.fec_nacimiento as FECHA_NAC,
c.direccion as DIRECCION,
z.nombre as ZONA
from Cliente c 
inner join TipoDocumento t on c.codtipo=t.codtipo
inner join Zona z on c.codzona=z.codzona
where tipo_cliente='P' and c.estado=1
order by NOMBRE_COMPLETO asc

--03.06

select t.tipo as TIPO,t.numero as NUMERO,t.codcliente as COD_CLIENTE,c.tipo_cliente,c.razon_social as EMPRESA,
z.nombre as ZONA
from Telefono t
inner join Cliente c on t.codcliente=c.codcliente
inner join Zona z on c.codzona=z.codzona
where t.estado=1 --c.estado (Estado del cliente) | t.estado (Estado del teléfono) 
and c.tipo_cliente='E'
order by c.codcliente asc

--03.08

--LEFT_JOIN
select t.tipo as TIPO,t.numero as NUMERO, 
case when c.tipo_cliente='E' then c.razon_social
	 when c.tipo_cliente='P' then concat(trim(c.nombres),' ',trim(c.ape_paterno),' ',trim(c.ape_materno))
	 else 'SIN DETALLE'
end as CLIENTE,
isnull(c.email,'SIN DETALLE') as EMAIL,
convert(varchar(8),getdate(),112) as FEC_CONSULTA
from Telefono t
left join Cliente c on t.codcliente=c.codcliente --retorne los teléfonos y los ordene por email del cliente relacionado (Z-A)
where t.estado=1
order by c.email desc

--RIGHT_JOIN_I
select t.tipo as TIPO,t.numero as NUMERO, 
case when c.tipo_cliente='E' then c.razon_social
	 when c.tipo_cliente='P' then concat(trim(c.nombres),' ',trim(c.ape_paterno),' ',trim(c.ape_materno))
	 else 'SIN DETALLE'
end as CLIENTE,
isnull(c.email,'SIN DETALLE') as EMAIL,
convert(varchar(8),getdate(),112) as FEC_CONSULTA
from Telefono t
right join Cliente c on t.codcliente=c.codcliente --retorne los teléfonos y los ordene por email del cliente relacionado (Z-A)
where t.estado=1
order by c.email desc

--RIGHT_JOIN_II
select t.tipo as TIPO,t.numero as NUMERO, 
case when c.tipo_cliente='E' then c.razon_social
	 when c.tipo_cliente='P' then concat(trim(c.nombres),' ',trim(c.ape_paterno),' ',trim(c.ape_materno))
	 else 'SIN DETALLE'
end as CLIENTE,
isnull(c.email,'SIN DETALLE') as EMAIL,
convert(varchar(8),getdate(),112) as FEC_CONSULTA
from  Cliente c
right join Telefono t on t.codcliente=c.codcliente --retorne los teléfonos y los ordene por email del cliente relacionado (Z-A)
where t.estado=1
order by c.email desc

--03.10

--LEFT JOIN
select codcliente as [CODIGO CLIENTE],isnull(p.nombre,'SIN DATO') as [NOMBRE PLAN],isnull(p.precioref,0.00) as [PRECIO PLAN],
co.preciosol as [PRECIO CONTRATO],co.fec_contrato as [FECHA_CONTRATO]
/*Mostrar los contratos independientemente de contar con plan de internet relacionado*/
from Contrato co
left join PlanInternet p on co.codplan=p.codplan
--where p.codplan is null --Registros que están en contrato pero no en Plan de Internet
order by p.nombre

--RIGHT JOIN
select codcliente as [CODIGO CLIENTE],isnull(p.nombre,'SIN DATO') as [NOMBRE PLAN],isnull(p.precioref,0.00) as [PRECIO PLAN],
co.preciosol as [PRECIO CONTRATO],co.fec_contrato as [FECHA_CONTRATO]
/*Mostrar los contratos independientemente de contar con plan de internet relacionado*/
from PlanInternet p
right join Contrato co  on co.codplan=p.codplan
--where p.codplan is null --Registros que están en contrato pero no en Plan de Internet
order by p.nombre
