@Echo off
chcp 65001

:menu
color 7

:: redefine a opção "choice"
set choice= 
cls
Echo               Menu de Opções
Echo =============================================
Echo * 1. Adicionar sites na Área de trabalho    *
Echo * 2. Liberar Permissões                     *
Echo * 3. Colocar todos os ".Exe" como Admin     *
Echo * 4. Manutenção e Registro Midas.Dll        *
Echo * 5. Otimizar banco de dados (Servidor)     *
Echo * 6. Reinicia o postgres com ResextLog      *
Echo * 7. Reinstalar UpdaterManager              *
Echo * 8. Manutenção no Spooler de Impressão     *
Echo * 9. Finalizar                             *
Echo *     Digite "ajuda" para mais detalhes     *
Echo =============================================
Echo.
Echo ======  OBS: NÃO FUNCIONA NO WINDOWS 7 ======
Echo ==============   VERSÃO 1.6   ===============
Echo.


::--------------------------------INFORMAÇÕES SOBRE A VERSÃO-----------------------------------

::Ajuste no código de reinstalar o updaterManager
::Removido a opção de remover certificados digitais devido não ser usado.

::---------------------------------------------------------------------------------------------




set /p choice=Escolha uma opção: 

if "%choice%"=="9" goto end
if "%choice%"=="ajuda" goto ajuda

:: filtra se a opção escolhida é uma das 4 ou não
if not "%choice%"=="" set choice=%choice:~0,10%
if "%choice%"=="1" goto adiciona_sites
if "%choice%"=="2" goto Permissoes
if "%choice%"=="3" goto Exe_como_adm
if "%choice%"=="4" goto Registra_Midas
if "%choice%"=="5" goto otimiza_banco
if "%choice%"=="6" goto reiniciaPostgres
if "%choice%"=="7" goto ReinstalaUpdater
if "%choice%"=="8" goto SpoolImpressao


:: Caso não seja uma opção válida, ele repete a pergunta.
cls
Echo "%choice%" não é uma opção válida, tente novamente.
Echo.
goto menu
:: --------------------------------------------------------------------------------------------------------------

:ajuda
Echo ------------------------------------------------------------------------------------------------------------------------
Echo.
Echo Opção 1: Adiciona os sites ajuda SHOP, suporte via karoo e suporte remoto. Todos vão para a Área de Trabalho do         computador.
Echo.
Echo ------------------------------------------------------------------------------------------------------------------------
Echo.
Echo Opção 2: Libera as permissões nas portas TCP e UDP Firewall, pastas do gerenciador de banco de dados, pastas do sistema alterdata, permissão firewall dos executaveis da Alterdata, adiciona links nos sites confiáveis e ajusta o fuso horário do computador.
Echo.
Echo ------------------------------------------------------------------------------------------------------------------------
Echo.
Echo Opção 3: Faz com que todos Executáveis da alterdata fiquem para abrir como administrador.
Echo.
Echo ------------------------------------------------------------------------------------------------------------------------
Echo.
Echo Opção 4: Verifica se o Windows é 32 ou 64 bits. Depois faz o Registro da Midas.DLL.
Echo.
Echo ------------------------------------------------------------------------------------------------------------------------
Echo.
Echo Opção 5: Permite fazer otimização do banco de dados Postgres, perguntando quais informações deseja colocar e fazendo    um backup de segurança do arquivo Postgresql.conf.
Echo.
Echo ------------------------------------------------------------------------------------------------------------------------
Echo.
Echo Opção 6: Força a reinicialização do Postgres, apagando o arquivo postmaster.pid e rodando um resetxLog.
Echo.
Echo ------------------------------------------------------------------------------------------------------------------------
Echo.
Echo Opção 7: Desinstala o UpdaterManager da máquina do cliente e automaticamente já baixa o arquivo e executa para ser      reinstalado.
Echo.
Echo ------------------------------------------------------------------------------------------------------------------------
Echo.
Echo Opção 8: Reinicia o Spooler de impressão e apagar os arquivos temporários da pasta System32\spool\PRINTERS\
Echo.
Echo ------------------------------------------------------------------------------------------------------------------------


pause
cls
goto reinicio




:: --------------------------------------------------------------------------------------------------------------








:: Tem a opção de ir para o menu principal ou sair do programa.
:reinicio
color B
set opcao=
Echo Digite 'menu' para voltar ao menu e escolher uma nova opção
Echo Digite 'sair' para fechar.
Echo.
set /p opcao=Digite aqui: 

if "%opcao%"=="menu" goto menu
if "%opcao%"=="sair" goto end
cls
Echo Opção inválida, digite novamente.
Echo.
goto reinicio



:: --------------------------------------------------------------------------------------------------------------






:: Adicionar os sites do Ajuda SHOP, karoo e remoto na Área de trabalho

:adiciona_sites
:: Caminho pra Área de trabalho
if exist %UserProfile%\Desktop"  (
    set "area_trabalho=%UserProfile%\Desktop"
)   else (
        if exist "%UserProfile%\Área de Trabalho" (
            set "area_trabalho=%UserProfile%\Área de Trabalho"
        )   else (
                if exist %UserProfile%\Onedrive\Desktop  (
                    set "area_trabalho=%UserProfile%\Onedrive\Desktop"
                )   else (
                        if exist "%UserProfile%\Onedrive\Área de Trabalho" (
                            set "area_trabalho=%UserProfile%\Onedrive\Área de Trabalho"

                        )   else (
                                cls
                                Echo Não foi possível encontrar a área de trabalho. Certifique-se de que a pasta Desktop existe.
                                pause
                                cls
                                goto reinicio
                            )


                    )
            )
    )


:: ----------------------------LINKS------------------------------

:: Link do ajuda
set "ajuda=https://ajuda.alterdata.com.br/shopprincipal"
set "Nome_atalho_Ajuda=Ajuda Alterdata"

:: Link do Karoo
set "karoo=https://widget.karoo.com.br/c/275"
set "Nome_atalho_karoo=Suporte via Chat"

:: Link do Suporte remoto
set "remoto=https://cliente.alterdata.com.br/pg/remoto/suporte-remoto"
set "Nome_atalho_remoto=Acesso remoto Alterdata"

:: ------------------------Cria os atalhos------------------------

:: Ajuda SHOP
Echo [InternetShortcut] > "%area_trabalho%\%Nome_atalho_Ajuda%.url"
Echo URL=%ajuda% >> "%area_trabalho%\%Nome_atalho_Ajuda%.url"

::  Karoo
Echo [InternetShortcut] > "%area_trabalho%\%Nome_atalho_karoo%.url"
Echo URL=%karoo% >> "%area_trabalho%\%Nome_atalho_karoo%.url"

:: :remoto
Echo [InternetShortcut] > "%area_trabalho%\%Nome_atalho_remoto%.url"
Echo URL=%remoto% >> "%area_trabalho%\%Nome_atalho_remoto%.url"

Echo Atalhos criados com sucesso na área de trabalho.
timeout /t 4
cls
goto reinicio






:: --------------------------------------------------------------------------------------------------------------












:: Libera as permissões nas portas TCP e UDP Firewall, pastas do gerenciador de banco de dados
:: Pastas do sistema alterdata, permissão firewall dos executaveis da Alterdata
:: Adiciona links nos sites confiáveis e ajusta o fuso horário do computador

:Permissoes
cls

color 2
@Echo
@Echo Liberando permissoes de firewall para portas usadas pelo sistema:
Echo off
netsh advfirewall set currentprofile state on
Echo. Liberando as Portas Utilizadas pelo Sistema no Firewall
@Echo Postgre TCP 5432
Echo off
netsh advfirewall firewall add rule name="Postgre TCP" dir=in action=allow protocol=TCP localport=5432
netsh advfirewall firewall add rule name="Postgre TCP" dir=out action=allow protocol=TCP localport=5432
@Echo Postgre UDP 5432
Echo off
netsh advfirewall firewall add rule name="Postgre UDP" dir=in action=allow protocol=UDP localport=5432
netsh advfirewall firewall add rule name="Postgre UDP" dir=out action=allow protocol=UDP localport=5432
@Echo Porta TCP 80
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 80" dir=in action=allow protocol=TCP localport=80
netsh advfirewall firewall add rule name="Alterdata Porta 80" dir=out action=allow protocol=TCP localport=80
@Echo Porta UDP 80
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 80" dir=in action=allow protocol=UDP localport=80
netsh advfirewall firewall add rule name="Alterdata Porta 80" dir=out action=allow protocol=UDP localport=80
@Echo Porta TCP 1433
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 1433" dir=in action=allow protocol=TCP localport=1433
netsh advfirewall firewall add rule name="Alterdata Porta 1433" dir=out action=allow protocol=TCP localport=1433
@Echo Porta UDP 1433
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 1433" dir=in action=allow protocol=UDP localport=1433
netsh advfirewall firewall add rule name="Alterdata Porta 1433" dir=out action=allow protocol=UDP localport=1433
@Echo Porta TCP 8081
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 8081" dir=in action=allow protocol=TCP localport=8081
netsh advfirewall firewall add rule name="Alterdata Porta 8081" dir=out action=allow protocol=TCP localport=8081
@Echo Porta UDP 8081
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 8081" dir=in action=allow protocol=UDP localport=8081
netsh advfirewall firewall add rule name="Alterdata Porta 8081" dir=out action=allow protocol=UDP localport=8081
@Echo Porta TCP 8080
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 8080" dir=in action=allow protocol=TCP localport=8080
netsh advfirewall firewall add rule name="Alterdata Porta 8080" dir=out action=allow protocol=TCP localport=8080
@Echo Porta UDP 8081
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 8080" dir=in action=allow protocol=UDP localport=8080
netsh advfirewall firewall add rule name="Alterdata Porta 8080" dir=out action=allow protocol=UDP localport=8080
@Echo Porta TCP 3128 
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 3128" dir=in action=allow protocol=TCP localport=3128
netsh advfirewall firewall add rule name="Alterdata Porta 3128" dir=out action=allow protocol=TCP localport=3128
@Echo Porta UDP 3128
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 3128" dir=in action=allow protocol=UDP localport=3128
netsh advfirewall firewall add rule name="Alterdata Porta 3128" dir=out action=allow protocol=UDP localport=3128
@Echo Porta TCP 5484
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 5484" dir=in action=allow protocol=TCP localport=5484
netsh advfirewall firewall add rule name="Alterdata Porta 5484" dir=out action=allow protocol=TCP localport=5484
@Echo Porta UDP 5484
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 5484" dir=in action=allow protocol=UDP localport=5484
netsh advfirewall firewall add rule name="Alterdata Porta 5484" dir=out action=allow protocol=UDP localport=5484
@Echo Porta TCP 13000
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 13000" dir=in action=allow protocol=TCP localport=13000
netsh advfirewall firewall add rule name="Alterdata Porta 13000" dir=out action=allow protocol=TCP localport=13000
@Echo Porta UDP 13000
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 13000" dir=in action=allow protocol=UDP localport=13000
netsh advfirewall firewall add rule name="Alterdata Porta 13000" dir=out action=allow protocol=UDP localport=13000
@Echo Porta TCP 49169
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 49169" dir=in action=allow protocol=TCP localport=49169
netsh advfirewall firewall add rule name="Alterdata Porta 49169" dir=out action=allow protocol=TCP localport=49169
@Echo Porta UDP 49169
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 49169" dir=in action=allow protocol=UDP localport=49169
netsh advfirewall firewall add rule name="Alterdata Porta 49169" dir=out action=allow protocol=UDP localport=49169
@Echo Porta TCP 443
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 443" dir=in action=allow protocol=TCP localport=443
netsh advfirewall firewall add rule name="Alterdata Porta 443" dir=out action=allow protocol=TCP localport=443
@Echo Porta UDP 443
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 443" dir=in action=allow protocol=UDP localport=443
netsh advfirewall firewall add rule name="Alterdata Porta 443" dir=out action=allow protocol=UDP localport=443
@Echo Porta TCP 8768
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 8768" dir=in action=allow protocol=TCP localport=8768
netsh advfirewall firewall add rule name="Alterdata Porta 8768" dir=out action=allow protocol=TCP localport=8768
@Echo Porta UDP 8768
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 8768" dir=in action=allow protocol=UDP localport=8768
netsh advfirewall firewall add rule name="Alterdata Porta 8768" dir=out action=allow protocol=UDP localport=8768
@Echo Porta TCP 8766
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 8766" dir=in action=allow protocol=TCP localport=8766
netsh advfirewall firewall add rule name="Alterdata Porta 8766" dir=out action=allow protocol=TCP localport=8766
@Echo Porta UDP 8766
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 8766" dir=in action=allow protocol=UDP localport=8766
netsh advfirewall firewall add rule name="Alterdata Porta 8766" dir=out action=allow protocol=UDP localport=8766
@Echo Porta TCP 587
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 587" dir=in action=allow protocol=TCP localport=587
netsh advfirewall firewall add rule name="Alterdata Porta 587" dir=out action=allow protocol=TCP localport=587
@Echo Porta UDP 587
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 587" dir=in action=allow protocol=UDP localport=587
netsh advfirewall firewall add rule name="Alterdata Porta 587" dir=out action=allow protocol=UDP localport=587
@Echo Porta TCP 8877
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 8877" dir=in action=allow protocol=TCP localport=8877
netsh advfirewall firewall add rule name="Alterdata Porta 8877" dir=out action=allow protocol=TCP localport=8877
@Echo Porta UDP 8877
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 8877" dir=in action=allow protocol=UDP localport=8877
netsh advfirewall firewall add rule name="Alterdata Porta 8877" dir=out action=allow protocol=UDP localport=8877
@Echo Porta TCP 465
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 465" dir=in action=allow protocol=UDP localport=465
netsh advfirewall firewall add rule name="Alterdata Porta 465" dir=out action=allow protocol=UDP localport=465
@Echo Porta UDP 465
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 465" dir=in action=allow protocol=TCP localport=465
netsh advfirewall firewall add rule name="Alterdata Porta 465" dir=out action=allow protocol=TCP localport=465
@Echo Porta TCP 2525
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 2525" dir=in action=allow protocol=UDP localport=2525
netsh advfirewall firewall add rule name="Alterdata Porta 2525" dir=out action=allow protocol=UDP localport=2525
@Echo Porta UDP 2525
Echo off
netsh advfirewall firewall add rule name="Alterdata Porta 2525" dir=in action=allow protocol=TCP localport=2525
netsh advfirewall firewall add rule name="Alterdata Porta 2525" dir=out action=allow protocol=TCP localport=2525


REM Permissão para o Postgres 9.0
@Echo Liberando permissoes  de executaveis no postgres 9.0:

