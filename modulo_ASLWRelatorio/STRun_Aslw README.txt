----------------------------------------------------------------------------------------
Sobre Relat�rios Est�ticos:
----------------------------------------------------------------------------------------
Relat�rio eST�ticos devem ter essa nomeclatura: STRun_[nome do relat�rio].php
- Devem ser colocado no relat�rio diretametne como o executor do mesmo
- Devem ser contru�dos a partir da aslRun_Default.php mantendo funcionalidades de exporta��o,
  controle de sessao (se tem user logado), grava��o de log, etc...
  (basta manter os includes especiais estrutura geral da aslRun_Default.php)

A necessidade de cria��o deles vem do formato de impress�o que seja necess�rio. Lembrando 
que classificamso nossos relat�rios, ou melhor dizendo, nossas impress�es da segunte forma: 

- LISTAGENS...: grade com listagem dos dados em si - ASL com par�metros, modificadores
			    cabe�alho e rodap�, consegue atender bem.

- RELATPTIOS..: a sa�da/impress�o peculiaridades, ou agrupadores que n�o podem ser 
				atendidos da forma listagem. 

- DOUMENTOS...: contratos, certid�es, certificados e impress�es altamente espec�fica
				onde o layout requer um maior controle visual.
----------------------------------------------------------------------------------------
* Aten��o para a padroniza��o do nome dos "runners" est�ticos de relat�rios 

  STRun_[nome do relat�rio].php

----------------------------------------------------------------------------------------
