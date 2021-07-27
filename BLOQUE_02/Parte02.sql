USE DEVWIFI18ED
go

--02.12

select rtrim(ltrim('    DEV MASTER     '))
select concat('CLASE ','CUATRO',NULL) --'CLASE '+'CUATRO'+' 2021'

select 
IIF(codtipo=1,'LE o DNI',IIF(codtipo=3,'RUC','OTRO')) as TIPO_DOC,
numdoc as NUM_DOC,
concat(trim(nombres),' ',trim(ape_paterno),' ',trim(ape_materno)) as CLIENTE
/*
case when codtipo=1 then 'LE o DNI'
     when codtipo=3 then 'RUC'
	 else 'OTRO'
end  as TIPO_DOC
*/
from Cliente
where tipo_cliente='P' and
--trim(nombres) like 'A%' --a.Nombre completo inicie en ‘A’.
--concat(trim(nombres),' ',trim(ape_paterno),' ',trim(ape_materno)) LIKE '%AMA%'--b.Nombre completo contiene la secuencia ‘AMA’.
--concat(trim(nombres),' ',trim(ape_paterno),' ',trim(ape_materno)) LIKE '%AN'--c.Nombre completo finaliza en 'AN'.
--concat(trim(nombres),' ',trim(ape_paterno),' ',trim(ape_materno)) LIKE '_ARI%'--e.Nombre completo contenga la secuencia ‘ARI’ desde la 2° posición.
--concat(trim(nombres),' ',trim(ape_paterno),' ',trim(ape_materno)) LIKE '%M__'--f.Nombre completo tenga como antepenúltimo carácter la ‘M’.
--concat(trim(nombres),' ',trim(ape_paterno),' ',trim(ape_materno)) LIKE '[aeiou]%[aeiou]'--h.Nombre completo inicie y finalice con una vocal
--concat(trim(nombres),' ',trim(ape_paterno),' ',trim(ape_materno)) LIKE '[^aeiou]%[^aeiou]'--i.Nombre completo inicie y finalice con una consonante.
concat(trim(nombres),' ',trim(ape_paterno),' ',trim(ape_materno)) LIKE '[aeiou]%[^aeiou]'--j.Nombre inicie con una vocal y finalice con una consonante.

select razon_social from Cliente
where razon_social like '%*%' --"_" Pendiente búsqueda caracteres ASCII:[,],_

--02.13

select codzona,count(codcliente)
from Cliente
where tipo_cliente='E'
group by codzona --Resumen x codzona

select estado,count(codcliente)
from Cliente
where tipo_cliente='E'
group by estado --Resumen x estado

select codzona,estado,count(codcliente) as TOT_CLIENTES,min(fec_inicio) as MIN_FEC_INICIO,max(fec_inicio) as MAX_FEC_INICIO,
case when count(codcliente)>=0 and count(codcliente)<20  then 'TOTAL_INFERIOR'
	 when count(codcliente)>=20 and count(codcliente)<40 then 'TOTAL_MEDIO'
	 when count(codcliente)>=40                          then 'TOTAL_SUPERIOR'
     else 'SIN DETALLE'
end as MENSAJE
from Cliente
where tipo_cliente='E'
group by codzona,estado --Resumen x codzona y estado
having count(codcliente)>10 --"WHERE" a nivel de grupos

create view vw_Cliente as
select codzona,estado,count(codcliente) as TOT_CLIENTES,min(fec_inicio) as MIN_FEC_INICIO,max(fec_inicio) as MAX_FEC_INICIO,
case when count(codcliente)>=0 and count(codcliente)<20  then 'TOTAL_INFERIOR'
	 when count(codcliente)>=20 and count(codcliente)<40 then 'TOTAL_MEDIO'
	 when count(codcliente)>=40                          then 'TOTAL_SUPERIOR'
     else 'SIN DETALLE'
end as MENSAJE
from Cliente
where tipo_cliente='E'
group by codzona,estado --Resumen x codzona y estado

select * from vw_Cliente
where TOT_CLIENTES>10

--having codzona=1

--02.15

--NOTA 01
select top(15) estado,codzona,count(codcliente) as TOT_CLIENTES,min(trim(ape_paterno)) as MIN_APE_PAT,max(trim(ape_paterno)) as MAX_APE_PAT,
case when count(codcliente)>=0 and count(codcliente)<15  then 'INFERIOR'
	 when count(codcliente)>=15 and count(codcliente)<30 then 'MEDIO'
     when count(codcliente)>=30                          then 'SUPERIOR'
else 'SIN DETALLE'
end as MENSAJE
from Cliente
where tipo_cliente='P'
group by estado,codzona
order by TOT_CLIENTES desc

--NOTA 02:top(15) PERCENT=0.15*#combinaciones

select 0.20*count(codcliente)
from   Cliente
where  tipo_cliente='P'

select --top(15) PERCENT 
estado,codzona,count(codcliente) as TOT_CLIENTES,min(trim(ape_paterno)) as MIN_APE_PAT,max(trim(ape_paterno)) as MAX_APE_PAT,
case when count(codcliente)>=0 and count(codcliente)<15  then 'INFERIOR'
	 when count(codcliente)>=15 and count(codcliente)<30 then 'MEDIO'
     when count(codcliente)>=30                          then 'SUPERIOR'
else 'SIN DETALLE'
end as MENSAJE
from Cliente
where tipo_cliente='P'
group by estado,codzona
--having count(codcliente)<120
order by TOT_CLIENTES desc

--20% DEL TOTAL DE CLIENTES

select top(20) PERCENT codcliente,tipo_cliente,codtipo,numdoc 
from Cliente
order by codcliente desc

--NOTA_03

select top(15) with ties
estado,codzona,count(codcliente) as TOT_CLIENTES,min(trim(ape_paterno)) as MIN_APE_PAT,max(trim(ape_paterno)) as MAX_APE_PAT,
case when count(codcliente)>=0 and count(codcliente)<15  then 'INFERIOR'
	 when count(codcliente)>=15 and count(codcliente)<30 then 'MEDIO'
     when count(codcliente)>=30                          then 'SUPERIOR'
else 'SIN DETALLE'
end as MENSAJE
from Cliente
where tipo_cliente='P'
group by estado,codzona
order by TOT_CLIENTES desc

--NOTA_04
select top(40) PERCENT with ties--0.40
estado,codzona,count(codcliente) as TOT_CLIENTES,min(trim(ape_paterno)) as MIN_APE_PAT,max(trim(ape_paterno)) as MAX_APE_PAT,
case when count(codcliente)>=0 and count(codcliente)<15  then 'INFERIOR'
	 when count(codcliente)>=15 and count(codcliente)<30 then 'MEDIO'
     when count(codcliente)>=30                          then 'SUPERIOR'
else 'SIN DETALLE'
end as MENSAJE
from Cliente
where tipo_cliente='P'
group by estado,codzona
--having count(codcliente)<120
order by TOT_CLIENTES desc

--02.17

declare @t int=10,@n int=60

select codcliente,
concat(trim(nombres),' ',trim(ape_paterno),' ',trim(ape_materno)) as CLIENTE
from Cliente
where tipo_cliente='P' --TIP
order by CLIENTE asc
/*a.Página 1 y tamaño de página 10 [Posición 1 – 10].
offset 0 rows --(1-1))*10
fetch next 10 rows only
*/
/*b.Página 2 y tamaño de página 10 [Posición 11-20].
offset 10 rows --(2-1)*10
fetch next 10 rows only
*/
/*c.Página n y tamaño de página t [Posición 21-30].*/
offset (@n-1)*@t rows 
fetch next @t rows only