@Echo Liberando permissao entrada e saida no firewall para  postgres.exe
Echo off
netsh advfirewall firewall add rule name="postgres.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\postgres.exe" enable=yes
netsh advfirewall firewall add rule name="postgres.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\postgres.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  pg_ctl.exe
Echo off
netsh advfirewall firewall add rule name="pg_ctl.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\pg_ctl.exe" enable=yes
netsh advfirewall firewall add rule name="pg_ctl.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\pg_ctl.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  pg_isready.exe
Echo off
netsh advfirewall firewall add rule name="pg_isready.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\pg_isready.exe" enable=yes
netsh advfirewall firewall add rule name="pg_isready.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\pg_isready.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_xlogdump.exe
Echo off
netsh advfirewall firewall add rule name="pg_xlogdump.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\pg_xlogdump.exe" enable=yes
netsh advfirewall firewall add rule name="pg_xlogdump.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\pg_xlogdump.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  reindexdb.exe
Echo off
netsh advfirewall firewall add rule name="reindexdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\reindexdb.exe" enable=yes
netsh advfirewall firewall add rule name="reindexdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\reindexdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para \vacuumdb.exe
Echo off
netsh advfirewall firewall add rule name="vacuumdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\vacuumdb.exe" enable=yes
netsh advfirewall firewall add rule name="vacuumdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\vacuumdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para clusterdb.exe
Echo off
netsh advfirewall firewall add rule name="clusterdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\clusterdb.exe" enable=yes
netsh advfirewall firewall add rule name="clusterdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\clusterdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para dropuser.exe
Echo off
netsh advfirewall firewall add rule name="dropuser.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\dropuser.exe" enable=yes
netsh advfirewall firewall add rule name="dropuser.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\dropuser.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para droplang.exe
Echo off
netsh advfirewall firewall add rule name="droplang.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\droplang.exe" enable=yes
netsh advfirewall firewall add rule name="droplang.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\droplang.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para dropdb.ex
Echo off
netsh advfirewall firewall add rule name="dropdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\dropdb.exe" enable=yes
netsh advfirewall firewall add rule name="dropdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\dropdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createuser.exe
Echo off
netsh advfirewall firewall add rule name="createuser.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\createuser.exe" enable=yes
netsh advfirewall firewall add rule name="createuser.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\createuser.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createlang.exe
Echo off
netsh advfirewall firewall add rule name="createlang.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\createlang.exe" enable=yes
netsh advfirewall firewall add rule name="createlang.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\createlang.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createdb.exe
Echo off
netsh advfirewall firewall add rule name="createdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\createdb.exe" enable=yes
netsh advfirewall firewall add rule name="createdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\createdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_restore.exe
Echo off
netsh advfirewall firewall add rule name="pg_restore.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\pg_restore.exe" enable=yes
netsh advfirewall firewall add rule name="pg_restore.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\pg_restore.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_dumpall.exe
Echo off
netsh advfirewall firewall add rule name="pg_dumpall.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\pg_dumpall.exe" enable=yes
netsh advfirewall firewall add rule name="pg_dumpall.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\pg_dumpall.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_dump.exe
Echo off
netsh advfirewall firewall add rule name="pg_dump.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\pg_dump.exe" enable=yes
netsh advfirewall firewall add rule name="pg_dump.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.0\bin\pg_dump.exe" enable=yes


REM Permissão para o Postgres 9.4
@Echo Liberando permissoes de executaveis do postgres 9.4:
Echo off
@Echo Liberando permissao entrada e saida no firewall para  postgres.exe
Echo off
netsh advfirewall firewall add rule name="postgres.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\postgres.exe" enable=yes
netsh advfirewall firewall add rule name="postgres.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\postgres.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  pg_ctl.exe
Echo off
netsh advfirewall firewall add rule name="pg_ctl.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\pg_ctl.exe" enable=yes
netsh advfirewall firewall add rule name="pg_ctl.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\pg_ctl.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  pg_isready.exe
Echo off
netsh advfirewall firewall add rule name="pg_isready.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\pg_isready.exe" enable=yes
netsh advfirewall firewall add rule name="pg_isready.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\pg_isready.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_xlogdump.exe
Echo off
netsh advfirewall firewall add rule name="pg_xlogdump.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\pg_xlogdump.exe" enable=yes
netsh advfirewall firewall add rule name="pg_xlogdump.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\pg_xlogdump.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  reindexdb.exe
Echo off
netsh advfirewall firewall add rule name="reindexdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\reindexdb.exe" enable=yes
netsh advfirewall firewall add rule name="reindexdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\reindexdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para \vacuumdb.exe
Echo off
netsh advfirewall firewall add rule name="vacuumdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\vacuumdb.exe" enable=yes
netsh advfirewall firewall add rule name="vacuumdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\vacuumdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para clusterdb.exe
Echo off
netsh advfirewall firewall add rule name="clusterdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\clusterdb.exe" enable=yes
netsh advfirewall firewall add rule name="clusterdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\clusterdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para dropuser.exe
Echo off
netsh advfirewall firewall add rule name="dropuser.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\dropuser.exe" enable=yes
netsh advfirewall firewall add rule name="dropuser.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\dropuser.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para droplang.exe
Echo off
netsh advfirewall firewall add rule name="droplang.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\droplang.exe" enable=yes
netsh advfirewall firewall add rule name="droplang.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\droplang.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para dropdb.ex
Echo off
netsh advfirewall firewall add rule name="dropdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\dropdb.exe" enable=yes
netsh advfirewall firewall add rule name="dropdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\dropdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createuser.exe
Echo off
netsh advfirewall firewall add rule name="createuser.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\createuser.exe" enable=yes
netsh advfirewall firewall add rule name="createuser.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\createuser.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createlang.exe
Echo off
netsh advfirewall firewall add rule name="createlang.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\createlang.exe" enable=yes
netsh advfirewall firewall add rule name="createlang.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\createlang.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createdb.exe
Echo off
netsh advfirewall firewall add rule name="createdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\createdb.exe" enable=yes
netsh advfirewall firewall add rule name="createdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\createdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_restore.exe
Echo off
netsh advfirewall firewall add rule name="pg_restore.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\pg_restore.exe" enable=yes
netsh advfirewall firewall add rule name="pg_restore.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\pg_restore.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_dumpall.exe
Echo off
netsh advfirewall firewall add rule name="pg_dumpall.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\pg_dumpall.exe" enable=yes
netsh advfirewall firewall add rule name="pg_dumpall.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\pg_dumpall.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_dump.exe
Echo off
netsh advfirewall firewall add rule name="pg_dump.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\pg_dump.exe" enable=yes
netsh advfirewall firewall add rule name="pg_dump.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.4\bin\pg_dump.exe" enable=yes


REM Permissão para o Postgres 9.5
@Echo Liberando permissoes de executaveis do postgres 9.5:
Echo off
@Echo Liberando permissao entrada e saida no firewall para  postgres.exe
Echo off
netsh advfirewall firewall add rule name="postgres.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\postgres.exe" enable=yes
netsh advfirewall firewall add rule name="postgres.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\postgres.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  pg_ctl.exe
Echo off
netsh advfirewall firewall add rule name="pg_ctl.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\pg_ctl.exe" enable=yes
netsh advfirewall firewall add rule name="pg_ctl.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\pg_ctl.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  pg_isready.exe
Echo off
netsh advfirewall firewall add rule name="pg_isready.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\pg_isready.exe" enable=yes
netsh advfirewall firewall add rule name="pg_isready.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\pg_isready.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_xlogdump.exe
Echo off
netsh advfirewall firewall add rule name="pg_xlogdump.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\pg_xlogdump.exe" enable=yes
netsh advfirewall firewall add rule name="pg_xlogdump.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\pg_xlogdump.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  reindexdb.exe
Echo off
netsh advfirewall firewall add rule name="reindexdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\reindexdb.exe" enable=yes
netsh advfirewall firewall add rule name="reindexdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\reindexdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para \vacuumdb.exe
Echo off
netsh advfirewall firewall add rule name="vacuumdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\vacuumdb.exe" enable=yes
netsh advfirewall firewall add rule name="vacuumdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\vacuumdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para clusterdb.exe
Echo off
netsh advfirewall firewall add rule name="clusterdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\clusterdb.exe" enable=yes
netsh advfirewall firewall add rule name="clusterdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\clusterdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para dropuser.exe
Echo off
netsh advfirewall firewall add rule name="dropuser.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\dropuser.exe" enable=yes
netsh advfirewall firewall add rule name="dropuser.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\dropuser.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para droplang.exe
Echo off
netsh advfirewall firewall add rule name="droplang.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\droplang.exe" enable=yes
netsh advfirewall firewall add rule name="droplang.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\droplang.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para dropdb.ex
Echo off
netsh advfirewall firewall add rule name="dropdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\dropdb.exe" enable=yes
netsh advfirewall firewall add rule name="dropdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\dropdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createuser.exe
Echo off
netsh advfirewall firewall add rule name="createuser.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\createuser.exe" enable=yes
netsh advfirewall firewall add rule name="createuser.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\createuser.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createlang.exe
Echo off
netsh advfirewall firewall add rule name="createlang.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\createlang.exe" enable=yes
netsh advfirewall firewall add rule name="createlang.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\createlang.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createdb.exe
Echo off
netsh advfirewall firewall add rule name="createdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\createdb.exe" enable=yes
netsh advfirewall firewall add rule name="createdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\createdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_restore.exe
Echo off
netsh advfirewall firewall add rule name="pg_restore.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\pg_restore.exe" enable=yes
netsh advfirewall firewall add rule name="pg_restore.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\pg_restore.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_dumpall.exe
Echo off
netsh advfirewall firewall add rule name="pg_dumpall.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\pg_dumpall.exe" enable=yes
netsh advfirewall firewall add rule name="pg_dumpall.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\pg_dumpall.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_dump.exe
Echo off
netsh advfirewall firewall add rule name="pg_dump.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\pg_dump.exe" enable=yes
netsh advfirewall firewall add rule name="pg_dump.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.5\bin\pg_dump.exe" enable=yes

REM Permissão para o Postgres 9.6
@Echo Liberando permissoes de executaveis do postgres 9.6:
Echo off
@Echo Liberando permissao entrada e saida no firewall para clusterdb.exe
Echo off
netsh advfirewall firewall add rule name="clusterdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\clusterdb.exe" enable=yes
netsh advfirewall firewall add rule name="clusterdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\clusterdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createdb.exe
Echo off
netsh advfirewall firewall add rule name="createdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\createdb.exe" enable=yes
netsh advfirewall firewall add rule name="createdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\createdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createlang.exe
Echo off
netsh advfirewall firewall add rule name="createlang.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\createlang.exe" enable=yes
netsh advfirewall firewall add rule name="createlang.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\createlang.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createuser.exe
Echo off
netsh advfirewall firewall add rule name="createuser.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\createuser.exe" enable=yes
netsh advfirewall firewall add rule name="createuser.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\createuser.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para dropdb.exe
Echo off
netsh advfirewall firewall add rule name="dropdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\dropdb.exe" enable=yes
netsh advfirewall firewall add rule name="dropdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\dropdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para droplang.exe
Echo off
netsh advfirewall firewall add rule name="droplang.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\droplang.exe" enable=yes
netsh advfirewall firewall add rule name="droplang.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\droplang.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para dropuser.exe
Echo off
netsh advfirewall firewall add rule name="dropuser.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\dropuser.exe" enable=yes
netsh advfirewall firewall add rule name="dropuser.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\dropuser.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para ecpg.exe
Echo off
netsh advfirewall firewall add rule name="ecpg.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\ecpg.exe" enable=yes
netsh advfirewall firewall add rule name="ecpg.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\ecpg.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  pg_ctl.exe
Echo off
netsh advfirewall firewall add rule name="pg_ctl.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\pg_ctl.exe" enable=yes
netsh advfirewall firewall add rule name="pg_ctl.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\pg_ctl.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_dump.exe
Echo off
netsh advfirewall firewall add rule name="pg_dump.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\pg_dump.exe" enable=yes
netsh advfirewall firewall add rule name="pg_dump.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\pg_dump.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_dumpall.exe
Echo off
netsh advfirewall firewall add rule name="pg_dumpall.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\pg_dumpall.exe" enable=yes
netsh advfirewall firewall add rule name="pg_dumpall.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\pg_dumpall.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  pg_isready.exe
Echo off
netsh advfirewall firewall add rule name="pg_isready.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\pg_isready.exe" enable=yes
netsh advfirewall firewall add rule name="pg_isready.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\pg_isready.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_restore.exe
Echo off
netsh advfirewall firewall add rule name="pg_restore.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\pg_restore.exe" enable=yes
netsh advfirewall firewall add rule name="pg_restore.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\pg_restore.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_xlogdump.exe
Echo off
netsh advfirewall firewall add rule name="pg_xlogdump.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\pg_xlogdump.exe" enable=yes
netsh advfirewall firewall add rule name="pg_xlogdump.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\pg_xlogdump.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  postgres.exe
Echo off
netsh advfirewall firewall add rule name="postgres.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\postgres.exe" enable=yes
netsh advfirewall firewall add rule name="postgres.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\postgres.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  reindexdb.exe
Echo off
netsh advfirewall firewall add rule name="reindexdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\reindexdb.exe" enable=yes
netsh advfirewall firewall add rule name="reindexdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\reindexdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para \vacuumdb.exe
Echo off
netsh advfirewall firewall add rule name="vacuumdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\vacuumdb.exe" enable=yes
netsh advfirewall firewall add rule name="vacuumdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\9.6\bin\vacuumdb.exe" enable=yes

REM Permissão para o Postgres 11
@Echo Liberando permissoes de executaveis do postgres 11:
Echo off
@Echo Liberando permissao entrada e saida no firewall para clusterdb.exe
Echo off
netsh advfirewall firewall add rule name="clusterdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\clusterdb.exe" enable=yes
netsh advfirewall firewall add rule name="clusterdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\clusterdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createdb.exe
Echo off
netsh advfirewall firewall add rule name="createdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\createdb.exe" enable=yes
netsh advfirewall firewall add rule name="createdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\createdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para createuser.exe
Echo off
netsh advfirewall firewall add rule name="createuser.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\createuser.exe" enable=yes
netsh advfirewall firewall add rule name="createuser.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\createuser.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para dropdb.exe
Echo off
netsh advfirewall firewall add rule name="dropdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\dropdb.exe" enable=yes
netsh advfirewall firewall add rule name="dropdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\dropdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para dropuser.exe
Echo off
netsh advfirewall firewall add rule name="dropuser.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\dropuser.exe" enable=yes
netsh advfirewall firewall add rule name="dropuser.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\dropuser.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para ecpg.exe
Echo off
netsh advfirewall firewall add rule name="ecpg.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\ecpg.exe" enable=yes
netsh advfirewall firewall add rule name="ecpg.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\ecpg.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  pg_ctl.exe
Echo off
netsh advfirewall firewall add rule name="pg_ctl.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\pg_ctl.exe" enable=yes
netsh advfirewall firewall add rule name="pg_ctl.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\pg_ctl.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_dump.exe
Echo off
netsh advfirewall firewall add rule name="pg_dump.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\pg_dump.exe" enable=yes
netsh advfirewall firewall add rule name="pg_dump.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\pg_dump.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_dumpall.exe
Echo off
netsh advfirewall firewall add rule name="pg_dumpall.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\pg_dumpall.exe" enable=yes
netsh advfirewall firewall add rule name="pg_dumpall.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\pg_dumpall.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  pg_isready.exe
Echo off
netsh advfirewall firewall add rule name="pg_isready.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\pg_isready.exe" enable=yes
netsh advfirewall firewall add rule name="pg_isready.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\pg_isready.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para pg_restore.exe
Echo off
netsh advfirewall firewall add rule name="pg_restore.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\pg_restore.exe" enable=yes
netsh advfirewall firewall add rule name="pg_restore.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\pg_restore.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  postgres.exe
Echo off
netsh advfirewall firewall add rule name="postgres.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\postgres.exe" enable=yes
netsh advfirewall firewall add rule name="postgres.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\postgres.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para  reindexdb.exe
Echo off
netsh advfirewall firewall add rule name="reindexdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\reindexdb.exe" enable=yes
netsh advfirewall firewall add rule name="reindexdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\reindexdb.exe" enable=yes
@Echo Liberando permissao entrada e saida no firewall para \vacuumdb.exe
Echo off
netsh advfirewall firewall add rule name="vacuumdb.exe" dir=in action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\vacuumdb.exe" enable=yes
netsh advfirewall firewall add rule name="vacuumdb.exe" dir=out action=allow program="c:\Arquivos de Programas\PostgreSQL\11\bin\vacuumdb.exe" enable=yes





