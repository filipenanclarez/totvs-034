#Include "PROTHEUS.CH"

USER FUNCTION Fa040DEL()
	
	//ALERT('PONTO DE ENTRADA F040ALT CHAMADO COM SUCESSO!')
	//Reclock("SE1",.F.)	
		//E1_HIST := 'PE F040FCR OK'
	//MsUnlock()
	
	U_REPLICADADOS('FIN',{'SE1'},3,1,&(IndexKey(1)))
	
	//para a SE1, o indice unico � o 1 mesmo
		
	//Conout('IndexOrd () ' + cValToChar(IndexOrd ()))
	
	//Conout('IndexKey() ' + IndexKey()) 
	
	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	
		
RETURN

