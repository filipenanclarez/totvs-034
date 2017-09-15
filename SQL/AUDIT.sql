//Essas duas querys, foram criadas para executar auditoria nas tabelas alteradas do sistema
//precisavamos monitorar todas as tabelas
//então, achei esse código, e mesclei com outros para chegar no seguinte resultado

//1º Cria a tabela que receberá os dados da auditoria
/*Tabela de Auditoria*/
create table TB_AUDIT (
	ID int identity not null,
	DATA_OPERACAO datetime,
	USUARIO varchar(100),
	TABELA varchar(100),
	OPERACAO char(1),
	OLD_DATA xml,
	NEW_DATA xml
);


//2º - Executa um select, que vai trazer linha alinha, em cada linha, a criação 
//da trigger para cada tabela
//o unico ponto de atenção é que para executar todas em sequencia, precisa de um 'GO' entre as linhas, 
//não consegui colocar no final da linha nem com ';'
//então, colei no notepad++ e aí usei uma macro para incluir as linhas com 'GO' entre as linhas de comando
//com isso ele criou a trigger em todas as tabelas, e se tiver alguma tabela que naõ seja desejado que venha, basta removar 
//manualmente dela via Managment, ou DROP mesmo
USE Protheus_12_1_7;
SELECT 'CREATE TRIGGER ' + QUOTENAME('trgTraceDMLIn' + name) + '
ON ' + QUOTENAME(name) + '
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	declare @Operacao char(1);
	declare @OLD_DATA xml;
	declare @NEW_DATA xml;
	/*Verifica a operação realizada*/
	if ( (select count(*) from INSERTED) > 0 and (select count(*) from DELETED) > 0)
	begin
		set @Operacao = ''U'';
	end
	if ( (select count(*) from INSERTED) = 0 and (select count(*) from DELETED) > 0)
	begin
		set @Operacao = ''D'';
	end
	if ( (select count(*) from INSERTED) > 0 and (select count(*) from DELETED) = 0)
	begin
		set @Operacao = ''I'';
	end

	/*Grava os dados na tabela de auditoria*/
	if (@Operacao = ''I'')
	begin
		set @NEW_DATA = ''(select * from INSERTED for xml auto)'';
		set @OLD_DATA = null;
		insert into TB_AUDIT (DATA_OPERACAO,USUARIO,TABELA,OPERACAO,OLD_DATA,NEW_DATA) values
		(getdate(),host_name(),''' + QUOTENAME(name) + ''',@Operacao,@OLD_DATA,@NEW_DATA);
	end

	if (@Operacao = ''D'')
	begin
		set @NEW_DATA = null;
		set @OLD_DATA = ''(select * from DELETED for xml auto)'';
		insert into TB_AUDIT (DATA_OPERACAO,USUARIO,TABELA,OPERACAO,OLD_DATA,NEW_DATA) values
		(getdate(),host_name(),''' + QUOTENAME(name) + ''',@Operacao,@OLD_DATA,@NEW_DATA);
	end

	if (@Operacao = ''U'')
	begin
		set @NEW_DATA = ''(select * from INSERTED for xml auto)'';
		set @OLD_DATA = ''(select * from DELETED for xml auto)'';
		insert into TB_AUDIT (DATA_OPERACAO,USUARIO,TABELA,OPERACAO,OLD_DATA,NEW_DATA) values
		(getdate(),host_name(),''' + QUOTENAME(name) + ''',@Operacao,@OLD_DATA,@NEW_DATA);
	end
END
/*GO*/'
FROM dbo.sysobjects 
WHERE xtype = 'U'