@Echo Liberando permissao para a pasta PostgreSQL:
Echo off
icacls "C:\Program Files\PostgreSQL\11\data\base" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\global" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\log" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_commit_ts" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_dynshmem" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_logical" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_multixact" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_notify" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_replslot" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_serial" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_snapshots" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_stat" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_stat_tmp" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_subtrans" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_tblspc" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_twophase" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_wal" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\11\data\pg_xact" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\base" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\global" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_clog" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_commit_ts" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_dynshmem" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_log" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_logical" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_multixact" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_notify" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_replslot" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_serial" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_snapshots" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_stat" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_stat_tmp" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_subtrans" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_tblspc" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_twophase" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.6\data\pg_xlog" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\base" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\global" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_clog" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_commit_ts" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_dynshmem" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_log" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_logical" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_multixact" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_notify" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_replslot" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_serial" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_snapshots" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_stat" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_stat_tmp" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_subtrans" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_tblspc" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_twophase" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.5\data\pg_xlog" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\base" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\global" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_clog" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_commit_ts" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_dynshmem" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_log" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_logical" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_multixact" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_notify" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_replslot" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_serial" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_snapshots" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_stat" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_stat_tmp" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_subtrans" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_tblspc" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_twophase" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.4\data\pg_xlog" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\base" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\global" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_clog" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_commit_ts" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_dynshmem" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_log" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_logical" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_multixact" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_notify" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_replslot" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_serial" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_snapshots" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_stat" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_stat_tmp" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_subtrans" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_tblspc" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_twophase" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files\PostgreSQL\9.3\data\pg_xlog" /grant:r "Todos":(OI)(CI)F /t

@Echo Liberando permissoes de executaveis Shop:
Echo off

