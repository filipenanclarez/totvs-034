User Function MT103FIM()
Local nOpcao 	:= PARAMIXB[1]// Opção Escolhida pelo usuario no aRotina
Local nConfirma := PARAMIXB[2]// Se o usuario confirmou a operação de gravação da NFE
Local aTabelas	:= {"SF1","SE2","SC7"}

if(nOpcao == 3 .and. nConfirma == 1)//Inclusao
	
	U_REPLICADADOS('COM',aTabelas,1)
	
elseif(nOpcao == 3 .and. nConfirma == 1)//Exclusao
	For nx := 1 to len(aTabelas)
		
		if(aTabelas[nx] == "SE2")
			nIndex := 6
		else
			nIndex := 1
		endif
		
		if(aTabelas[nx] == "SE2")
			cChave := "E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM"
		elseif(aTabelas[nx] == "SD1")
			cChave := "D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA"
		else
			cChave := ((aTabelas[nx])->(IndexKey(nIndex)))
		endif
		
		dbSelectArea(aTabelas[nx])
		(aTabelas[nx])->(dbSetOrder(nIndex))
		U_REPLICADADOS('COM',{aTabelas[nx]},3,1, &(cChave), cChave )
		
	Next nx
endif

Return