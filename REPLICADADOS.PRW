//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch" 
#include "fileio.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �REPLICADADOS   �Autor  �xxxxxx          � Data �  XX/XX/XX  ���
�������������������������������������������������������������������������͹��
���Desc.     � XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                            ���
���          � XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                            ���
�������������������������������������������������������������������������͹��
���Uso       � XX                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function REPLICADADOS(cMod /*M�dulo*/, aTabelas /*Tabela*/, nOpc /*1=Inclui, 2=Altera, 3=Exclui*/ ,;
							nInd /*Indice*/, cIndCont /*conteudo da chave para busca*/)
	Local aArea		:= GetArea()
	Local aAreaSC6	:= SC6->(GetArea())
	Local aAreaSC5	:= SC5->(GetArea())
	Local aAreaSF2	:= SF2->(GetArea())
	Local aAreaSD2	:= SD2->(GetArea())
	Local aAreaSE1	:= SE1->(GetArea())
	Local aEstCab	:= {}
	Local aContCab	:= {}
	Local aEstGet	:= {}
	Local aContGet	:= {}
	Local aTabelas	:= aTabelas //{"SC5","SF2","SF3","SE1","SFT","CD2","SC9"}
	Local cNewAlias	:= ""
	Local cAlias	:= ""
	
	cquery := "DELETE FROM SC5020; "
	cquery += "DELETE FROM SC6020; "
	cquery += "DELETE FROM SF2020; "
	cquery += "DELETE FROM SD2020; "
	cquery += "DELETE FROM SF3020; "
	cquery += "DELETE FROM SE1020; "
	cquery += "DELETE FROM SFT020; "
	cquery += "DELETE FROM CD2020; "
	cquery += "DELETE FROM SC9020; "
	nStatus := TCSqlExec(cquery)
	
	if (nStatus < 0)
		//conout("TCSQLError() " + TCSQLError())
	endif

	For ni := 1 to len(aTabelas)
		
		aEstCab	:= {}
		aContCab:= {}
		aEstGet	:= {}
		aContGet:= {}
		cAlias	:= aTabelas[ni]
				
		DbSelectArea(cAlias)
		
		aEstCab := (cAlias)->(DbStruct())
		
		ProcRegua(Len(aEstCab))
		
		aAdd(aContCab,{})
		For nAtual := 1 To Len(aEstCab)
			IncProc("Adicionando valores ("+cValToChar(nAtual)+" de "+cValToChar(Len(aEstCab))+")...")
			aAdd(aContCab[1], &(cAlias+"->"+aEstCab[nAtual][1]))
		Next nAtual
		
		if (cAlias == "SC5")
			
			cNewAlias := "SC6"
			
			DbSelectArea(cNewAlias)
			DbSetOrder(1)
			If DbSeek(xFilial(cNewAlias)+ SC5->C5_NUM)
				
				aEstGet := (cNewAlias)->(DbStruct())
				nItens := 1
				While (!Eof(cNewAlias)) .And. (xFilial(cAlias) == xFilial(cNewAlias)) .And. (SC5->C5_NUM == (cNewAlias)->C6_NUM)
		
					ProcRegua(Len(aEstGet))
					aAdd(aContGet,{})
					For nAtual := 1 To Len(aEstGet)
						IncProc("Adicionando valores ("+cValToChar(nAtual)+" de "+cValToChar(Len(aEstGet))+")...")
						aAdd(aContGet[nItens], &(cNewAlias+"->"+aEstGet[nAtual][1]) )
					Next nAtual
					nItens++
					(cNewAlias)->(DbSkip())
				EndDo
			EndIf
			
		elseif (cAlias == "SF2")
			
			cNewAlias := "SD2"
			
			DbSelectArea(cNewAlias)
			DbSetOrder(3)
			If DbSeek(xFilial(cNewAlias)+ SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA )
				
				aEstGet := (cNewAlias)->(DbStruct())
				nItens := 1
				While (!Eof(cNewAlias)) .And. (xFilial(cAlias) == xFilial(cNewAlias)) .And.;
					SF2->F2_DOC 	= (cNewAlias)->D2_DOC 		.and. SF2->F2_SERIE = (cNewAlias)->D2_SERIE .and.;
					SF2->F2_CLIENTE	= (cNewAlias)->D2_CLIENTE 	.and. SF2->F2_LOJA  = (cNewAlias)->D2_LOJA
					
					ProcRegua(Len(aEstGet))
					aAdd(aContGet,{})
					For nAtual := 1 To Len(aEstGet)
						IncProc("Adicionando valores ("+cValToChar(nAtual)+" de "+cValToChar(Len(aEstGet))+")...")
						aAdd(aContGet[nItens], &(cNewAlias+"->"+aEstGet[nAtual][1]))
					Next nAtual
					nItens++
					(cNewAlias)->(DbSkip())
				EndDo
			EndIf
		endIf
		
		StartJob("U_GravaDados",GetEnvServer(), .F.,"ZZ", "01",cAlias,aEstCab,aContCab,cMod,nOpc,nInd,cIndCont)
		
		if(cAlias$"SC5*SF2")
			StartJob("U_GravaDados",GetEnvServer(), .F.,"ZZ", "01",cNewAlias,aEstGet,aContGet,cMod,nOpc,nInd,cIndCont)
		endif
		
	next ni
	
	RestArea(aAreaSD2)
	RestArea(aAreaSF2)
	RestArea(aAreaSE1)
	RestArea(aAreaSC5)
	RestArea(aAreaSC6)
	RestArea(aArea)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SF2460I   �Autor  �Microsiga           � Data �  09/08/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GravaDados(cNewEmp /*Empresa*/ , cNewFil /*Filial*/ ,;
						 cAlias /*Tabela*/ , aEstru /*Cabe�alho*/ ,;
						 aConteu /*Conteudo*/ , cMod /*Modulo*/ , nOpc /*1=Inclui, 2=Altera, 3=Exclui*/ ,;
						 nInd /*Indice*/, cIndCont /*conteudo da chave para busca*/)

	Local aArea := GetArea()
	Local bError
	Local lRet := .T.
	Private cErro
	
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,cMod)
	
	// se n�o tiver, ele vai tentar criar a tabela
	chkfile(cAlias)
	
	For nItens := 1 To Len(aConteu)
				
		If nOpc == 1
		
			RecLock(cAlias, .T.)
			
		ElseIf nOpc == 2
			
			//procura o registro
			dbSelectArea(cAlias) //seleciona a tabela
			dbSetOrder(nInd) //coloca no indice passado pela chamada
			
			If DBSEEK(cIndCont) //procura com a chave passada na chamada
				RecLock(cAlias, .F.)
			Else
				conout ('N�o encontrei o registro com chave = ' + cIndCont)
				return .f.
			End If
			
		End If 

		For nAtual := 1 To Len(aEstru)
			&(aEstru[nAtual][1]) := aConteu[nItens][nAtual]
		Next nAtual		
		
		(cAlias)->(MsUnlock())
		
		//se for exclus�o
		If nOpc == 3

			//procura o registro
			dbSelectArea(cAlias) //seleciona a tabela
			dbSetOrder(nInd) //coloca no indice passado pela chamada
			
			If DBSEEK(cIndCont) //procura com a chave passada na chamada
				RecLock(cAlias, .F.)
					dbDelete()
				(cAlias)->(MsUnlock())
			Else
				conout ('N�o encontrei o registro com chave = ' + cIndCont)
				return .f.
			End If
						
		End If 
		
	Next nItens
	
	RestArea(aArea)
	
	RpcClearEnv()

Return lRet