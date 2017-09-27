#Include "PROTHEUS.CH"

USER FUNCTION FA080PE()

	//Verifica tratativa para ler o campo customizado do SE2, para mandar apenas os titulos 
	//que o cliente escolher

	U_REPLICADADOS('FIN',{'SFT'},1)

RETURN