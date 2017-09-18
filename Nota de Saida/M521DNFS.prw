User Function M521DNFS
/*MS520DEL*/
/*
REPLICADADOS(cMod , aTabelas , nOpc ,nInd ,cIndCont,cIndChave)
Sendo:
cMod 	 = Modulo
aTabelas = Tabela
nOpc 	 = 1=Inclui, 2=Altera, 3=Exclui
nInd 	 = Indice
cIndCont = conteudo da chave para busca
cIndChave= chave para busca
*/

Local aTabelas	:= {"SC5","SC6","SF2","SD2","SF3","SE1","SFT","CD2","SC9"}
Local nx
For nx := 1 to len(aTabelas)
	
	if(aTabelas[nx] == "SD2")
		nIndex := 8
	elseif(aTabelas[nx] == "SF3")
		nIndex := 4
	else
		nIndex := 1
	endif
	
	if(aTabelas[nx] == "SC6")
		cChave := "C6_FILIAL+C6_NUM"
	elseif(aTabelas[nx] == "SD2")
		cChave := "D2_FILIAL+D2_PEDIDO"
	else
		cChave := ((aTabelas[nx])->(IndexKey(nIndex)))
	endif
	
	dbSelectArea(aTabelas[nx])
	(aTabelas[nx])->(dbSetOrder(nIndex))
	U_REPLICADADOS('FAT',{aTabelas[nx]},3,1, &(cChave), cChave )

Next nx

Return