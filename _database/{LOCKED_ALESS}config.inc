<%
Dim CFG_DB_DADOS, CFG_PATH, CFG_IDEMPRESA, CFG_IDCLIENTE
Dim CFG_DB_CATRACA_ANO2, CFG_DB_CATRACA_ANO3, CFG_FLAG_EXPORT_DATA, CFG_FLAG_INSCRICAO
Dim CFG_EMAIL_AUDITORIA_CLIENTE, CFG_EMAIL_AUDITORIA_PROEVENTO
Dim CFG_NUMLOJA_SCOPUS, CFG_PRINT_ONDEMAND, CFG_DB_DADOS_PWD, CFG_DB_DADOS_USER

Dim CFG_FLAG_EXIBE_PF, CFG_FLAG_EXIBE_PJ

'SERVIDOR LOCAL - THE_URANO: 
   CFG_DB_DADOS_PWD		= "athroute66"	
   CFG_DB_DADOS_USER	= "root"	
   CFG_DB_DADOS 	 	= "METRO_dados"	'BANCO DE DADOS
   CFG_PATH         	= "localhost"  	'Caminho de diretorio do Cliente

'SERVIDOR ONLINE: 
  'CFG_DB_DADOS_PWD		= "(AT5*hBB*5si)"
  'CFG_DB_DADOS_USER	= "sysMetro"	  
  'CFG_DB_DADOS 	 	= "qe_dados"	'BANCO DE DADOS
  'CFG_PATH         	= "localhost"  	'Caminho de diretorio do Cliente


CFG_IDEMPRESA    	= "pvista"              'ID da empresa MATRIZ: CM-COUROMODA SP-SAO PAULO HP-HOSPITALAR
CFG_IDCLIENTE    	= "pvista"
CFG_NUMLOJA_SCOPUS = ""

CFG_EMAIL_AUDITORIA_CLIENTE = ""
CFG_EMAIL_AUDITORIA_PROEVENTO = "auditormaster@gmail.com"


CFG_FLAG_EXIBE_PF = True                 'Flag para exibir pessoa fнsica
CFG_FLAG_EXIBE_PJ = True                 'Flag para exibir pessoa jurнdica

CFG_FLAG_EXPORT_DATA = false             'Flag para permitir a exportaзгo de dados para o portal Couronet
CFG_FLAG_INSCRICAO = True                'Flag para exibir/permitir a inscriзгo em palestras/cursos

CFG_PRINT_ONDEMAND   = True   'Flag para controlar a exibiзгo da janela/dialog de impressгo nas credenciais

'Variбveis de definiзгo de ambiente (no futuro poderгo ir para BD ou mesmo CSS)
Dim CFG_NUM_PER_PAGE, CFG_VERSION, CFG_WINDOW 
Dim CFG_CORBAR_TOP, CFG_CORBAR_MIDDLE_A, CFG_CORBAR_MIDDLE_B, CFG_CORBG_FILTRO
  
CFG_WINDOW          = "POPUP"   'Dialogs: "POPUP" OU "NORMAL"
CFG_NUM_PER_PAGE    = 25        'Nъm. Default de нtens por pбgina	  

CFG_VERSION         = "2007.0.0"   'Versao atual do SISTEMA
CFG_CORBAR_TOP      = "#7DACC5"
CFG_CORBAR_MIDDLE_A = "#FFFFFF"
CFG_CORBAR_MIDDLE_B = "#E9E9F9"
CFG_CORBG_FILTRO    = "#7DACC5"


Dim CFG_SIZE_LABEL_NOME, CFG_MAXLEN_LABEL_NOME
Dim CFG_SIZE_LABEL_EMPRESA, CFG_MAXLEN_LABEL_EMPRESA

CFG_SIZE_LABEL_NOME = 5
CFG_MAXLEN_LABEL_NOME = 40
CFG_SIZE_LABEL_EMPRESA = 4
CFG_MAXLEN_LABEL_EMPRESA = 25

Dim CFG_PATH_VISA

CFG_PATH_VISA = "c:\Inetpub\wwwroot\componentes_vbv\"
%>