@Echo Liberando permissao em AltShopProc_ExportadorNeoGrid.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_ExportadorNeoGrid.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_ExportadorNeoGrid.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_ExportadorNeoGrid.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_ExportadorNeoGrid.exe" enable=yes
@Echo Liberando permissao em altshopproc_cadastroprodutos.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_cadastroprodutos.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_cadastroprodutos.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_cadastroprodutos.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_cadastroprodutos.exe" enable=yes@Echo Liberando permissao em 
Echo Liberando permissao em RegAsm.exe
Echo off
netsh advfirewall firewall add rule name="RegAsm.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\RegAsm.exe" enable=yes
netsh advfirewall firewall add rule name="RegAsm.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\RegAsm.exe" enable=yes
@Echo Liberando permissao em AltShopProcExtratorXML.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProcExtratorXML.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProcExtratorXML.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProcExtratorXML.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProcExtratorXML.exe" enable=yes
@Echo Liberando permissao em AltShopProc_ManutencaoPrecoProduto.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_ManutencaoPrecoProduto.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_ManutencaoPrecoProduto.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_ManutencaoPrecoProduto.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_ManutencaoPrecoProduto.exe" enable=yes
@Echo Liberando permissao em altshopproc_manutencaoprodutos.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_manutencaoprodutos.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_manutencaoprodutos.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_manutencaoprodutos.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_manutencaoprodutos.exe" enable=yes
@Echo Liberando permissao em AltShopProc_AtualizarDocNFeWShop.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_AtualizarDocNFeWShop.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AtualizarDocNFeWShop.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_AtualizarDocNFeWShop.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AtualizarDocNFeWShop.exe" enable=yes
@Echo Liberando permissao em AltShopProc_AtualizarDocNFeIShop.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_AtualizarDocNFeIShop.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AtualizarDocNFeIShop.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_AtualizarDocNFeIShop.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AtualizarDocNFeIShop.exe" enable=yes
@Echo Liberando permissao em worc_2005.exe
Echo off
netsh advfirewall firewall add rule name="worc_2005.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\worc_2005.exe" enable=yes
netsh advfirewall firewall add rule name="worc_2005.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\worc_2005.exe" enable=yes
@Echo Liberando permissao em altshopproc_movestoqueotimizado.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_movestoqueotimizado.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_movestoqueotimizado.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_movestoqueotimizado.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_movestoqueotimizado.exe" enable=yes
@Echo Liberando permissao em altshopordemservicoentrada.exe
Echo off
netsh advfirewall firewall add rule name="altshopordemservicoentrada.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopordemservicoentrada.exe" enable=yes
netsh advfirewall firewall add rule name="altshopordemservicoentrada.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopordemservicoentrada.exe" enable=yes
@Echo Liberando permissao em IAgendaAdmin.exe
Echo off
netsh advfirewall firewall add rule name="IAgendaAdmin.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\IAgendaAdmin.exe" enable=yes
netsh advfirewall firewall add rule name="IAgendaAdmin.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\IAgendaAdmin.exe" enable=yes
@Echo Liberando permissao em altshopproc_gerarsintegra.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_gerarsintegra.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_gerarsintegra.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_gerarsintegra.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_gerarsintegra.exe" enable=yes
@Echo Liberando permissao em altshopproc_gerarsped.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_gerarsped.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_gerarsped.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_gerarsped.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_gerarsped.exe" enable=yes
@Echo Liberando permissao em altshopimpressaocarne.exe
Echo off
netsh advfirewall firewall add rule name="altshopimpressaocarne.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopimpressaocarne.exe" enable=yes
netsh advfirewall firewall add rule name="altshopimpressaocarne.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopimpressaocarne.exe" enable=yes
@Echo Liberando permissao em altshopconfig_pdvalterdata.exe
Echo off
netsh advfirewall firewall add rule name="altshopconfig_pdvalterdata.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopconfig_pdvalterdata.exe" enable=yes
netsh advfirewall firewall add rule name="altshopconfig_pdvalterdata.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopconfig_pdvalterdata.exe" enable=yes
@Echo Liberando permissao em AltShop_GerenciadorNotas.exe
Echo off
netsh advfirewall firewall add rule name="AltShop_GerenciadorNotas.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_GerenciadorNotas.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_GerenciadorNotas.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_GerenciadorNotas.exe" enable=yes
@Echo Liberando permissao em AltShop_InutilizacaoFaixaNFCe.exe
Echo off
netsh advfirewall firewall add rule name="AltShop_InutilizacaoFaixaNFCe.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_InutilizacaoFaixaNFCe.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_InutilizacaoFaixaNFCe.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_InutilizacaoFaixaNFCe.exe" enable=yes
@Echo Liberando permissao em altshopreldocumentos.exe
Echo off
netsh advfirewall firewall add rule name="altshopreldocumentos.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopreldocumentos.exe" enable=yes
netsh advfirewall firewall add rule name="altshopreldocumentos.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopreldocumentos.exe" enable=yes
@Echo Liberando permissao em altshopproc_integracaoorcamentopdalogicalafv.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_integracaoorcamentopdalogicalafv.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_integracaoorcamentopdalogicalafv.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_integracaoorcamentopdalogicalafv.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_integracaoorcamentopdalogicalafv.exe" enable=yes
@Echo Liberando permissao em AltShopProc_AVARElatorios.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_AVARElatorios.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AVARElatorios.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_AVARElatorios.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AVARElatorios.exe" enable=yes
@Echo Liberando permissao em WSched.exe
Echo off
netsh advfirewall firewall add rule name="WSched.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\WSched.exe" enable=yes
netsh advfirewall firewall add rule name="WSched.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\WSched.exe" enable=yes
@Echo Liberando permissao em altshopproc_financeiro.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_financeiro.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_financeiro.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_financeiro.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_financeiro.exe" enable=yes
@Echo Liberando permissao em altshoprel_simplificadodeprodutos.exe
Echo off
netsh advfirewall firewall add rule name="altshoprel_simplificadodeprodutos.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshoprel_simplificadodeprodutos.exee" enable=yes
netsh advfirewall firewall add rule name="altshoprel_simplificadodeprodutos.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshoprel_simplificadodeprodutos.exee" enable=yes
@Echo Liberando permissao em WToten.exe
Echo off
netsh advfirewall firewall add rule name="WToten.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\WToten.exe" enable=yes
netsh advfirewall firewall add rule name="WToten.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\WToten.exe" enable=yes
@Echo Liberando permissao em altshoprel_produtosvendidosclientevendedor.exe
Echo off
netsh advfirewall firewall add rule name="altshoprel_produtosvendidosclientevendedor.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshoprel_produtosvendidosclientevendedor.exe" enable=yes
netsh advfirewall firewall add rule name="altshoprel_produtosvendidosclientevendedor.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshoprel_produtosvendidosclientevendedor.exe" enable=yes
@Echo Liberando permissao em altshoprelextratoprodutos.exe
Echo off
netsh advfirewall firewall add rule name="altshoprelextratoprodutos.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshoprelextratoprodutos.exe" enable=yes
netsh advfirewall firewall add rule name="altshoprelextratoprodutos.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshoprelextratoprodutos.exe" enable=yes
@Echo Liberando permissao em AltShopProc_Tesouraria.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_Tesouraria.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_Tesouraria.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_Tesouraria.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_Tesouraria.exe" enable=yes
@Echo Liberando permissao em AltShopProc_Sincronizador4Keep.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_Sincronizador4Keep.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_Sincronizador4Keep.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_Sincronizador4Keep.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_Sincronizador4Keep.exe" enable=yes
@Echo Liberando permissao em AltShopProc_CadastroProdutosSimples.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_CadastroProdutosSimples.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_CadastroProdutosSimples.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_CadastroProdutosSimples.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_CadastroProdutosSimples.exe" enable=yes
@Echo Liberando permissao em AltShopProc_Delivery.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_Delivery.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_Delivery.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_Delivery.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_Delivery.exe" enable=yes
@Echo Liberando permissao em AltShopProc_CompraFacil
Echo off
netsh advfirewall firewall add rule name="AltShopProc_CompraFacil" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_CompraFacil" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_CompraFacil" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_CompraFacil" enable=yes
@Echo Liberando permissao em altshopproc_cadastroempresas.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_cadastroempresas.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_cadastroempresas.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_cadastroempresas.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_cadastroempresas.exe" enable=yes
@Echo Liberando permissao em AltShopProc_ControleRomaneio.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_ControleRomaneio.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_ControleRomaneio.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_ControleRomaneio.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_ControleRomaneio.exe" enable=yes
@Echo Liberando permissao em AltShop_DashBoard.exe
Echo off
netsh advfirewall firewall add rule name="AltShop_DashBoard.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_DashBoard.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_DashBoard.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_DashBoard.exe" enable=yes
@Echo Liberando permissao em AltShop_Configuracoes.exe
Echo off
netsh advfirewall firewall add rule name="AltShop_Configuracoes.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_Configuracoes.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_Configuracoes.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_Configuracoes.exe" enable=yes
@Echo Liberando permissao em worc_200.exe
Echo off
netsh advfirewall firewall add rule name="worc_200.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\worc_200.exe" enable=yes
netsh advfirewall firewall add rule name="worc_200.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\worc_200.exe" enable=yes
@Echo Liberando permissao em WAgendaAdmin.exe
Echo off
netsh advfirewall firewall add rule name="WAgendaAdmin.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\WAgendaAdmin.exe" enable=yes
netsh advfirewall firewall add rule name="WAgendaAdmin.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\WAgendaAdmin.exe" enable=yes
@Echo Liberando permissao em WShopSE.exe
Echo off
netsh advfirewall firewall add rule name="WShopSE.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\WShopSE.exe" enable=yes
netsh advfirewall firewall add rule name="WShopSE.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\WShopSE.exe" enable=yes
@Echo Liberando permissao em winv.exe
Echo off
netsh advfirewall firewall add rule name="winv.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\winv.exe" enable=yes
netsh advfirewall firewall add rule name="winv.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\winv.exe" enable=yes
@Echo Liberando permissao em altshopanalisedesempenhovendedor.exe
Echo off
netsh advfirewall firewall add rule name="altshopanalisedesempenhovendedor.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\altshopanalisedesempenhovendedor.exe" enable=yes
netsh advfirewall firewall add rule name="altshopanalisedesempenhovendedor.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\altshopanalisedesempenhovendedor.exe" enable=yes
@Echo Liberando permissao em AltShop_AVA.exe
Echo off
netsh advfirewall firewall add rule name="AltShop_AVA.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_AVA.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_AVA.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_AVA.exe" enable=yes
@Echo Liberando permissao em altshoprelatorioinventario.exe
Echo off
netsh advfirewall firewall add rule name="altshoprelatorioinventario.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshoprelatorioinventario.exe" enable=yes
netsh advfirewall firewall add rule name="altshoprelatorioinventario.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshoprelatorioinventario.exe" enable=yes
@Echo Liberando permissao em altshopproc_maladireta.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_maladireta.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_maladireta.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_maladireta.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_maladireta.exe" enable=yes
@Echo Liberando permissao em altshopproc_manutencaoprodutos2.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_manutencaoprodutos2.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_manutencaoprodutos2.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_manutencaoprodutos2.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_manutencaoprodutos2.exe" enable=yes
@Echo Liberando permissao em AltShopProc_AuditorEventos.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_AuditorEventos.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AuditorEventos.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_AuditorEventos.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AuditorEventos.exe" enable=yes
@Echo Liberando permissao em ltShopOrdemServicoConfig.exe
Echo off
netsh advfirewall firewall add rule name="AltShopOrdemServicoConfig.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopOrdemServicoConfig.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopOrdemServicoConfig.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopOrdemServicoConfig.exe" enable=yes
@Echo Liberando permissao em AdminEmissaoOtimizada.exe
Echo off
netsh advfirewall firewall add rule name="AdminEmissaoOtimizada.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AdminEmissaoOtimizada.exe" enable=yes
netsh advfirewall firewall add rule name="AdminEmissaoOtimizada.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AdminEmissaoOtimizada.exe" enable=yes
@Echo Liberando permissao em AltShopProc_BaixarNFESefaz.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_BaixarNFESefaz.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_BaixarNFESefaz.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_BaixarNFESefaz.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_BaixarNFESefaz.exe" enable=yes
@Echo Liberando permissao em AlterdataManager.exe
Echo off
netsh advfirewall firewall add rule name="AlterdataManager.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AlterdataManager.exe" enable=yes
netsh advfirewall firewall add rule name="AlterdataManager.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AlterdataManager.exe" enable=yes
@Echo Liberando permissao em OrdemServicoIshop.exe
Echo off
netsh advfirewall firewall add rule name="OrdemServicoIshop.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\OrdemServicoIshop.exe" enable=yes
netsh advfirewall firewall add rule name="OrdemServicoIshop.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\OrdemServicoIshop.exe" enable=yes
@Echo Liberando permissao em OSAdmin.exe
Echo off
netsh advfirewall firewall add rule name="OSAdmin.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\OSAdmin.exe" enable=yes
netsh advfirewall firewall add rule name="OSAdmin.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\OSAdmin.exe" enable=yes
@Echo Liberando permissao em WorcAdmin.exe
Echo off
netsh advfirewall firewall add rule name="WorcAdmin.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\WorcAdmin.exe" enable=yes
netsh advfirewall firewall add rule name="WorcAdmin.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\WorcAdmin.exe" enable=yes
@Echo Liberando permissao em IOrcAdmin.exe
Echo off
netsh advfirewall firewall add rule name="IOrcAdmin.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\IOrcAdmin.exe" enable=yes
netsh advfirewall firewall add rule name="IOrcAdmin.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\IOrcAdmin.exe" enable=yes
@Echo Liberando permissao em IAdminEmissaoOtimizada.exe
Echo off
netsh advfirewall firewall add rule name="IAdminEmissaoOtimizada.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\IAdminEmissaoOtimizada.exe" enable=yes
netsh advfirewall firewall add rule name="IAdminEmissaoOtimizada.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\IAdminEmissaoOtimizada.exe" enable=yes
@Echo Liberando permissao em altshopproc_gerenciadormdfe.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_gerenciadormdfe.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_gerenciadormdfe.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_gerenciadormdfe.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_gerenciadormdfe.exe" enable=yes
@Echo Liberando permissao em AltshopRel_AnaliseFiscal.exe
Echo off
netsh advfirewall firewall add rule name="AltshopRel_AnaliseFiscal.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltshopRel_AnaliseFiscal.exe" enable=yes
netsh advfirewall firewall add rule name="AltshopRel_AnaliseFiscal.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltshopRel_AnaliseFiscal.exe" enable=yes
@Echo Liberando permissao em altshoprel_contasreceberpagar.exe
Echo off
netsh advfirewall firewall add rule name="altshoprel_contasreceberpagar.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshoprel_contasreceberpagar.exe" enable=yes
netsh advfirewall firewall add rule name="altshoprel_contasreceberpagar.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshoprel_contasreceberpagar.exe" enable=yes
@Echo Liberando permissao em altshopproc_integracaofciproduto.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_integracaofciproduto.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_integracaofciproduto.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_integracaofciproduto.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_integracaofciproduto.exe" enable=yes
@Echo Liberando permissao em AltShopProc_ControleEntregas_Expedicao.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_ControleEntregas_Expedicao.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_ControleEntregas_Expedicao.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_ControleEntregas_Expedicao.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_ControleEntregas_Expedicao.exe" enable=yes
@Echo Liberando permissao em AltShopProc_AlinhamentoTransacaoPendenteWShop.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_AlinhamentoTransacaoPendenteWShop.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AlinhamentoTransacaoPendenteWShop.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_AlinhamentoTransacaoPendenteWShop.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AlinhamentoTransacaoPendenteWShop.exe" enable=yes
@Echo Liberando permissao em AltShopProc_AlinhamentoTransacaoPendenteIShop.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_AlinhamentoTransacaoPendenteIShop.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AlinhamentoTransacaoPendenteIShop.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_AlinhamentoTransacaoPendenteIShop.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AlinhamentoTransacaoPendenteIShop.exe" enable=yes
@Echo Liberando permissao em AltShopProc_AlterarStatusMonitor.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_AlterarStatusMonitor.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AlterarStatusMonitor.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_AlterarStatusMonitor.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AlterarStatusMonitor.exe" enable=yes
@Echo Liberando permissao em AltShopProc_Promocao.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_Promocao.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_Promocao.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_Promocao.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_Promocao.exe" enable=yes
@Echo Liberando permissao em CotacaoAdmin.exe
Echo off
netsh advfirewall firewall add rule name="CotacaoAdmin.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\CotacaoAdmin.exe" enable=yes
netsh advfirewall firewall add rule name="CotacaoAdmin.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\CotacaoAdmin.exe" enable=yes
@Echo Liberando permissao em WDelivery.exe
Echo off
netsh advfirewall firewall add rule name="WDelivery.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\WDelivery.exe" enable=yes
netsh advfirewall firewall add rule name="WDelivery.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\WDelivery.exe" enable=yes
@Echo Liberando permissao em MonitorIntegracao.exe
Echo off
netsh advfirewall firewall add rule name="MonitorIntegracao.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\MonitorIntegracao.exe" enable=yes
netsh advfirewall firewall add rule name="MonitorIntegracao.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\MonitorIntegracao.exe" enable=yes
@Echo Liberando permissao em IDelivery.exe
Echo off
netsh advfirewall firewall add rule name="IDelivery.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\IDelivery.exe" enable=yes
netsh advfirewall firewall add rule name="IDelivery.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\IDelivery.exe" enable=yes
@Echo Liberando permissao em AltShopRel_ResumoDoDia.exe
Echo off
netsh advfirewall firewall add rule name="AltShopRel_ResumoDoDia.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopRel_ResumoDoDia.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopRel_ResumoDoDia.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopRel_ResumoDoDia.exe" enable=yes
@Echo Liberando permissao em AltShopProc_SincronizadorECommerce.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_SincronizadorECommerce.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_SincronizadorECommerce.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_SincronizadorECommerce.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_SincronizadorECommerce.exe" enable=yes
@Echo Liberando permissao em altshopproc_geracaodav.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_geracaodav.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_geracaodav.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_geracaodav.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_geracaodav.exe" enable=yes
@Echo Liberando permissao em AltShop_SincronizadorScanntechGuardian.exe
Echo off
netsh advfirewall firewall add rule name="AltShop_SincronizadorScanntechGuardian.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_SincronizadorScanntechGuardian.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_SincronizadorScanntechGuardian.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_SincronizadorScanntechGuardian.exe" enable=yes
@Echo Liberando permissao em altshopgeracaobase.exe
Echo off
netsh advfirewall firewall add rule name="altshopgeracaobase.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopgeracaobase.exe" enable=yes
netsh advfirewall firewall add rule name="altshopgeracaobase.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopgeracaobase.exe" enable=yes
@Echo Liberando permissao em AltShop_ServicoGuardian.exe
Echo off
netsh advfirewall firewall add rule name="AltShop_ServicoGuardian.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_ServicoGuardian.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_ServicoGuardian.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_ServicoGuardian.exe" enable=yes
@Echo Liberando permissao em AltShopProc_FerramentasCadastroCliente.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_FerramentasCadastroCliente.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_FerramentasCadastroCliente.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_FerramentasCadastroCliente.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_FerramentasCadastroCliente.exe" enable=yes
@Echo Liberando permissao em CotacaoAdminIshop.exe
Echo off
netsh advfirewall firewall add rule name="CotacaoAdminIshop.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\CotacaoAdminIshop.exe" enable=yes
netsh advfirewall firewall add rule name="CotacaoAdminIshop.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\CotacaoAdminIshop.exe" enable=yes
@Echo Liberando permissao em AlterAgente.exe
Echo off
netsh advfirewall firewall add rule name="AlterAgente.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AlterAgente.exe" enable=yes
netsh advfirewall firewall add rule name="AlterAgente.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AlterAgente.exe" enable=yes
@Echo Liberando permissao em lterAgenteGuardian.exe
Echo off
netsh advfirewall firewall add rule name="AlterAgenteGuardian.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AlterAgenteGuardian.exe" enable=yes
netsh advfirewall firewall add rule name="AlterAgenteGuardian.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AlterAgenteGuardian.exe" enable=yes
@Echo Liberando permissao em AltShopProc_BoletoExpress_Integrador.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_BoletoExpress_Integrador.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_BoletoExpress_Integrador.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_BoletoExpress_Integrador.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_BoletoExpress_Integrador.exe" enable=yes
@Echo Liberando permissao em altshoprel_quadrovendadiaria.exe
Echo off
netsh advfirewall firewall add rule name="altshoprel_quadrovendadiaria.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshoprel_quadrovendadiaria.exe" enable=yes
netsh advfirewall firewall add rule name="altshoprel_quadrovendadiaria.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshoprel_quadrovendadiaria.exe" enable=yes
@Echo Liberando permissao em xecuteDll.exe
Echo off
netsh advfirewall firewall add rule name="ExecuteDll.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\ExecuteDll.exe" enable=yes
netsh advfirewall firewall add rule name="ExecuteDll.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\ExecuteDll.exe" enable=yes
@Echo Liberando permissao em Shell.exe
Echo off
netsh advfirewall firewall add rule name="Shell.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AShell.exe" enable=yes
netsh advfirewall firewall add rule name="Shell.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AShell.exe" enable=yes
@Echo Liberando permissao em AltShopProc_GerenciadorCartaCredito.exe
Echo off
netsh advfirewall firewall add rule name="AltShopProc_GerenciadorCartaCredito.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_GerenciadorCartaCredito.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_GerenciadorCartaCredito.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopProc_GerenciadorCartaCredito.exe" enable=yes
@Echo Liberando permissao em AltShopOSWorkFlow.exe
Echo off
netsh advfirewall firewall add rule name="AltShopOSWorkFlow.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopOSWorkFlow.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopOSWorkFlow.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopOSWorkFlow.exe" enable=yes
@Echo Liberando permissao em AltShopOSEquipamentos.ex
Echo off
netsh advfirewall firewall add rule name="AltShopOSEquipamentos.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopOSEquipamentos.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopOSEquipamentos.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopOSEquipamentos.exe" enable=yes
@Echo Liberando permissao em altshopmaparesumo.exe
Echo off
netsh advfirewall firewall add rule name="altshopmaparesumo.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopmaparesumo.exe" enable=yes
netsh advfirewall firewall add rule name="altshopmaparesumo.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopmaparesumo.exe" enable=yes
@Echo Liberando permissao em AltShop_SincronizadorScanntech.exe
Echo off
netsh advfirewall firewall add rule name="AltShop_SincronizadorScanntech.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\aAltShop_SincronizadorScanntech.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_SincronizadorScanntech.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\aAltShop_SincronizadorScanntech.exe" enable=yes
@Echo Liberando permissao em altshopproc_cadastroprodutosspice.exe
Echo off
netsh advfirewall firewall add rule name="altshopproc_cadastroprodutosspice.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_cadastroprodutosspice.exe" enable=yes
netsh advfirewall firewall add rule name="altshopproc_cadastroprodutosspice.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\altshopproc_cadastroprodutosspice.exe" enable=yes
@Echo Liberando permissao em AltShopConv_ImagensProduto.exe
Echo off
netsh advfirewall firewall add rule name="AltShopConv_ImagensProduto.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopConv_ImagensProduto.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopConv_ImagensProduto.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShopConv_ImagensProduto.exe" enable=yes
@Echo Liberando permissao em configurador_ambiente_postgresql.exe
Echo off
netsh advfirewall firewall add rule name="configurador_ambiente_postgresql.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\configurador_ambiente_postgresql.exe" enable=yes
netsh advfirewall firewall add rule name="configurador_ambiente_postgresql.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\configurador_ambiente_postgresql.exe" enable=yes
@Echo Liberando permissao em AltShop_GeradorDeArquivos.exe
Echo off
netsh advfirewall firewall add rule name="AltShop_GeradorDeArquivos.exe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_GeradorDeArquivos.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_GeradorDeArquivos.exe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Shop\AltShop_GeradorDeArquivos.exe" enable=yes
@Echo Liberando permissao em Alterdata.Updater.ConsoleApp
Echo off
netsh advfirewall firewall add rule name="Alterdata.Updater.ConsoleApp" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Updater\bin\Alterdata.Updater.ConsoleApp.exe" enable=yes
netsh advfirewall firewall add rule name="Alterdata.Updater.ConsoleApp" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Updater\bin\Alterdata.Updater.ConsoleApp.exe" enable=yes
@Echo Liberando permissao em AlterdataAutoUpdate
Echo off
netsh advfirewall firewall add rule name="AlterdataAutoUpdate" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Updater\bin\AlterdataAutoUpdate.exe" enable=yes
netsh advfirewall firewall add rule name="AlterdataAutoUpdate" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Updater\bin\AlterdataAutoUpdate.exe" enable=yes
@Echo Liberando permissao em UpdaterManager
Echo off
netsh advfirewall firewall add rule name="UpdaterManager" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Updater\bin\UpdaterManager.exe" enable=yes
netsh advfirewall firewall add rule name="UpdaterManager" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Updater\bin\UpdaterManager.exe" enable=yes
@Echo Liberando permissao em Guardian
Echo off
netsh advfirewall firewall add rule name="Guardian" dir=in action=allow program="C:\Program Files (x86)\Alterdata\Updater\bin\Guardian.exe" enable=yes
netsh advfirewall firewall add rule name="Guardian" dir=out action=allow program="C:\Program Files (x86)\Alterdata\Updater\bin\Guardian.exe" enable=yes
@Echo Liberando permissao em Alterdata.Prevenda
Echo off
netsh advfirewall firewall add rule name="Alterdata.Prevenda" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PreVenda\Alterdata.Prevenda.exe" enable=yes
netsh advfirewall firewall add rule name="Alterdata.Prevenda" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PreVenda\Alterdata.Prevenda.exe" enable=yes
@Echo Liberando permissao em PDVAlterdata
Echo off
netsh advfirewall firewall add rule name="PDVAlterdata" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\PDVAlterdata.exe" enable=yes
netsh advfirewall firewall add rule name="PDVAlterdata" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\PDVAlterdata.exe" enable=yes
@Echo Liberando permissao em ServidorOffLine
Echo off
netsh advfirewall firewall add rule name="ServidorOffLine" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\PinPadFinder.exe" enable=yes
netsh advfirewall firewall add rule name="ServidorOffLine" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\PinPadFinder.exe" enable=yes
@Echo Liberando permissao em PinPadFinder
Echo off
netsh advfirewall firewall add rule name="PinPadFinder" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\PDVAlterdata.exe" enable=yes
netsh advfirewall firewall add rule name="PinPadFinder" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\PDVAlterdata.exe" enable=yes
@Echo Liberando permissao em AltShop_InutilizacaoFaixaNFCe
Echo off
netsh advfirewall firewall add rule name="AltShop_InutilizacaoFaixaNFCe" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_InutilizacaoFaixaNFCe.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_InutilizacaoFaixaNFCe" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_InutilizacaoFaixaNFCe.exe" enable=yes
@Echo Liberando permissao em LiberaECF
Echo off
netsh advfirewall firewall add rule name="LiberaECF" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\LiberaECF" enable=yes
netsh advfirewall firewall add rule name="LiberaECF" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\LiberaECF" enable=yes
@Echo Liberando permissao em AltShop_GeradorBlocoX_DataBase
Echo off
netsh advfirewall firewall add rule name="AltShop_GeradorBlocoX_DataBase" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GeradorBlocoX_DataBase.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_GeradorBlocoX_DataBase" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GeradorBlocoX_DataBase.exe" enable=yes
@Echo Liberando permissao em GerenciadorBlocoX
Echo off
netsh advfirewall firewall add rule name="GerenciadorBlocoX" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\GerenciadorBlocoX.exe" enable=yes
netsh advfirewall firewall add rule name="GerenciadorBlocoX" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\GerenciadorBlocoX.exe" enable=yes
@Echo Liberando permissao em AltShop_GerenciadorNotas
Echo off
netsh advfirewall firewall add rule name="AltShop_GerenciadorNotas" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GerenciadorNotas.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_GerenciadorNotas" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GerenciadorNotas.exe" enable=yes
@Echo Liberando permissao em ImpOffLine
Echo off
netsh advfirewall firewall add rule name="ImpOffLine" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\ImpOffLine.exe" enable=yes
netsh advfirewall firewall add rule name="ImpOffLine" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\ImpOffLine.exe" enable=yes
@Echo Liberando permissao em ExpOffLine
Echo off
netsh advfirewall firewall add rule name="ExpOffLine" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\ExpOffLine.exe" enable=yes
netsh advfirewall firewall add rule name="ExpOffLine" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\ExpOffLine.exe" enable=yes
@Echo Liberando permissao em AltShop_ConfigBasePadrao
Echo off
netsh advfirewall firewall add rule name="AltShop_ConfigBasePadrao" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_ConfigBasePadrao.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_ConfigBasePadrao" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_ConfigBasePadrao.exe" enable=yes
@Echo Liberando permissao em AltShopConfCegaPDV
Echo off
netsh advfirewall firewall add rule name="AltShopConfCegaPDV" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShopConfCegaPDV.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopConfCegaPDV" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShopConfCegaPDV.exe" enable=yes
@Echo Liberando permissao em servidorOffLineGuardian
Echo off
netsh advfirewall firewall add rule name="ServidorOffLineGuardian" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\ServidorOffLineGuardian.exe" enable=yes
netsh advfirewall firewall add rule name="ServidorOffLineGuardian" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\ServidorOffLineGuardian.exe" enable=yes
@Echo Liberando permissao em AltShop_GeradorCargaBalancaPDV
Echo off
netsh advfirewall firewall add rule name="AltShop_GeradorCargaBalancaPDV" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GeradorCargaBalancaPDV.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_GeradorCargaBalancaPDV" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GeradorCargaBalancaPDV.exe" enable=yes
@Echo Liberando permissao em AltShop_GeradorMovimentoECF
Echo off
netsh advfirewall firewall add rule name="AltShop_GeradorMovimentoECF" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GeradorMovimentoECF.exe" enable=yes
netsh advfirewall firewall add rule name="AltShop_GeradorMovimentoECF" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GeradorMovimentoECF.exe" enable=yes
@Echo Liberando permissao em AltShopProc_EntradaProducao
Echo off
netsh advfirewall firewall add rule name="AltShopProc_EntradaProducao" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShopProc_EntradaProducao.exe" enable=yes
netsh advfirewall firewall add rule name="AltShopProc_EntradaProducao" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShopProc_EntradaProducao.exe" enable=yes
@Echo Liberando permissao em TMVirtualPortDriver860a
Echo off
netsh advfirewall firewall add rule name="TMVirtualPortDriver860a" dir=in action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\TMVirtualPortDriver860a.exe" enable=yes
netsh advfirewall firewall add rule name="TMVirtualPortDriver860a" dir=out action=allow program="C:\Program Files (x86)\Alterdata\PDV Alterdata\TMVirtualPortDriver860a.exe" enable=yes
@Echo Liberando permissao em 
Echo off
netsh advfirewall firewall add rule name="IntegradorPreVendaPDV" dir=in action=allow program="C:\Program Files (x86)\Alterdata\OrcamentoOffline\IntegradorPreVendaPDV.exe" enable=yes
netsh advfirewall firewall add rule name="IntegradorPreVendaPDV" dir=out action=allow program="C:\Program Files (x86)\Alterdata\OrcamentoOffline\IntegradorPreVendaPDV.exe" enable=yes
@Echo Liberando permissao em Alterdata.OrcamentoOffline
Echo off
netsh advfirewall firewall add rule name="Alterdata.OrcamentoOffline" dir=in action=allow program="C:\Program Files (x86)\Alterdata\OrcamentoOffline\Alterdata.OrcamentoOffline.exe" enable=yes
netsh advfirewall firewall add rule name="Alterdata.OrcamentoOffline" dir=out action=allow program="C:\Program Files (x86)\Alterdata\OrcamentoOffline\Alterdata.OrcamentoOffline.exe" enable=yes
@Echo Liberando permissao em OrcamentoOffLineAdmin
Echo off
netsh advfirewall firewall add rule name="OrcamentoOffLineAdmin" dir=in action=allow program="C:\Program Files (x86)\Alterdata\OrcamentoOffline\OrcamentoOffLineAdmin.exe" enable=yes
netsh advfirewall firewall add rule name="OrcamentoOffLineAdmin" dir=out action=allow program="C:\Program Files (x86)\Alterdata\OrcamentoOffline\OrcamentoOffLineAdmin.exe" enable=yes
@Echo Liberando permissao em ISSEasy
Echo off
netsh advfirewall firewall add rule name="ISSEasy" dir=in action=allow program="C:\Program Files (x86)\Alterdata\ISS-Easy\ISSEasy.exe" enable=yes
netsh advfirewall firewall add rule name="ISSEasy" dir=out action=allow program="C:\Program Files (x86)\Alterdata\ISS-Easy\ISSEasy.exe" enable=yes
@Echo Liberando permissao em GuardiaoISSEasy
Echo off
netsh advfirewall firewall add rule name="GuardiaoISSEasy" dir=in action=allow program="C:\Program Files (x86)\Alterdata\ISS-Easy\GuardiaoISSEasy.exe" enable=yes
netsh advfirewall firewall add rule name="GuardiaoISSEasy" dir=out action=allow program="C:\Program Files (x86)\Alterdata\ISS-Easy\GuardiaoISSEasy.exe" enable=yes
@Echo Liberando permissao em RegAsm
Echo off
netsh advfirewall firewall add rule name="RegAsm" dir=in action=allow program="C:\Program Files (x86)\Alterdata\ISS-Easy\RegAsm.exe" enable=yes
netsh advfirewall firewall add rule name="RegAsm" dir=out action=allow program="C:\Program Files (x86)\Alterdata\ISS-Easy\RegAsm.exe" enable=yes
Echo off



