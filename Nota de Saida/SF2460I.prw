//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#include "fileio.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SF2460I   �Autor  �Microsiga           � Data �  09/08/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para copiar as tabela SC5/SC6, SF2/SD2     ���
���          �e demais tabelas relacionas a Nota de Saida                 ���
�������������������������������������������������������������������������͹��
���Uso       � DC                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SF2460I

Local aTabelas	:= {"SC5","SF2","SF3","SE1","SFT","CD2","SC9"}
U_REPLICADADOS('FAT',aTabelas,1)

Return Nil