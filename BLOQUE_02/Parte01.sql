declare @a int=10 --Declarar variable a del tipo entero con valor 10
declare @b int=3

--C�lculos matem�ticos
select 'suma'=@a+@b,'resta'=@a-@b,'multiplica'=@a*@b,'cociente'=@a/@b,'resto'=@a%@b

--Concatenaci�n
declare @sujeto varchar(50)='El estudiante',@predicado varchar(50)=' asisti� a clases'

select @sujeto+@predicado