@Echo Inserindo sites necessarios como confiaveis para funcionamento do sistema.
Echo off
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://nfeasy-admin.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://services.nfstock.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://www.alterdatatecnologia.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://dfe.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://nfeasy.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://e-api.alterdata.com.br/api/bimer/v1" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.karoo.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://widget.karoo.com.br/c/275" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.pusher.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.pusherapp.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.amazonaws.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.newrelic.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.userreport.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.bam.nr-data.net" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.mandrillapp.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.mailchimp.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.vipera.io" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://www.alterdata.com.br/" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://www.passaporte2.alterdata.com.br/" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://www.passaporte.alterdata.com.br/" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.comodoca.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.usertrust.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.amazonaws.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.jrsoftware.org" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://*.comodo.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://updatecenter.alterdatasoftware.com.br/api/v1/licenca-web /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://livedesktop.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.alterdatatecnologia.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.karoo.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://wscards.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://tempuri.org" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://schemas.microsoft.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://kb.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.portalfiscal.inf.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://api-shop-feedback.alterdatasoftware.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://taxadvisor.consultatributaria.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://parceiro.scanntech.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://parceiro1.scanntech.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://parceiro2.scanntech.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://test.parceiro.scanntech.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://superpack.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://universosped.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://updatecenter.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://livechat.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://ajuda.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://m.correios.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.receita.fazenda.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://services.nfstock.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.nfe.fazenda.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://wsishop.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://telemetria.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.correios.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://cards.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://express.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://loja.4keep.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://wspackweb.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://cargatributaria.supershop.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://conhecimento.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://webservices.sef.sc.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://webservices.sathomologa.sef.sc.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://sefaznet.ac.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://nfce.sefaz.al.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://sistemas.sefaz.am.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://nfe.sefaz.ba.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://nfce.sefaz.ce.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://dec.fazenda.df.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://app.sefaz.es.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://nfe.sefaz.go.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.nfce.sefaz.ma.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.sefaz.mt.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://appnfc.sefa.pa.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://www5.receita.pb.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://webas.sefaz.pi.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.sped.fazenda.pr.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www4.fazenda.rj.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://nfce.set.rn.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.nfce.sefin.ro.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://www.sefaz.rr.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://www.sefaz.rs.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.nfe.se.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://www.nfce.fazenda.sp.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.fazenda.sp.gov.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://passad.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://wspassad.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://help.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://images.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://www.spicesoftware.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\http://spice-cardapiodigital.alterdatasoftware.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://passaporte2.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://ajuda.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://viacep.com.br/ws" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://log-shop.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://contas.pack.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://pos-api.ifood.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://delivery-dev.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://static-images.ifood.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://delivery-hml.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://meiospagamento.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://bimer-lisa.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://contas-service-nfstock.alterdatasoftware.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://www.receitaws.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://sms.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://telemetria.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://muven-api.c2bsoftware.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://player.vimeo.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://accounts.c2bsoftware.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://delivery.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://empresas.btgpactual.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://dws-shop.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://web.whatsapp.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://www.java.com" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\https://contas.pack.alterdata.com.br" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.am.gov.br/services2/services/NfeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.am.gov.br/services2/services/NfeConsulta4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.am.gov.br/services2/services/NfeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.am.gov.br/services2/services/RecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.am.gov.br/services2/services/NfeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ba.gov.br/webservices/NFeInutilizacao4/NFeInutilizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ba.gov.br/webservices/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ba.gov.br/webservices/NFeStatusServico4/NFeStatusServico4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ba.gov.br/webservices/CadConsultaCadastro4/CadConsultaCadastro4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ba.gov.br/webservices/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ba.gov.br/webservices/NFeAutorizacao4/NFeAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ba.gov.br/webservices/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.go.gov.br/nfe/services/NFeInutilizacao4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.go.gov.br/nfe/services/NFeConsultaProtocolo4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.go.gov.br/nfe/services/NFeStatusServico4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.go.gov.br/nfe/services/CadConsultaCadastro4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.go.gov.br/nfe/services/NFeRecepcaoEvento4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.go.gov.br/nfe/services/NFeAutorizacao4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.go.gov.br/nfe/services/NFeRetAutorizacao4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.mg.gov.br/nfe2/services/NFeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.mg.gov.br/nfe2/services/NFeConsultaProtocolo4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.mg.gov.br/nfe2/services/NFeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.mg.gov.br/nfe2/services/CadConsultaCadastro4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.mg.gov.br/nfe2/services/NFeRecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.mg.gov.br/nfe2/services/NFeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.mg.gov.br/nfe2/services/NFeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ms.gov.br/ws/NFeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ms.gov.br/ws/NFeConsultaProtocolo4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ms.gov.br/ws/NFeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ms.gov.br/ws/CadConsultaCadastro4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ms.gov.br/ws/NFeRecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ms.gov.br/ws/NFeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ms.gov.br/ws/NFeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeConsultaProtocolo4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeRecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefa.pr.gov.br/nfe/NFeInutilizacao4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefa.pr.gov.br/nfe/NFeConsultaProtocolo4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefa.pr.gov.br/nfe/NFeStatusServico4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefa.pr.gov.br/nfe/CadConsultaCadastro4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefa.pr.gov.br/nfe/NFeRecepcaoEvento4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefa.pr.gov.br/nfe/NFeAutorizacao4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefa.pr.gov.br/nfe/NFeRetAutorizacao4?wsdl" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://cad.sefazrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.sp.gov.br/ws/cadconsultacadastro4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.sp.gov.br/ws/nfeautorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.fazenda.sp.gov.br/ws/nferetautorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www.sefazvirtual.fazenda.gov.br/NFeInutilizacao4/NFeInutilizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www.sefazvirtual.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www.sefazvirtual.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www.sefazvirtual.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www.sefazvirtual.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www.sefazvirtual.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www.svc.fazenda.gov.br/NFeInutilizacao4/NFeInutilizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www.svc.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www.svc.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www.svc.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www.svc.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www.svc.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://www.nfe.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.am.gov.br/nfce-services/services/NfeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.am.gov.br/nfce-services/services/NfeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.am.gov.br/nfce-services/services/NfeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://nfce.sefaz.am.gov.br/nfce-services/services/NfeConsulta4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.am.gov.br/nfce-services/services/NfeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.am.gov.br/nfce-services/services/RecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homnfce.sefaz.am.gov.br/nfce-services/services/NfeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homnfce.sefaz.am.gov.br/nfce-services/services/NfeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homnfce.sefaz.am.gov.br/nfce-services/services/NfeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://homnfce.sefaz.am.gov.br/nfce-services/services/NfeConsulta4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homnfce.sefaz.am.gov.br/nfce-services/services/NfeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homnfce.sefaz.am.gov.br/nfce-services/services/RecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.go.gov.br/nfe/services/NFeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.go.gov.br/nfe/services/NFeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.go.gov.br/nfe/services/NFeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://nfe.sefaz.go.gov.br/nfe/services/NFeConsultaProtocolo4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.go.gov.br/nfe/services/NFeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.go.gov.br/nfe/services/CadConsultaCadastro4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.go.gov.br/nfe/services/NFeRecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homolog.sefaz.go.gov.br/nfe/services/NFeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homolog.sefaz.go.gov.br/nfe/services/NFeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homolog.sefaz.go.gov.br/nfe/services/NFeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://homolog.sefaz.go.gov.br/nfe/services/NFeConsultaProtocolo4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homolog.sefaz.go.gov.br/nfe/services/NFeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homolog.sefaz.go.gov.br/nfe/services/CadConsultaCadastro4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homolog.sefaz.go.gov.br/nfe/services/NFeRecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.ms.gov.br/ws/NFeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.ms.gov.br/ws/NFeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.ms.gov.br/ws/NFeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://nfce.sefaz.ms.gov.br/ws/NFeConsultaProtocolo4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.ms.gov.br/ws/NFeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfe.sefaz.ms.gov.br/ws/CadConsultaCadastro4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.ms.gov.br/ws/NFeRecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://hom.nfce.sefaz.ms.gov.br/ws/NFeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://hom.nfce.sefaz.ms.gov.br/ws/NFeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://hom.nfce.sefaz.ms.gov.br/ws/NFeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://hom.nfce.sefaz.ms.gov.br/ws/NFeConsultaProtocolo4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://hom.nfce.sefaz.ms.gov.br/ws/NFeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://hom.nfe.sefaz.ms.gov.br/ws/CadConsultaCadastro4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://hom.nfce.sefaz.ms.gov.br/ws/NFeRecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.mt.gov.br/nfcews/services/NfeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.mt.gov.br/nfcews/services/NfeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.mt.gov.br/nfcews/services/NfeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://nfce.sefaz.mt.gov.br/nfcews/services/NfeConsulta4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.mt.gov.br/nfcews/services/NfeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefaz.mt.gov.br/nfcews/services/RecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeConsulta4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.sefaz.mt.gov.br/nfcews/services/RecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefa.pr.gov.br/nfce/NFeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefa.pr.gov.br/nfce/NFeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefa.pr.gov.br/nfce/NFeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://nfce.sefa.pr.gov.br/nfce/NFeConsultaProtocolo4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefa.pr.gov.br/nfce/NFeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefa.pr.gov.br/nfce/CadConsultaCadastro4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefa.pr.gov.br/nfce/NFeRecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeRetAutorizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeInutilizacao4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeConsultaProtocolo4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeStatusServico4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.nfce.sefa.pr.gov.br/nfce/CadConsultaCadastro4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeRecepcaoEvento4" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://nfce.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce-homologacao.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce-homologacao.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.fazenda.sp.gov.br/ws/NFeAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.fazenda.sp.gov.br/ws/NFeRetAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.fazenda.sp.gov.br/ws/NFeInutilizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://nfce.fazenda.sp.gov.br/ws/NFeConsultaProtocolo4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.fazenda.sp.gov.br/ws/NFeStatusServico4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.fazenda.sp.gov.br/ws/NFeRecepcaoEvento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeRetAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeInutilizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeConsultaProtocolo4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeStatusServico4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeRecepcaoEvento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://nfce.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\4.00https://nfce-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\InternetSettings\ZoneMap\Domains\https://nfce-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" /v http /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print" /v RpcAuthnLevelPrivacyEnabled /t REG_DWORD /d 0 /f



@Echo Liberando permissoes nas pasta criadas e utilizadas pelo sistema Alterdata:
Echo off
icacls "C:\ALTERDAT" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\ProgramData\Alterdata" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files (x86)\Alterdata" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\DadosNFeasy" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Backup" /grant:r "Todos":(OI)(CI)F /t
icacls "C:\Program Files (x86)\PostgreSQL" /grant:r "Todos":(OI)(CI)F /t

C:\windows\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /codebase "C:\Program Files (x86)\Alterdata\Updater\bin\UpdaterSecurityCom.dll"
C:\windows\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe /codebase "C:\Program Files\Alterdata\Updater\bin\UpdaterSecurityCom.dll"

@Echo Ajuste de formato numericos:
Echo off
reg add "HKCU\Control Panel\International" /v sShortDate /d "dd/MM/yyyy" /f
reg add "HKCU\Control Panel\International" /v sLongDate /d "dddddddddddddddddddddd, dd 'de 'MMMM' de 'yyyy" /f
reg add "HKCU\Control Panel\International" /v sTimeFormat /d "HH:mm" /f
reg add "HKCU\Control Panel\International" /v sLongTimeFormat /d "HH:mm:ss" /f
reg add "HKCU\Control Panel\International" /v iFirstDayOfWeek /d 7 /f
reg add "HKCU\Control Panel\International" /v sDecimal /d "," /f
reg add "HKCU\Control Panel\International" /v iDigits /d 2 /f
reg add "HKCU\Control Panel\International" /v sThousand /d "." /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /V EnableLUA /T REG_DWORD /D 0 /F
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Alterdata\ExpOffLine" /v "Ativo" /t REG_SZ /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Alterdata\ExpOffLine" /v "HabilitaTimeOut" /t REG_DWORD /d 00000001 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Alterdata\ExpOffLine" /v "TimeOut" /t REG_DWORD /d 30 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Alterdata\impOffLine" /v "Ativo" /t REG_SZ /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Alterdata\impOffLine" /v "HabilitaTimeOut" /t REG_DWORD /d 00000001 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Alterdata\impOffLine" /v "TimeOut" /t REG_DWORD /d 30 /f




@Echo ************************************************************************************
@Echo * Ajuste de fuso horario:                                                          *
@Echo * O sistema Alterdata precisa que o Fuso horario, esteja correto no seu computador *
@Echo ************************************************************************************
Echo off
tzutil /s "E. South America Standard Time"
      
      


Echo Liberada todas as permissões!
timeout /t 5

cls
goto reinicio







:: --------------------------------------------------------------------------------------------------------------













:: Deixa todos os executáveis executando como ADM

:Exe_como_adm

cls

color 2

