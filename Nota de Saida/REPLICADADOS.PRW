//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#include "fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REPLICADADOSºAutor  ³xxxxxx              º Data ³  XX/XX/XX º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                            º±±
±±º          ³ XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ XX                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
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
User Function REPLICADADOS(cMod /*Módulo*/, aTabelas /*Tabela*/, nOpc /*1=Inclui, 2=Altera, 3=Exclui*/ ,;
nInd /*Indice*/, cIndCont /*conteudo da chave para busca*/,cIndChave/*Chave do indice*/)

Local aArea		:= GetArea()
Local aEstCab	:= {}
Local aContCab	:= {}
Local aEstGet	:= {}
Local aContGet	:= {}
Local cNewAlias	:= ""
Local cAlias	:= ""
//Local aTabelas	:= aTabelas 
Local cquery := ""

if nOpc == 1
//	cquery := "DELETE FROM SC5020; "
//	cquery += "DELETE FROM SC6020; "
//	cquery += "DELETE FROM SF2020; "
//	cquery += "DELETE FROM SD2020; "
//	cquery += "DELETE FROM SF3020; "
//	cquery += "DELETE FROM SE1020; "
//	cquery += "DELETE FROM SFT020; "
//	cquery += "DELETE FROM CD2020; "
//	cquery += "DELETE FROM SC9020; "
	cquery += "DELETE FROM SF1020; "
	cquery += "DELETE FROM SD1020; "
	cquery += "DELETE FROM SE2020; "
	nStatus := TCSqlExec(cquery)
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
		IncProc("Adicionando valores "+cAlias+" ("+cValToChar(nAtual)+" de "+cValToChar(Len(aEstCab))+")...")
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
					IncProc("Adicionando valores "+cNewAlias+" ("+cValToChar(nAtual)+" de "+cValToChar(Len(aEstGet))+")...")
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
					IncProc("Adicionando valores "+cNewAlias+" ("+cValToChar(nAtual)+" de "+cValToChar(Len(aEstGet))+")...")
					aAdd(aContGet[nItens], &(cNewAlias+"->"+aEstGet[nAtual][1]))
				Next nAtual
				nItens++
				(cNewAlias)->(DbSkip())
			EndDo
		EndIf
		
	elseif (cAlias == "SF1")
		
		cNewAlias := "SD1"
		
		DbSelectArea(cNewAlias)
		DbSetOrder(1)
		If DbSeek(xFilial(cNewAlias)+ SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)
			
			aEstGet := (cNewAlias)->(DbStruct())
			nItens := 1
			While (!Eof(cNewAlias)) .And. (xFilial(cAlias) == xFilial(cNewAlias)) .and. SF1->F1_DOC = (cNewAlias)->D1_DOC .and. ;
				SF1->F1_SERIE = (cNewAlias)->D1_SERIE .and. SF1->F1_FORNECE = (cNewAlias)->D1_FORNECE .and. SF1->F1_LOJA = (cNewAlias)->D1_LOJA
				
				ProcRegua(Len(aEstGet))
				aAdd(aContGet,{})
				For nAtual := 1 To Len(aEstGet)
					IncProc("Adicionando valores "+cNewAlias+" ("+cValToChar(nAtual)+" de "+cValToChar(Len(aEstGet))+")...")
					aAdd(aContGet[nItens], &(cNewAlias+"->"+aEstGet[nAtual][1]))
				Next nAtual
				nItens++
				(cNewAlias)->(DbSkip())
			EndDo
		EndIf		
	endIf
	
	StartJob("U_GravaDados",GetEnvServer(), .F.,"02", "01",cAlias,aEstCab,aContCab,cMod,nOpc,nInd,cIndCont,cIndChave)
	
	if(cAlias$"SC5*SF2*SF1")
		StartJob("U_GravaDados",GetEnvServer(), .F.,"02", "01",cNewAlias,aEstGet,aContGet,cMod,nOpc,nInd,cIndCont,cIndChave)
	endif
	
next ni

RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2460I   ºAutor  ³Microsiga           º Data ³  09/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GravaDados(cNewEmp /*Empresa*/ , cNewFil /*Filial*/ ,;
cAlias /*Tabela*/ , aEstru /*Cabeçalho*/ ,;
aConteu /*Conteudo*/ , cMod /*Modulo*/ , nOpc /*1=Inclui, 2=Altera, 3=Exclui*/ ,;
nInd /*Indice*/, cIndCont /*conteudo da chave para busca*/,cIndChave/*Chave do indice*/)

Local aArea := GetArea()
Local bError
Local lRet := .T.
Private cErro

RpcSetType( 3 )
RpcSetEnv( cNewEmp, cNewFil,,,cMod)

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
			conout ('Não encontrei no Alias '+cAlias+' registro com chave = ' + cIndCont)
			return .f.
		End If
		
	End If
	
	For nAtual := 1 To Len(aEstru)
		&(aEstru[nAtual][1]) := aConteu[nItens][nAtual]
	Next nAtual
	
	(cAlias)->(MsUnlock())
	
	//se for exclusão
	If nOpc == 3
		
		//procura o registro
		dbSelectArea(cAlias) //seleciona a tabela
		dbSetOrder(nInd) //coloca no indice passado pela chamada
		
		If DBSEEK(cIndCont) //procura com a chave passada na chamada
			While (!Eof(cAlias) .And. &(cIndChave) == cIndCont)
				RecLock(cAlias, .F.)
				dbDelete()
				(cAlias)->(MsUnlock())
				(cAlias)->(DbSkip())
				conout ('Encontrei no Alias '+cAlias+' o registro com chave '+cIndChave+' = ' + cIndCont)
			EndDo
		Else
			cQuery = "UPDATE "+RetSqlName(cAlias)+ " SET D_E_L_E_T_ = '*' WHERE "+cIndChave+" = '"+cIndCont+"'"
			nStatus := TCSqlExec(cquery)
			if (nStatus < 0)
				conout(cquery)
				conout ('Nao encontrei no Alias '+cAlias+' o registro com chave '+cIndChave+' = ' + cIndCont)
				conout("TCSQLError() " + TCSQLError())
			else
				conout ('Encontrei no Alias '+cAlias+' o registro com chave'+cIndChave+' = ' + cIndCont)
				return .F.
			endif
		End If
		
	End If
	
Next nItens

RestArea(aArea)

RpcClearEnv()

Return lRet