<%
Session.LCID = 1046

Sub CheckError
	Select Case Err.Number
		Case 3
			Response.Write " Return sem GoSub"
		Case 5
			Response.Write "Chamada de Procedimento Invбlida"
		Case 6
			Response.Write "Sobrecarga"
		Case 7
			Response.Write "Sem Memуria"
		Case 9
			Response.Write "SubScript fora de бrea"
		Case 10
			Response.Write "Este Array estб fixo ou temporariamente travado"
		Case 11
			Response.Write "Divisгo Por Zero"
		Case 13
			Response.Write "Tipos Incompatнveis"
		Case 14
			Response.Write "Fora de Espaзo de String"
		Case 16
			Response.Write "Expressгo muito Complexa"
		Case 17
			Response.Write "Nгo pode recuperar a operaзгo"
		Case 18
			Response.Write "Interrupзгo do usuбrio ocorrida"
		Case 20
			Response.Write "Resume Without Error"
		Case 28
			Response.Write "Fora de Espaзo de Pilha"
		Case 35
			Response.Write "Sub ou Function nгo Definida"
		Case 47
			Response.Write "Muitas DLL na aplicaзгo cliente"
		Case 48
			Response.Write "Erro carregando DLL"
		Case 49
			Response.Write "DLL com problemas de chamada"
		Case 51
			Response.Write "Erro Interno"
		Case 52
			Response.Write "Nome ou nъmero do arquivo errado"
		Case 53
			Response.Write "Arquivo nгo Encontrado"
		Case 54
			Response.Write "Modo de arquivo errado"
		Case 55
			Response.Write "Arquivo jб estб Aberto"
		Case 57
			Response.Write "Device I/O Error"
		Case 58
			Response.Write "Arquivo jй existente"
		Case 59
			Response.Write "Tamanho do registro errado"
		Case 61
			Response.Write "Disco Cheio"
		Case 62
			Response.Write "Entrada passa do final do arquivo"
		Case 63
			Response.Write "Nъmero de registros errados"
		Case 67
			Response.Write "Muitos arquivos"
		Case 68
			Response.Write "Ferramenta nгo disponнvel"
		Case 70
			Response.Write "Permissгo Negada"
		Case 71
			Response.Write "Disco nгo Preparado"
		Case 74
			Response.Write "Nгo posso renomear com discos diferentes"
		Case 75
			Response.Write "Caminho/Arquivos Erro de acesso"
		Case 76
			Response.Write "Caminho nгo encontrado"
		Case 91
			Response.Write "Variбvel de objeto nгo definida"
		Case 92
			Response.Write "Loop For nгo foi inicializado"
		Case 94
			Response.Write "Uso invбlido de Null"
		Case 322
			Response.Write "Nгo posso criar Arquivos temporбrios nescessбrios"
		Case 325
			Response.Write "Formato invбlido no arquivo"
		Case 380
			Response.Write "Valor da propriedade invбlida"
		Case 400
			Response.Write "ERRO HTTP 1.1 --- pedido ruim"
		Case 401.1
			Response.Write "ERRO HTTP 1.1 --- nгo autorizado: falha no logon"
		Case 401.2
			Response.Write "ERRO HTTP 1.1 --- nгo autorizado: falha no logon devido a configuraзгo do servidor"
		Case 401.3
			Response.Write "ERRO HTTP 1.1 --- nгo autorizado: nгo autorizado devido a ACL no recurso"
		Case 401.4
			Response.Write "ERRO HTTP 1.1 --- nгo autorizado: falha na autorizaзгo pelo filtro"
		Case 401.5
			Response.Write "ERRO HTTP 1.1 --- nгo autorizado: falha na autorizaзгo por ISAPI/CGI App"
		Case 403.1
			Response.Write "ERRO HTTP 1.1 --- proibido: acesso a execuзгo proibido"
		Case 403.2
			Response.Write "ERRO HTTP 1.1 --- proibido: acesso de leitura proibido"
		Case 403.3
			Response.Write "ERRO HTTP 1.1 --- proibido: acesso de escrever proibido"
		Case 403.4
			Response.Write "ERRO HTTP 1.1 --- proibido: requer SSL"
		Case 403.5
			Response.Write "ERRO HTTP 1.1 --- proibido: requer SSL 128"
		Case 403.6
			Response.Write "ERRO HTTP 1.1 --- proibido: endereзo de IP rejeitado"
		Case 403.7
			Response.Write "ERRO HTTP 1.1 --- proibido: requer certificaзгo do cliente"
		Case 403.8
			Response.Write "ERRO HTTP 1.1 --- proibido: acesso ao site negado"
		Case 403.9
			Response.Write "ERRO HTTP 1.1 --- acesso proibido: Muitos usuбrios estгo conectados"
		Case 403.10
			Response.Write "ERRO HTTP 1.1 --- acesso proibido: configuraзгo invбlida"
		Case 403.11
			Response.Write "ERRO HTTP 1.1 --- acesso proibido: senha alterada"
		Case 403.12
			Response.Write "ERRO HTTP 1.1 --- acesso proibido: negado acesso ao mapa"
		Case 404
			Response.Write "ERRO HTTP 1.1 --- nгo encontrado"
		Case 405
			Response.Write "ERRO HTTP 1.1 --- mйtodo nгo permitido"
		Case 406
			Response.Write "ERRO HTTP 1.1 --- nгo aceitбvel"
		Case 407
			Response.Write "ERRO HTTP 1.1 --- requer autenticaзгo do Proxy"
		Case 412
			Response.Write "ERRO HTTP 1.1 --- falha em prй condiзхes"
		Case 414
			Response.Write "ERRO HTTP 1.1 --- pedido - URI muito grande"
		Case 423
			Response.Write "Propriedade ou metodo nгo encontrado"
		Case 424
			Response.Write "Objeto Requerido"
		Case 429
			Response.Write "OLE Automation nгo pode ser criado no servidor"
		Case 430
			Response.Write "Classe nгo suportada pelo OLE Automation"
		Case 432
			Response.Write "Nome do arquivo ou de classe nх encontrado durante a operaзгo OLE Automation"
		Case 438
			Response.Write "Objeto nгo suporta esta propriedade ou mйtodo"
		Case 440
			Response.Write "Erro na OLE Automation"
		Case 442
			Response.Write "Connection to type library or object library for remote process has been lost. Press OK for dialog to remove reference"
		Case 443
			Response.Write "Objeto OLE Automation nгo contйm um valor padrгo"
		Case 445
			Response.Write "Objeto nгo suporta esta aзгo"
		Case 446
			Response.Write "Objeto nгo suporta o nome do argumento"
		Case 447
			Response.Write "Objeto nгo suporta a definiзгo do local atual"
		Case 448
			Response.Write "Nome de argumentos nгo encontrados"
		Case 449
			Response.Write "Este argumento nгo й opcional"
		Case 450
			Response.Write "Nъmero de argumentos errado ou definiзгo de propriedade invбlida"
		Case 451
			Response.Write "Objeto nгo й uma coleзгo"
		Case 452
   			Response.Write "Nъmero ordinal invбlido"
		Case 453
			Response.Write "Funзгo DLL especificada nгo foi encontrada"
		Case 454
			Response.Write "cуdigo de origem nгo encontrado"
		Case 455
			Response.Write "Erro de trava no cуdigo"
		Case 457
			Response.Write "Esta chave jб estб associada a um elemento desta coleзгo"
		Case 458
			Response.Write "Tipos de variбveis usadas na OLE Automation nгo sгo suportadas pelo Visual Basic"
		Case 462
			Response.Write "A mбquina do servidor remoto nгo existe ou nгo estб disponнvel"
		Case 481
			Response.Write "Figura Invбlida"
		Case 500
			Response.Write "Variбvel nгo definida"
		Case 501
			Response.Write "Variбvel nгo pode ser atribuнda"
		Case 502
			Response.Write "Objeto nгo й seguro para script"
		Case 503
			Response.Write "Objeto nгo й seguro para inicializaзгo"
		Case 504
			Response.Write "Objeto nгo й seguro para criaзгo"
		Case 505
			Response.Write "Referкncia invбlida ou nгo qualificada"
		Case 506
			Response.Write "Classe nгo definida"
		Case 1001
			Response.Write "Sem memуria"
		Case 1002
			Response.Write "Erro de Sintaxe"
		Case 1003
			Response.Write "Esperado ':'"
		Case 1004
			Response.Write "Esperado ';'"
		Case 1005
			Response.Write "Esperado '('"
		Case 1006
			Response.Write "Esperado ')'"
		Case 1007
			Response.Write "Esperado ']'"
		Case 1008
			Response.Write "Esperado '{'"
		Case 1009
			Response.Write "Esperado '}'"
		Case 1010
			Response.Write "Esperado Identificador"
		Case 1011
			Response.Write "Esperado '='"
		Case 1012
			Response.Write "Esperado 'If'"
		Case 1013
			Response.Write "Esperado 'To'"
		Case 1014
			Response.Write "Esperado 'End'"
		Case 1015
			Response.Write "Esperado 'Function'"
		Case 1016
			Response.Write "Esperado 'Sub'"
		Case 1017
			Response.Write "Esperado 'Then'"
		Case 1018
			Response.Write "Esperado 'Wend'"
		Case 1019
			Response.Write "Esperado 'Loop'"
		Case 1020
			Response.Write "Esperado 'Next'"
		Case 1021
			Response.Write "Esperado 'Case'"
		Case 1022
			Response.Write "Esperado 'Select'"
		Case 1023
			Response.Write "Esperado expressгo"
		Case 1024
			Response.Write "Esperado declaraзгo"
		Case 1025
			Response.Write "Esperado final da declaraзгo"
		Case 1026
			Response.Write "Esperado inteiro constante"
		Case 1027
			Response.Write "Esperado 'While' , 'Until'"
		Case 1028
			Response.Write "Esperado 'While' , 'Until' ou final de declaraзгo"
		Case 1029
			Response.Write "Esperado 'With'"
		Case 1030
			Response.Write "Identificador Muito Longo"
		Case 1031
			Response.Write "Nъmero Invбlido"
		Case 1032
			Response.Write "Caracter Invбlido"
		Case 1033
			Response.Write "Constante de String nгo Terminada"
		Case 1034
			Response.Write "Comentбrio nгo Terminado"
		Case 1035
			Response.Write "Nested Comment"
		Case 1036
			Response.Write "'Me' nгo pode ser usado como saнda de rotina"
		Case 1037
			Response.Write "Uso Invбlido da Palavra Chave 'Me'"
		Case 1038
			Response.Write "'Loop' sem 'Do'"
		Case 1039
			Response.Write "Declaraзгo 'Exit' Invбlida"
		Case 1040
			Response.Write "Variбvel de Controle de Loop 'for' Invбlida"
		Case 1041
			Response.Write "Variбvel Redefinida"
		Case 1042
			Response.Write "Tem que ser a primeira declaraзгo da linha"
		Case 1043
			Response.Write "Nгo pode atribuir non-By Val para um argumento"
		Case 1044
			Response.Write "Nгo pode usar parкntesis para chamar uma sub"
		Case 1045
			Response.Write "Esperada Constante Literal"
		Case 1046
			Response.Write "Esperado 'In'"
		Case 1047
			Response.Write "Esperado 'Class'"
		Case 1048
			Response.Write "Tem que ser definido dentro de uma Classe"
		Case 1049
			Response.Write "Esperado Let ou Set ou Get na declaraзгo de propriedade"
		Case 1050
			Response.Write "Esperado 'Property'"
		Case 1051
			Response.Write "Nъmero de argumentos tem que ser consistente em especificaзхes de propriedades"
		Case 1052
			Response.Write "Nгo pode haver mйtodo/ propriedade padrгo mъltiplo em uma Classe"
		Case 1053
			Response.Write "Class initialize ou terminate nгo tem argumentos"
		Case 1054
			Response.Write "Propriedade Set ou Let tem que ter pelo menos um argumento"
		Case 1055
			Response.Write "'Next' inesperado"
		Case 1056
			Response.Write "'Default' pode ser especificado somente em 'Property' ou 'Function' ou 'Sub'"
		Case 1057
			Response.Write "Especificaзгo 'Default' precisa especificar tambйm 'Public'"
		Case 1058
			Response.Write "Especificaзгo 'Default' sу pode estar em Property Get"

		Case 3000
			Response.Write "O provedor nгo concluiu a aзгo pedida"
		Case 3001
			Response.Write "A aplicaзгo estб usando argumentos do tipo errado, estгo fora do вmbito aceitбvel ou em conflito com alguma outra aplicaзгo"
		Case 3002
			Response.Write "Ocorreu um erro durante a abertura do arquivo pedido"
		Case 3003
			Response.Write "Erro na leitura do arquivo especificado"
		Case 3004
			Response.Write "Erro ao escrever no arquivo"
		Case 3021
			Response.Write "BOF ou EOF й True ou o registro atual foi deletado. A operaзгo pedido pela aplicaзгo requer um registro atual"
		Case 3219
			Response.Write "A operaзгo pedida pela aplicaзгo nгo й permitida neste contexto"
		Case 3246
			Response.Write "A aplicaзгo nгo pode fechar explicitamente um objeto connection no meio de uma transaзгo"
		Case 3251
			Response.Write "O provedor nгo oferece suporte a operaзгo pedida pela aplicaзгo"
		Case 3265
			Response.Write "ADO nгo pode achar o objeto na coleзгo"
		Case 3367
			Response.Write "Nгo й anexar, objeto jб estб na coleзгo"
		Case 3420
			Response.Write "O objeto referenciado pela aplicaзгo nгo aponta mais para um objeto vбlido"
		Case 3421
			Response.Write "A aplicaзгo estб usando um valor do tipo errado para a aplicaзгo atual"
		Case 3704
			Response.Write "A operaзгo pedida pela aplicaзгo nгo й permitida se o objeto estiver fechado"
		Case 3705
			Response.Write "A operaзгo pedida pela aplicaзгo nгo й permitida se o objeto estiver aberto"
		Case 3706
			Response.Write "ADO nгo pode achar o provedor especificado"
		Case 3707
			Response.Write "A aplicaзгo nгo pode alterar a propriedade ActiveConnect de um objeto Recordset com um objeto Command como fonte"
		Case 3708
			Response.Write "A aplicaзгo definiu de modo imprуprio um objeto Parameter"
		Case 3709
			Response.Write "A aplicaзгo pediu uma operaзгo em um objeto com uma referкncia a um objeto Connection invбlido ou fechado"
		Case 3710
			Response.Write "A operaзгo nгo й reentrante"
		Case 3711
			Response.Write "A operaзгo ainda estб executando"
		Case 3712
			Response.Write "Operaзгo cancelada"
		Case 3713
			Response.Write "A operaзгo ainda estб conectando"
		Case 3714
			Response.Write "A transaзгo й invбlida"
		Case 3715
			Response.Write "A operaзгo nгo estб sendo executada"
		Case 3716
			Response.Write "A operaзгo nгo й segura sob estas circunstвncias"
		Case 3717
			Response.Write "A operaзгo fez com que aparecesse uma caixa de diбlogo"
		Case 3718
			Response.Write "A operaзгo fez com que aparecesse um cabeзalho de caixa de diбlogo"
		Case 3719
			Response.Write "A aзгo falhou devido a uma violaзгo na integridade dos dados"
		Case 3720
			Response.Write "O provedor nгo pode ser modificado"
		Case 3721
			Response.Write "Dados longos demais para o tipo de dados apresentados"
		Case 3722
			Response.Write "Aзгo causou uma violaзгo do esquema"
		Case 3723
			Response.Write "A expressгo continha sinais nгo coincidentes"
		Case 3724
			Response.Write "O valor nгo pode ser convertido"
		Case 3725
			Response.Write "O recurso nгo pode ser criado"
		Case 3726
			Response.Write "A coluna especificada nгo existe nesta fileira"
		Case 3727
			Response.Write "O URL nгo existe"
		Case 3728
			Response.Write "Vocк nгo tem permissгo para ver a бrvore do diretуrio"
		Case 3729
			Response.Write "O URL apresentado й invбlido"
		Case 3730
			Response.Write "Recurso travado"
		Case 3731
			Response.Write "Recurso jб existente"
		Case 3732
			Response.Write "A aзгo nгo pode ser concluнda"
		Case 3733
			Response.Write "O volume de arquivo nгo foi encontrado"
		Case 3734
			Response.Write "Falha na operaзгo porque o servidor nгo pode obter espaзo suficiente para completar a operaзгo"
		Case 3735
			Response.Write "Recurso fora de вmbito"
		Case 3736
			Response.Write "Comando nгo estб disponнvel"
		Case 3737
			Response.Write "O URL na fileira identificada nгo existe"
		Case 3738
			Response.Write "O recurso nгo pode ser deletado porque estб fora do escopo permitido"
		Case 3739
			Response.Write "Esta propriedade й invбlida para a coluna selecionada"
		Case 3740
			Response.Write "Vocк apresentou uma opзгo invбlida para esta propriedade"
		Case 3741
			Response.Write "Vocк apresentou um valor invбlido para esta propriedade"
		Case 3742
			Response.Write "A definiзгo desta propriedade causou um conflito com outras propriedades"
		Case 3743
			Response.Write "Nem todas as propriedades podem ser definidas"
		Case 3744
			Response.Write "A propriedade nгo foi definida"
		Case 3745
			Response.Write "A propriedade nгo pode ser definida"
		Case 3746
			Response.Write "A propriedade nгo tem suporte"
		Case 3747
			Response.Write "A aзгo nгo pode ser concluнda porque o catбlogo nгo estб definido"
		Case 3748
			Response.Write "A conexгo nгo pode ser alterada"
		Case 3749
			Response.Write "O mйtodo Update da coleзгo Fields falhou"
		Case 3750
			Response.Write "Nгo й possнvel definir permissгo Deny porque o provedor nгo oferece suporte para tanto"
		Case 3751
		Response.Write "o provedor nгo oferece suporte ao tipo de pedido"
 End Select
End Sub

On Error Resume Next

IF Err > 0 Then Call CheckError
%>