:: Lista de caminhos dos executáveis SHOP
set ADMSHOP="C:\Program Files (x86)\Alterdata\shop\AdminEmissaoOtimizada.exe" "C:\Program Files (x86)\Alterdata\shop\Admin_Administracao4Middleware.exe" "C:\Program Files (x86)\Alterdata\shop\altcashproc_dre.exe" "C:\Program Files (x86)\Alterdata\shop\AlterAgente.exe" "C:\Program Files (x86)\Alterdata\shop\AlterAgenteGuardian.exe" "C:\Program Files (x86)\Alterdata\shop\altshopanalisedesempenhovendedor.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopAnaliseFechamentoCaixa.exe" "C:\Program Files (x86)\Alterdata\shop\altshopconfig_pdvalterdata.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopConfig_Spice.exe" "C:\Program Files (x86)\Alterdata\shop\altshopimpressaocarne.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopOrdemServicoConfig.exe" "C:\Program Files (x86)\Alterdata\shop\altshopordemservicoentrada.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProcExtratorXML.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_AlinhamentoTransacaoPendenteIShop.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_AlinhamentoTransacaoPendenteWShop.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_AlterarStatusMonitor.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_AtualizarDocNFeIShop.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_AtualizarDocNFeWShop.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_AuditorEventos.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_AVARElatorios.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_BIDocumentos.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_BI_Analise.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_BoletoExpress_Integrador.exe" "C:\Program Files (x86)\Alterdata\shop\altshopproc_cadastroempresas.exe" "C:\Program Files (x86)\Alterdata\shop\altshopproc_cadastroprodutos.exe" "C:\Program Files (x86)\Alterdata\shop\altshopproc_cadastroprodutosspice.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_CadastroTransportador.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_ConfiguraServicoNFStock.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_ConsultaTitulos.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_ControleEntregas_Expedicao.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_ControleRomaneio.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_Delivery.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_Devolucao.exe" "C:\Program Files (x86)\Alterdata\shop\altshopproc_entradaproducao.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_FerramentasCadastroCliente.exe" "C:\Program Files (x86)\Alterdata\shop\altshopproc_financeiro.exe" "C:\Program Files (x86)\Alterdata\shop\altshopproc_maladireta.exe" "C:\Program Files (x86)\Alterdata\shop\altshopproc_manutencaoprodutos.exe" "C:\Program Files (x86)\Alterdata\shop\altshopproc_movestoqueotimizado.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_Sincronizador4Keep.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_Tesouraria.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopProc_ValidadeProduto.exe" "C:\Program Files (x86)\Alterdata\shop\altshoprelanalisecontasareceberporvendedor.exe" "C:\Program Files (x86)\Alterdata\shop\altshoprelatorioinventario.exe" "C:\Program Files (x86)\Alterdata\shop\altshoprelclientesgeral.exe" "C:\Program Files (x86)\Alterdata\shop\altshopreldocumentos.exe" "C:\Program Files (x86)\Alterdata\shop\altshoprelextratoprodutos.exe" "C:\Program Files (x86)\Alterdata\shop\altshoprel_comissao.exe" "C:\Program Files (x86)\Alterdata\shop\altshoprel_comissionamentoativacao.exe" "C:\Program Files (x86)\Alterdata\shop\altshoprel_comparativovendas.exe" "C:\Program Files (x86)\Alterdata\shop\altshoprel_contasreceberpagar.exe" "C:\Program Files (x86)\Alterdata\shop\altshoprel_fichadoproduto.exe" "C:\Program Files (x86)\Alterdata\shop\altshoprel_movcaixausuario.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopRel_MovimentosTerminal.exe" "C:\Program Files (x86)\Alterdata\shop\altshoprel_quadrovendadiaria.exe" "C:\Program Files (x86)\Alterdata\shop\AltShopRel_ResumoDoDia.exe" "C:\Program Files (x86)\Alterdata\shop\altshoprel_simplificadodeprodutos.exe" "C:\Program Files (x86)\Alterdata\shop\AltShop_AVA.exe" "C:\Program Files (x86)\Alterdata\shop\AltShop_Configuracoes.exe" "C:\Program Files (x86)\Alterdata\shop\AltShop_DashBoard.exe" "C:\Program Files (x86)\Alterdata\shop\AltShop_GerenciadorNotas.exe" "C:\Program Files (x86)\Alterdata\shop\AltShop_GerenteEletronico.exe" "C:\Program Files (x86)\Alterdata\shop\AltShop_InutilizacaoFaixaNFCe.exe" "C:\Program Files (x86)\Alterdata\shop\AltShop_SincronizadorScanntech.exe" "C:\Program Files (x86)\Alterdata\shop\AltShop_SincronizadorScanntechGuardian.exe" "C:\Program Files (x86)\Alterdata\shop\CotacaoAdmin.exe" "C:\Program Files (x86)\Alterdata\shop\CotacaoAdminIshop.exe" "C:\Program Files (x86)\Alterdata\shop\ExecuteDll.exe" "C:\Program Files (x86)\Alterdata\shop\IAdminEmissaoOtimizada.exe" "C:\Program Files (x86)\Alterdata\shop\IAdmin_Administracao4Middleware.exe" "C:\Program Files (x86)\Alterdata\shop\IAgendaAdmin.exe" "C:\Program Files (x86)\Alterdata\shop\IDelivery.exe" "C:\Program Files (x86)\Alterdata\shop\IOrcAdmin.exe" "C:\Program Files (x86)\Alterdata\shop\ishop.exe" "C:\Program Files (x86)\Alterdata\shop\MonitorIntegracao.exe" "C:\Program Files (x86)\Alterdata\shop\OrdemServicoIshop.exe" "C:\Program Files (x86)\Alterdata\shop\OSAdmin.exe" "C:\Program Files (x86)\Alterdata\shop\Shell.exe" "C:\Program Files (x86)\Alterdata\shop\vcredist_x86.exe" "C:\Program Files (x86)\Alterdata\shop\WAgendaAdmin.exe" "C:\Program Files (x86)\Alterdata\shop\wcash.exe" "C:\Program Files (x86)\Alterdata\shop\WDelivery.exe" "C:\Program Files (x86)\Alterdata\shop\winv.exe" "C:\Program Files (x86)\Alterdata\shop\WorcAdmin.exe" "C:\Program Files (x86)\Alterdata\shop\WOrc_2005.exe" "C:\Program Files (x86)\Alterdata\shop\WSched.exe" "C:\Program Files (x86)\Alterdata\shop\Wshop.exe" "C:\Program Files (x86)\Alterdata\shop\WToten.exe"

set ADMSPICE_CONCENTRADOR_PDV="C:\Program Files (x86)\Alterdata\spice\altshopproc_entradaproducao.exe" "C:\Program Files (x86)\Alterdata\spice\AltShopProc_VerificaComanda.exe" "C:\Program Files (x86)\Alterdata\spice\AltShop_ConfigBasePadrao.exe" "C:\Program Files (x86)\Alterdata\spice\Altshop_EnvioCupomFiscal.exe" "C:\Program Files (x86)\Alterdata\spice\AltShop_GerenciadorNotas.exe" "C:\Program Files (x86)\Alterdata\spice\AltShop_IntegradorSpice.exe" "C:\Program Files (x86)\Alterdata\spice\AltShop_InutilizacaoFaixaNFCe.exe" "C:\Program Files (x86)\Alterdata\spice\AltShop_PopularBasePostgresSpice.exe" "C:\Program Files (x86)\Alterdata\spice\AltShop_SpiceDelivery.exe" "C:\Program Files (x86)\Alterdata\spice\ExpOffLine.exe" "C:\Program Files (x86)\Alterdata\spice\ImpOffLine.exe" "C:\Program Files (x86)\Alterdata\spice\IntegradorSpiceGuardian.exe" "C:\Program Files (x86)\Alterdata\spice\PinPadFinder.exe" "C:\Program Files (x86)\Alterdata\spice\ServidorOffLine.exe" "C:\Program Files (x86)\Alterdata\spice\ServidorOffLineGuardian.exe" "C:\Program Files (x86)\Alterdata\spice\Spice.exe" "C:\Program Files (x86)\Alterdata\concentrador\StartVB.exe" "C:\Program Files (x86)\Alterdata\concentrador\Exe\IntegradorPDV\AltShopConfCegaPDV.exe" "C:\Program Files (x86)\Alterdata\concentrador\Exe\IntegradorPDV\AltShopConfigSrvPDV.exe" "C:\Program Files (x86)\Alterdata\concentrador\Exe\IntegradorPDV\AltShopServicePDV.exe" "C:\Program Files (x86)\Alterdata\concentrador\Exe\IntegradorPDV\AltShoP_GeradorCargaBalancaPDV.exe" "C:\Program Files (x86)\Alterdata\concentrador\Exe\IntegradorPDV\AltShop_ImpressaoEtiquetasOffLine.exe" "C:\Program Files (x86)\Alterdata\concentrador\Exe\IntegradorPDV\ConcentradorGuardian.exe" "C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShopConfCegaPDV.exe" "C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShopProc_EntradaProducao.exe" "C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_ConfigBasePadrao.exe" "C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GeradorBlocoX_DataBase.exe" "C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GeradorCargaBalancaPDV.exe" "C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GeradorMovimentoECF.exe" "C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GerenciadorNotas.exe" "C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_InutilizacaoFaixaNFCe.exe" "C:\Program Files (x86)\Alterdata\PDV Alterdata\GerenciadorBlocoX.exe" "C:\Program Files (x86)\Alterdata\PDV Alterdata\LiberaECF.exe" "C:\Program Files (x86)\Alterdata\PDV Alterdata\PdvAlterdata.exe" "C:\Program Files (x86)\Alterdata\PDV Alterdata\PinPadFinder.exe" "C:\Program Files (x86)\Alterdata\PDV Alterdata\Impressora Blindada\Epson\TMVirtualPortDriver860a.exe" "C:\Program Files (x86)\Alterdata\Spice\SpiceLight.exe" "C:\Program Files (x86)\Alterdata\Spice_LIGHT\AltShop_ExtratorXmlSpiceLight.exe"

:: Lista de caminhos dos executáveis SPICE/PACK/IMMOBILE
set ADMPACK="C:\Program Files (x86)\Alterdata\pack\Diamond\ALTERDATAPACK\AlterdataPack.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\ALTERDATAPACK\altpack_packonline_shell.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Ativo\wativo.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\BANK\WBank.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\CIAP\WCIAP.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Contabil\wcont.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\DP\wdp.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Financeiro\financeiro.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_ajuste_movimento_pis_cofins.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_impiss.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_importador_fat_ded.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_importa_iss.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_proc_das.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_proc_destda.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_proc_dmed.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_proc_giam_to.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_proc_impcat52.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_proc_impmovimentonotas_e_iss.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_proc_importanfe.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_proc_simei.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_proc_sped.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_proc_sped_pis_cofins.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_relduplicatas.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altpack_wfiscal_rel_dasn.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\AltWfiscalDIEF.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altwfiscalin86_2001.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\altwfiscal_dctf.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\importasintegra.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Fiscal\wfiscal.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Modulos\AltModuleReports.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\PackCRM\PackCRM.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\PACKTAREFAS\PackTarefas.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Ponto\altpack_wpontosrep_agente_impafd.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Ponto\WPontoSREP.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\RH\Wrh.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\SCAN\WScan.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\ava_portable\convert_ava.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\geckodriver.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\ava_portable\App\AVA\32\ava_recaptcha.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\ava_portable\App\AVA\32\chrome_proxy.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\ava_portable\App\AVA\32\nacl64.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\ava_portable\App\AVA\32\notification_helper.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\bin\dejsonlz4.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\bin\jsonlz4.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\bin\sqlite3.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\Firefox64\crashreporter.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\Firefox64\default-browser-agent.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\Firefox64\firefox.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\Firefox64\maintenanceservice.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\Firefox64\maintenanceservice_installer.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\Firefox64\minidump-analyzer.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\Firefox64\pingsender.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\Firefox64\plugin-container.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\Firefox64\plugin-hang-ui.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\Firefox64\updater.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\firefox-portable\App\Firefox64\uninstall\helper.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\jabswitch.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\java-rmi.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\java.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\javacpl.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\javaw.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\javaws.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\jjs.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\jp2launcher.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\keytool.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\kinit.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\klist.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\ktab.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\orbd.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\pack200.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\policytool.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\rmid.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\rmiregistry.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\servertool.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\ssvagent.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\tnameserv.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\bin\unpack200.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\firefox-portable\App\Bin\sqlite3.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\firefox-portable\App\Firefox\crashreporter.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\firefox-portable\App\Firefox\firefox.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\firefox-portable\App\Firefox\maintenanceservice.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\firefox-portable\App\Firefox\maintenanceservice_installer.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\firefox-portable\App\Firefox\plugin-container.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\firefox-portable\App\Firefox\plugin-hang-ui.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\firefox-portable\App\Firefox\updater.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\firefox-portable\App\Firefox\webapp-uninstaller.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\firefox-portable\App\Firefox\webapprt-stub.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\firefox-portable\App\Firefox\wow_helper.exe" "C:\Program Files (x86)\Alterdata\pack\Diamond\Biblioteca\jre\jre\firefox-portable\App\Firefox\uninstall\helper.exe"

set ADMPACK2="C:\Program Files (x86)\Alterdata\pack\Diamond\Util\Cfg\CopySys32.exe"

set ADMBACKUP="C:\Program Files (x86)\Alterdata\Backup-Service\7za.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\alterdatabackupserver.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\nssm.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\sqlite3.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\unins000.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\Postgres-x32\createdb.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\Postgres-x32\createuser.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\Postgres-x32\pg_dump.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\Postgres-x32\pg_isready.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\Postgres-x32\pg_restore.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\Postgres-x32\psql.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\Postgres-x64\createdb.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\Postgres-x64\createuser.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\Postgres-x64\pg_dump.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\Postgres-x64\pg_isready.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\Postgres-x64\pg_restore.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\Postgres-x64\psql.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\win-ia32-unpacked\alterdatabackup.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\win32\nssm.exe" "C:\Program Files (x86)\Alterdata\Backup-Service\win64\nssm.exe"

set ADMIMMOBILE="C:\Program Files (x86)\Alterdata\Immobile\Diamond\Bibliotecas\InstaladorBibliotecasAlterdata.exe" "C:\Program Files (x86)\Alterdata\Immobile\Diamond\Bibliotecas\unins000.exe" "C:\Program Files (x86)\Alterdata\Immobile\Diamond\Condominio\ImmobileCondominio.exe" "C:\Program Files (x86)\Alterdata\Immobile\Diamond\Condominio\openssl.exe" "C:\Program Files (x86)\Alterdata\Immobile\Diamond\Condominio\unins000.exe" "C:\Program Files (x86)\Alterdata\Immobile\Diamond\Diagnostico\ImmobileDiagnostico.exe" "C:\Program Files (x86)\Alterdata\Immobile\Diamond\Diagnostico\unins000.exe" "C:\Program Files (x86)\Alterdata\Immobile\Diamond\Locacao\ImmobileLocacao.exe" "C:\Program Files (x86)\Alterdata\Immobile\Diamond\Locacao\unins000.exe"

