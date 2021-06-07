xcopy hp_dados.mdb hp_dados_COPIA.mdb /Y
xcopy hp_athcsm.mdb hp_athcsm_COPIA.mdb /Y
net use s: \\server2\wwwroot /user:administrador
xcopy hp_dados_COPIA.mdb S:\proevento\_database\hp_dados.mdb /Y
xcopy hp_athcsm_COPIA.mdb S:\proevento\_database\hp_athcsm.mdb /Y
net use s: /delete