set ADMOUTROS="C:\Program Files (x86)\Alterdata\Cirrus\Updater Diagnostico\DConsole.exe" "C:\Program Files (x86)\Alterdata\Cirrus\Updater Diagnostico\Uninstall Updater Diagnostico.exe" "C:\Program Files (x86)\Alterdata\Cirrus\Updater Diagnostico\Updater Diagnostico.exe" "C:\Program Files (x86)\Alterdata\Cirrus\Updater Diagnostico\resources\elevate.exe" "C:\Program Files (x86)\Alterdata\Modulos\AltConfigDBDiamond.exe" "C:\Program Files (x86)\Alterdata\Modulos\AltModuloRegistradorShop.exe" "C:\Program Files (x86)\Alterdata\Modulos\AltRegModGroupShop.exe" "C:\Program Files (x86)\Alterdata\Modulos\EurekaLog_Viewer.exe" "C:\Program Files (x86)\Alterdata\PgGuardian\PgGuardianInstall.exe" "C:\Program Files (x86)\Alterdata\PgGuardian\PgSQLGuardian.exe" "C:\Program Files (x86)\Alterdata\PgGuardian\pg_isready\pg_isready.exe" "C:\Program Files (x86)\Alterdata\PreVenda\Alterdata.PreVenda.exe" "C:\Program Files (x86)\Alterdata\Printsup\PrintSup.exe" "C:\Program Files (x86)\Alterdata\Uninstall\unins000.exe" "C:\Program Files (x86)\Alterdata\Uninstall\unins001.exe" "C:\Program Files (x86)\Alterdata\Uninstall\unins002.exe" "C:\Program Files (x86)\Alterdata\Updater\unins000.exe" "C:\Program Files (x86)\Alterdata\Updater\bin\Alterdata.Updater.ConsoleApp.exe" "C:\Program Files (x86)\Alterdata\Updater\bin\AlterdataAutoUpdate.exe" "C:\Program Files (x86)\Alterdata\Updater\bin\Guardian.exe" "C:\Program Files (x86)\Alterdata\Updater\bin\UpdaterManager.exe" "C:\Program Files (x86)\Alterdata\Updater-Guardian\nssm.exe" "C:\Program Files (x86)\Alterdata\Updater-Guardian\unins000.exe" "C:\Program Files (x86)\Alterdata\Updater-Guardian\updaterguardian.exe" "C:\Program Files (x86)\Alterdata\Updater-Guardian\win32\nssm.exe" "C:\Program Files (x86)\Alterdata\Updater-Guardian\win64\nssm.exe"

:: Verificador de falha e sucesso do programa
set falha=0
set sucesso=0
set arquivo_erro=

:: Deixa o SHOP para executar como ADM
for %%i in (%ADMSHOP%) do (
    Echo %%i Configurado para Executar como ADM.
    Echo.
    cmd /C "reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %%i /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1"
    if %errorlevel%==0 (
        set /A sucesso+=1
    )   else (
        set /A falha+=1
        set "arquivo_erro=%arquivo_erro% %%i"
    )
)

:: Deixa o SPICE e CONCENTRADOR para executar como ADM
for %%i in (%ADMSPICE_CONCENTRADOR_PDV%) do (
    Echo %%i Configurado para Executar como ADM.
    Echo.
    cmd /C "reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %%i /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1"
    if %errorlevel%==0 (
        set /A sucesso+=1
    )   else (
        set /A falha+=1
        set "arquivo_erro=%arquivo_erro% %%i"
    )
)



:: Deixa o PACK para executar como ADM
for %%i in (%ADMPACK%) do (
    Echo %%i Configurado para Executar como ADM.
    Echo.
    cmd /C "reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %%i /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1"
    if %errorlevel%==0 (
        set /A sucesso+=1
    )   else (
        set /A falha+=1
        set "arquivo_erro=%arquivo_erro% %%i"
    )
)

:: Continuação do PACK
for %%i in (%ADMPACK2%) do (
    Echo %%i Configurado para Executar como ADM.
    Echo.
    cmd /C "reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %%i /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1"
    if %errorlevel%==0 (
        set /A sucesso+=1
    )   else (
        set /A falha+=1
        set "arquivo_erro=%arquivo_erro% %%i"
    )
)

:: Deixa o BACKUP para executar como ADM
for %%i in (%ADMBACKUP%) do (
    Echo %%i Configurado para Executar como ADM.
    Echo.
    cmd /C "reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %%i /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1"
    if %errorlevel%==0 (
        set /A sucesso+=1
    )   else (
        set /A falha+=1
        set "arquivo_erro=%arquivo_erro% %%i"
    )
)

:: Deixa o IMMOBILE para executar como ADM
for %%i in (%ADMIMMOBILE%) do (
    Echo %%i Configurado para Executar como ADM.
    Echo.
    cmd /C "reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %%i /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1"
    if %errorlevel%==0 (
        set /A sucesso+=1
    )   else (
        set /A falha+=1
        set "arquivo_erro=%arquivo_erro% %%i"
    )
)
:: Deixa o updater, spicelight e outros executáveis para executar como ADM
for %%i in (%ADMOUTROS%) do (
    Echo %%i Configurado para Executar como ADM.
    Echo.
    cmd /C "reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %%i /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1"
    if %errorlevel%==0 (
        set /A sucesso+=1
    )   else (
        set /A falha+=1
        set "arquivo_erro=%arquivo_erro% %%i"
    )
)


:: Exibe os resultados do bat
Echo total de executáveis configurados: %sucesso%

if %falha% GTR 0 (
    Echo Total de executáveis com falha ao configurar: %falha%
    Echo Arquivos com falha:
    Echo %arquivo_erro%
)
   
timeout /t 4
cls
goto reinicio







:: --------------------------------------------------------------------------------------------------------------












:: Verifica se o Windows é 32 ou 64 bits e faz o registro de acordo com a verificação da existência do arquivo MIDAS.DLL

:Registra_Midas

openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    Echo Por favor, execute este script como administrador.
    pause
    exit /b
)

set "dll64=C:\Windows\SysWOW64\midas.dll"
set "dll32=C:\windows\System32\midas.dll"

if defined ProgramFiles(x86) (
    Echo Sistema Operacional: 64 bits

    if exist "%dll64%" (
        copy "C:\Program Files (x86)\Alterdata\Biblioteca\midas.dll" "C:\Windows\SysWOW64\"
        Regsvr32 C:\Windows\SysWOW64\midas.dll 
    ) else (
        Echo A DLL especificada nao foi encontrada: %dll64%
    )
) else (
    Echo Sistema Operacional: 32 bits
    if exist "%dll32%" (
        copy "C:\Program Files (x86)\Alterdata\Biblioteca\midas.dll" "C:\Windows\System32\"
        Regsvr32 C:\Windows\System32\midas.dll
    ) else (
        Echo A DLL especificada nao foi encontrada: %dll32%
    )
)

Echo Registro de DLL concluído.
timeout /t 4
cls
goto reinicio







:: --------------------------------------------------------------------------------------------------------------














:otimiza_banco
cls


Echo Buscando arquivos postgresql.conf no sistema...

:: Move para o diretório raiz do drive C:
cd /d C:\

:: Inicializa as variáveis
setlocal enabledelayedexpansion
set "contador=0"

:: Cria uma lista de arquivos encontrados
for /f "delims=" %%i in ('dir /s /b "postgresql.conf" 2^>nul') do (
    set /a contador+=1
    set "arquivo_!contador!=%%i"
)

:: Verifica se encontrou algum arquivo
if %contador%==0 (
    Echo Nenhum arquivo postgresql.conf encontrado no sistema.
    Echo.
    Echo Retornando ao Menu do bat...
    timeout /t 2
    goto menu
)

:lista_arquivos_postgresql
:: Lista os arquivos encontrados
Echo Foram encontrados %contador% arquivos postgresql.conf:
Echo.
Echo 0 - Voltar ao menu do Bat.
Echo ===============================================================
for /l %%j in (1,1,%contador%) do (
    Echo %%j - !arquivo_%%j!
)
Echo ===============================================================

:: Solicita ao usuário que selecione um arquivo
Echo.
set /p escolha="Digite o número correspondente ao arquivo desejado: "


:: Valida a escolha

if "%escolha%"=="0" (
    Echo Retornando ao menu...
    timeout /t 2
    goto menu
) else if not defined arquivo_%escolha% (
    cls
    Echo Opção inválida. O número digitado não corresponde a nenhum arquivo listado.
    Echo.
    goto lista_arquivos_postgresql
)

:: Define o arquivo escolhido
set "arquivo_Banco=!arquivo_%escolha%!"
cls
Echo Você selecionou o arquivo: "!arquivo_Banco!"
Echo.

:: Escolher Predefinição ou digitar os dados.
:menu_otimiza


Echo Escolha uma Opção.
Echo.
Echo 1 = Escolher Predefinições de otimização.
Echo 2 = Digitar valores para otimização.
Echo.
set opcao_otimizacao=
set /p opcao_otimizacao=Digite a opção: 

:: Verifica se a entrada está vazia
if "%opcao_otimizacao%"=="" (
    cls
    Echo Opção inválida. Tente novamente.
    Echo.
    goto menu_otimiza
) else if "%opcao_otimizacao%" == "1" (
    cls
    goto menu_predefinicao
    
) else if "%opcao_otimizacao%" == "2" (
    cls
    goto p1

) else (
    cls
    Echo Opção inválida. Tente novamente.
    Echo.
    goto menu_otimiza
)







:: --------------------------------------------------------------------------------------------------------------










:menu_predefinicao
:: Menu de opção com as predefinições de otimização.
Echo     Otimizar para 
Echo =====================
Echo * 1. 4  GB de ram   *
Echo * 2. 6  GB de ram   *
Echo * 3. 8  GB de ram   *
Echo * 4. 16 GB de ram   *
Echo =====================
Echo.
set opcao_predefinicao=
set /p opcao_predefinicao=Digite uma opção: 



if "%opcao_predefinicao%"=="" (
    Echo Opção inválida. Tente novamente.
    pause
    goto menu_predefinicao


REM OPÇÃO PARA 4 GB DE RAM
) else if "%opcao_predefinicao%" == "1" (
    :: Verifica se o arquivo 'postgresql.conf' existe
        if not exist "%arquivo_Banco%.bak" (
            :: faz uma cópia do arquivo para backup.
            copy "%arquivo_Banco%" "%arquivo_Banco%.bak"
            Echo Arquivo de backup criado em "%arquivo_Banco%.bak".
        
        ) else (
            Echo Arquivo de backup já existe, por isso não foi feito. Ele está em "%arquivo_Banco%.bak"
        
        )
    Echo Aplicando configurações...

    :: Max_connections
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#max_connections\s*=\s*\d+', 'max_connections = 100' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*max_connections\s*=\s*\d+', 'max_connections = 100' | Set-Content '%arquivo_Banco%'"
    
    :: Shared_buffers
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Shared_Buffers\s*=\s*\d+', 'Shared_Buffers = 400' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Shared_Buffers\s*=\s*\d+', 'Shared_Buffers = 400' | Set-Content '%arquivo_Banco%'"
    
    :: Work_Mem
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Work_Mem\s*=\s*\d+', 'Work_Mem = 10' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Work_Mem\s*=\s*\d+', 'Work_Mem = 10' | Set-Content '%arquivo_Banco%'"
    
    :: Maintenance_Work_Mem
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#maintenance_work_mem\s*=\s*\d+', 'maintenance_work_mem = 110' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*maintenance_work_mem\s*=\s*\d+', 'maintenance_work_mem = 110' | Set-Content '%arquivo_Banco%'"

    :: Max_Locks_Per_Transactions
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Max_Locks_Per_Transaction\s*=\s*\d+', 'Max_Locks_Per_Transaction = 300' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Max_Locks_Per_Transaction\s*=\s*\d+', 'Max_Locks_Per_Transaction = 300' | Set-Content '%arquivo_Banco%'"

    :: Vai pro final do comando agora
    cls
    Echo O arquivo postgresql.conf foi configurado da seguinte forma:
    Echo Max_Connections            = 100
    Echo Shared buffers             = 400 MB    
    Echo Work_Mem                   = 10 MB    
    Echo maintenance_work_mem       = 110 MB    
    Echo Max_Locks_Per_Transactions = 300
    Echo.
    goto Menu_banco



REM OPÇÃO PARA 6 GB DE RAM
) else if "%opcao_predefinicao%" == "2" (
    :: Verifica se o arquivo 'postgresql.conf' existe
        if not exist "%arquivo_Banco%.bak" (
            :: faz uma cópia do arquivo para backup.
            copy "%arquivo_Banco%" "%arquivo_Banco%.bak"
            Echo Arquivo de backup criado em "%arquivo_Banco%.bak".
        
        ) else (
            Echo Arquivo de backup já existe. Por isso não foi feito
        )
    Echo Aplicando configurações...
    :: Max_connections
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#max_connections\s*=\s*\d+', 'max_connections = 120' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*max_connections\s*=\s*\d+', 'max_connections = 120' | Set-Content '%arquivo_Banco%'"
    
    :: Shared_buffers
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Shared_Buffers\s*=\s*\d+', 'Shared_Buffers = 800' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Shared_Buffers\s*=\s*\d+', 'Shared_Buffers = 800' | Set-Content '%arquivo_Banco%'"
    
    :: Work_Mem
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Work_Mem\s*=\s*\d+', 'Work_Mem = 20' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Work_Mem\s*=\s*\d+', 'Work_Mem = 20' | Set-Content '%arquivo_Banco%'"
    
    :: Maintenance_Work_Mem
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#maintenance_work_mem\s*=\s*\d+', 'maintenance_work_mem = 210' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*maintenance_work_mem\s*=\s*\d+', 'maintenance_work_mem = 210' | Set-Content '%arquivo_Banco%'"

    :: Max_Locks_Per_Transactions
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Max_Locks_Per_Transaction\s*=\s*\d+', 'Max_Locks_Per_Transaction = 400' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Max_Locks_Per_Transaction\s*=\s*\d+', 'Max_Locks_Per_Transaction = 400' | Set-Content '%arquivo_Banco%'"

    :: Vai pro final do comando agora
    cls
    Echo O arquivo postgresql.conf foi configurado da seguinte forma:
    Echo Max_Connections            = 120
    Echo Shared buffers             = 800 MB    
    Echo Work_Mem                   = 20 MB    
    Echo maintenance_work_mem       = 210 MB    
    Echo Max_Locks_Per_Transactions = 400
    Echo.
    goto Menu_banco



REM OPÇÃO PARA 8 GB DE RAM
) else if "%opcao_predefinicao%" == "3" (
    :: Verifica se o arquivo 'postgresql.conf' existe
        if not exist "%arquivo_Banco%.bak" (
            :: faz uma cópia do arquivo para backup.
            copy "%arquivo_Banco%" "%arquivo_Banco%.bak"
            Echo Arquivo de backup criado em "%arquivo_Banco%.bak".
        
        ) else (
            Echo Arquivo de backup já existe. Por isso não foi feito
        )
    Echo Aplicando configurações...
    :: Max_connections
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#max_connections\s*=\s*\d+', 'max_connections = 150' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*max_connections\s*=\s*\d+', 'max_connections = 150' | Set-Content '%arquivo_Banco%'"
    
    :: Shared_buffers
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Shared_Buffers\s*=\s*\d+', 'Shared_Buffers = 1600' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Shared_Buffers\s*=\s*\d+', 'Shared_Buffers = 1600' | Set-Content '%arquivo_Banco%'"
    
    :: Work_Mem
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Work_Mem\s*=\s*\d+', 'Work_Mem = 40' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Work_Mem\s*=\s*\d+', 'Work_Mem = 40' | Set-Content '%arquivo_Banco%'"
    
    :: Maintenance_Work_Mem
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#maintenance_work_mem\s*=\s*\d+', 'maintenance_work_mem = 310' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*maintenance_work_mem\s*=\s*\d+', 'maintenance_work_mem = 310' | Set-Content '%arquivo_Banco%'"

    :: Max_Locks_Per_Transactions
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Max_Locks_Per_Transaction\s*=\s*\d+', 'Max_Locks_Per_Transaction = 400' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Max_Locks_Per_Transaction\s*=\s*\d+', 'Max_Locks_Per_Transaction = 400' | Set-Content '%arquivo_Banco%'"

    :: Vai pro final do comando agora
    cls

    Echo O arquivo postgresql.conf foi configurado da seguinte forma:
    Echo Max_Connections            = 150
    Echo Shared buffers             = 1600 MB    
    Echo Work_Mem                   = 40 MB    
    Echo maintenance_work_mem       = 310 MB    
    Echo Max_Locks_Per_Transactions = 400
    Echo.
    goto Menu_banco



REM OPÇÃO PARA 16 GB DE RAM
) else if "%opcao_predefinicao%" == "4" (
    :: Verifica se o arquivo 'postgresql.conf' existe
        if not exist "%arquivo_Banco%.bak" (
            :: faz uma cópia do arquivo para backup.
            copy "%arquivo_Banco%" "%arquivo_Banco%.bak"
            Echo Arquivo de backup criado em "%arquivo_Banco%.bak".
        
        ) else (
            Echo Arquivo de backup já existe. Por isso não foi feito. O Diretório do arquivo é %arquivo_Banco%.bak
        )
    Echo Aplicando configurações...
    :: Max_connections
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#max_connections\s*=\s*\d+', 'max_connections = 300' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*max_connections\s*=\s*\d+', 'max_connections = 300' | Set-Content '%arquivo_Banco%'"
    
    :: Shared_buffers
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Shared_Buffers\s*=\s*\d+', 'Shared_Buffers = 2900' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Shared_Buffers\s*=\s*\d+', 'Shared_Buffers = 2900' | Set-Content '%arquivo_Banco%'"
    
    :: Work_Mem
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Work_Mem\s*=\s*\d+', 'Work_Mem = 60' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Work_Mem\s*=\s*\d+', 'Work_Mem = 60' | Set-Content '%arquivo_Banco%'"
    
    :: Maintenance_Work_Mem
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#maintenance_work_mem\s*=\s*\d+', 'maintenance_work_mem = 700' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*maintenance_work_mem\s*=\s*\d+', 'maintenance_work_mem = 700' | Set-Content '%arquivo_Banco%'"

    :: Max_Locks_Per_Transactions
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Max_Locks_Per_Transaction\s*=\s*\d+', 'Max_Locks_Per_Transaction = 400' | Set-Content '%arquivo_Banco%'"
    powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Max_Locks_Per_Transaction\s*=\s*\d+', 'Max_Locks_Per_Transaction = 400' | Set-Content '%arquivo_Banco%'"

    :: Vai pro final do comando agora
    cls
    Echo O arquivo postgresql.conf foi configurado da seguinte forma:
    Echo Max_Connections            = 300
    Echo Shared buffers             = 2900 MB    
    Echo Work_Mem                   = 60 MB    
    Echo maintenance_work_mem       = 700 MB    
    Echo Max_Locks_Per_Transactions = 400
    Echo.

    goto Menu_banco


) else (
    cls
    Echo Opção Inválida
    Echo.
    goto menu_predefinicao
)





:: --------------------------------------------------------------------------------------------------------------













set "numeros=0123456789"
set letras=

:: pergunta para Max_Connectios
:p1

set letras=
set /p max_con= Digite o valor para 'Max_Connections': %=%
for /f "tokens=* delims=0123456789" %%a in ("%max_con%") do set "letras=%%a"
if defined letras (
    Echo Contém letras no valor, preencha apenas com números
    set max_con=
    Echo.
    goto p1
)



:: pergunta para Shared_Buffers
:p2

set letras=
set /p shared_buf= Digite o valor para 'Shared_Buffers': %=%
for /f "tokens=* delims=0123456789" %%a in ("%shared_buf%") do set "letras=%%a"
if defined letras (
    Echo Contém letras no valor, preencha apenas com números
    Echo.
    goto p2
)


:: pergunta para Work_Mem
:p3

set letras=
set /p WorkMem= Digite o valor para 'Work_Mem': %=%
for /f "tokens=* delims=0123456789" %%a in ("%WorkMem%") do set "letras=%%a"
if defined letras (
    Echo Contém letras no valor, preencha apenas com números
    Echo.
    goto p3
)

:: pergunta para Maintenance_Work_Mem
:p4

set letras=
set /p Main_workMem= Digite o valor para 'Maintenance Work Mem': %=%
for /f "tokens=* delims=0123456789" %%a in ("%Main_workMem%") do set "letras=%%a"
if defined letras (
    Echo Contém letras no valor, preencha apenas com números
    Echo.
    goto p4
)


:: pergunta para Max_Locks_Per_Transactions
:p5        

set letras=
set /p max_lock= Digite o valor para 'Max_Locks_Per_Transactions': %=%
for /f "tokens=* delims=0123456789" %%a in ("%max_lock%") do set "letras=%%a"
if defined letras (
    Echo Contém letras no valor, preencha apenas com números
    Echo.
    goto p5
)


:faz_otimizar
:: Verifica se o arquivo 'postgresql.conf' existe
if exist "%arquivo_Banco%" (
    cls
    if not exist "%arquivo_Banco%.bak" (
        :: faz uma cópia do arquivo para backup.
        copy "%arquivo_Banco%" "%arquivo_Banco%.bak"
        Echo Arquivo de backup criado em "%arquivo_Banco%.bak".
        
    ) else (
        Echo Arquivo de backup já existe. Por isso não foi feito. O Diretório do arquivo é %arquivo_Banco%.bak
    )
        
    Echo.
    if "%max_con%"=="" ( 
            Echo não foi alterado o max_connections.
        ) else (
        :: Substitui o valor de max_connections no arquivo, 1º opção
        powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#max_connections\s*=\s*\d+', 'max_connections = %max_con%' | Set-Content '%arquivo_Banco%'"
        powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*max_connections\s*=\s*\d+', 'max_connections = %max_con%' | Set-Content '%arquivo_Banco%'"
    )

    if "%shared_buf%"=="" ( 
            Echo não foi alterado o Shared buffers.
        ) else (
        :: Substitui o valor de Shared buffers, 2º opção
        powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Shared_Buffers\s*=\s*\d+', 'Shared_Buffers = %shared_buf%' | Set-Content '%arquivo_Banco%'"
        powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Shared_Buffers\s*=\s*\d+', 'Shared_Buffers = %shared_buf%' | Set-Content '%arquivo_Banco%'"
    )

    if "%WorkMem%"=="" ( 
            Echo não foi alterado o Work_Mem.
        ) else (
        :: Substitui o valor de Work_Mem, 3º opção
        powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Work_Mem\s*=\s*\d+', 'Work_Mem = %WorkMem%' | Set-Content '%arquivo_Banco%'"
        powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Work_Mem\s*=\s*\d+', 'Work_Mem = %WorkMem%' | Set-Content '%arquivo_Banco%'"
    )

    if "%Main_workMem%"=="" ( 
            Echo não foi alterado o maintenance_work_mem.
        ) else (
        :: Substitui o valor de maintenance_work_mem, 4 opção
        powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#maintenance_work_mem\s*=\s*\d+', 'maintenance_work_mem = %Main_workMem%' | Set-Content '%arquivo_Banco%'"
        powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*maintenance_work_mem\s*=\s*\d+', 'maintenance_work_mem = %Main_workMem%' | Set-Content '%arquivo_Banco%'"
    )

    if "%max_lock%"=="" ( 
            Echo não foi alterado o Max_Locks_Per_Transactions.
        ) else (
        :: Substitui o valor de Max_Locks_Per_Transaction, 5 opção
        powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*#Max_Locks_Per_Transaction\s*=\s*\d+', 'Max_Locks_Per_Transaction = %max_lock%' | Set-Content '%arquivo_Banco%'"
        powershell -Command "(Get-Content '%arquivo_Banco%') -replace '^\s*Max_Locks_Per_Transaction\s*=\s*\d+', 'Max_Locks_Per_Transaction = %max_lock%' | Set-Content '%arquivo_Banco%'"
    )

    Echo Alteração concluída!
) else (
    Echo O arquivo %arquivo_Banco% não foi encontrado.
)

timeout /t 5




:: Limpa a tela para facilitar a visualização:
cls







:: --------------------------------------------------------------------------------------------------------------













:Menu_banco


Echo Deseja aplicar essas configurações? Caso sim, o Serviço do Postgres será reiniciado.
Echo 1 = Sim
Echo 2 = Não
Echo 3 = Alterar configurações
Echo.
set /p opcaoBanco=Digite a opção: 


:: Verifica se a entrada está vazia
if "%opcaoBanco%"=="" (
    Echo Opção inválida. Tente novamente.
    pause
    goto Menu_banco
)



:: --------------------------------------------------------------------------------------------------------------




:: OPÇÃO 1: Reiniciar serviços PostgreSQL
if "%opcaoBanco%"=="1" (
    Echo.
    Echo Verificando serviços PostgreSQL...

    :: Reiniciar PostgreSQL 11
    sc query postgresql-11 >nul 2>&1
    if not errorlevel 1 (
        Echo Serviço PostgreSQL 11 encontrado.
        net stop postgresql-11 >nul 2>&1
        net start postgresql-11 >nul 2>&1
        Echo Serviço PostgreSQL 11 foi reiniciado.
    ) else (
        sc query postgresql-x64-11 >nul 2>&1
        if not errorlevel 1 (
            Echo Serviço PostgreSQL 11 encontrado.
            net stop postgresql-x64-11 >nul 2>&1
            net start postgresql-x64-11 >nul 2>&1
            Echo Serviço PostgreSQL 11 foi reiniciado.
        ) else (
            Echo Serviço PostgreSQL 11 não encontrado.
        )
    )
    :: Reiniciar PostgreSQL 9.6
    sc query postgresql-9.6 >nul 2>&1
    if not errorlevel 1 (
        Echo Serviço PostgreSQL 9.6 encontrado.
        net stop postgresql-9.6 >nul 2>&1
        net start postgresql-9.6 >nul 2>&1
        Echo Serviço PostgreSQL 9.6 foi reiniciado.
    ) else (
        sc query "postgresql-x64-9.6 - PostgreSQL Server 9.6" >nul 2>&1
        if not errorlevel 1 (
            Echo Serviço PostgreSQL x64-9.6 encontrado.
            net stop "postgresql-x64-9.6 - PostgreSQL Server 9.6" >nul 2>&1
            net start "postgresql-x64-9.6 - PostgreSQL Server 9.6" >nul 2>&1
            Echo Serviço PostgreSQL x64-9.6 foi reiniciado.
        ) else (
            Echo Serviço PostgreSQL 9.6 não encontrado.
        )
    )
    Echo Retornando ao Menu Principal.
    timeout /t 5
    goto menu
)
    





:: OPÇÃO 2: Sair sem alterações
if "%opcaoBanco%"=="2" (
    cls
    Echo O Arquivo foi editado, mas é necessário reiniciar o serviço do Postgres para ficar válida as alterações.
    Echo Retornando ao Menu Principal.
    timeout /t 5
    goto menu
)






:: OPÇÃO 3: Alterar configurações
if "%opcaoBanco%"=="3" (
    goto menu_otimiza
    pause

)




:: --------------------------------------------------------------------------------------------------------------


:: Opção inválida
cls
Echo Opção inválida. Tente novamente.
Echo.
goto Menu_banco



:: --------------------------------------------------------------------------------------------------------------

:reiniciaPostgres
cls
Echo Parando Serviço Postgres.
Echo.

:: Reiniciar PostgreSQL 9.6
sc query postgresql-11 >nul 2>&1
if not errorlevel 1 (
    Echo Serviço PostgreSQL 11 encontrado.
    net stop postgresql-11 >nul 2>&1
    cd C:\Program Files\PostgreSQL\11\data
    del postmaster.pid
    "C:\Program Files\PostgreSQL\11\bin\pg_resetwal.exe" -f "C:\Program Files\PostgreSQL\11\data"
    net start postgresql-11 >nul 2>&1
    Echo Serviço PostgreSQL 11 foi reiniciado.
) else (
    if not errorlevel 1 (
        Echo Serviço PostgreSQL 11 encontrado.
        net stop postgresql-x64-11 >nul 2>&1
        cd C:\Program Files\PostgreSQL\11\data
        del postmaster.pid
        "C:\Program Files\PostgreSQL\11\bin\pg_resetwal.exe" -f "C:\Program Files\PostgreSQL\11\data"
        net start postgresql-x64-11 >nul 2>&1
        Echo Serviço PostgreSQL 11 foi reiniciado.
    )
)

:: Reiniciar PostgreSQL 9.6
sc query postgresql-9.6 >nul 2>&1
if not errorlevel 1 (
    Echo Serviço PostgreSQL 9.6 encontrado.
    net stop postgresql-9.6 >nul 2>&1
    cd C:\Program Files\PostgreSQL\9.6\data
    del postmaster.pid
    "C:\Program Files\PostgreSQL\9.6\bin\pg_resetxlog.exe" -f "C:\Program Files\PostgreSQL\9.6\data"
    net start postgresql-9.6 >nul 2>&1
    Echo Serviço PostgreSQL 9.6 foi reiniciado.
) else (
    sc query postgresql-x64-9.6 >nul 2>&1
    if not errorlevel 1 (
        Echo Serviço postgresql-x64-9.6 encontrado.
        net stop postgresql-x64-9.6 >nul 2>&1
        cd C:\Program Files\PostgreSQL\9.6\data
        del postmaster.pid
        "C:\Program Files\PostgreSQL\9.6\bin\pg_resetxlog.exe" -f "C:\Program Files\PostgreSQL\9.6\data"
        net start postgresql-x64-9.6 >nul 2>&1
        Echo Serviço postgresql-x64-9.6 foi reiniciado.
    )
)



timeout /t 5
cls
goto reinicio




:: --------------------------------------------------------------------------------------------------------------








:ReinstalaUpdater

:: Verifica se o wget está instalado, se não, instala
where wget >nul 2>nul
if %errorlevel% neq 0 (
    Echo Instalando wget...
    powershell -Command "& {Invoke-WebRequest -Uri 'https://eternallybored.org/misc/wget/1.21.4/64/wget.exe' -OutFile wget.exe}"
    if exist wget.exe move wget.exe %SystemRoot%\System32\wget.exe >nul
)


if exist "C:\Program Files (x86)\Alterdata\Updater\unins000.exe" (
    cd "C:\Program Files (x86)\Alterdata\Updater\"
    Echo.
    Echo Desinstalando o Updater...
    start /wait unins000.exe /SILENT /VERYSILENT /NORESTART
    cd "C:\Program Files (x86)\Alterdata\Updater-Guardian\"
    start /wait unins000.exe /SILENT /VERYSILENT /NORESTART
    Echo Updater Desinstalado.
    Echo.
)   else (
        if exist "C:\Program Files\Alterdata\Updater\unins000.exe" (
            cd "C:\Program Files\Alterdata\Updater\"
            Echo.
            Echo Desinstalando o Updater...
            start /wait unins000.exe /SILENT /VERYSILENT /NORESTART
            cd "C:\Program Files\Alterdata\Updater-Guardian\"
            start /wait unins000.exe /SILENT /VERYSILENT /NORESTART
            Echo Updater Desinstalado.
            Echo.
        )
    )

:: Baixar o novo Updater
set URL="https://www.dropbox.com/scl/fi/gvt9qwe8vzgx62fjq1az8/Updater-8.10.2.0.exe?rlkey=5blfet9179jnx06zfeujsm4ey&st=8c1txwj5&dl=1"

if not exist C:\ProgramData\Alterdata\Cirrus (
    MD "C:\ProgramData\Alterdata\Cirrus"
)

set DESTINO=C:\ProgramData\Alterdata\Cirrus\Updater 8.10.2.0.exe

Echo Fazendo download do Updater...
Echo.
wget --no-check-certificate --show-progress %URL% -O "%DESTINO%" 2>&1 | findstr /R /C:"%DESTINO%" >nul
Echo Download completo! Arquivo localizado em C:\ProgramData\Alterdata\Cirrus.

:: Iniciar o novo Updater
start "" "%DESTINO%"

timeout /t 30

cls
goto reinicio







:: --------------------------------------------------------------------------------------------------------------
:SpoolImpressao

Echo Parando Spool de impressão.
Echo.
net stop spooler
Echo Apagando arquivos temporários
Echo.
del /Q /F /S C:\Windows\System32\spool\PRINTERS\*.*
Echo Iniciando Spool de Impressão.
Echo.
net start spooler
Echo Spooler Reiniciado e arquivos temporários limpos.

timeout /t 5
Cls
goto reinicio





:: --------------------------------------------------------------------------------------------------------------
:end
color 3
cls
Echo VLW FLW
timeout /t 2
