#Função para baixar o Tree Size
from tkinter import messagebox, Label
from pathlib import Path
from ttkbootstrap.constants import *
from time import sleep

import requests
import os
import shutil
import ctypes
import subprocess
import threading
import zipfile
import win32com.client
import pythoncom


'''
Aqui são todas as funções relacionadas o botão "Baixar Programas", abaixo tem os links de cada instalador e cada função. 
Atualmente, essas são as funções presentes no código:

    Central de ajuda:
        ajuda download

    Aplicativos:
        Tree_Size
        nfeasy_diagnostico

    Monitoramento e acesso ao banco de dados:
        DBMonitor
        AlterdataManager2_3
        AlterdataManager3_7
        pgadmin3
        pgadmin4

    Postgres:
        Postgres9_6
        Postgres11

    Aplicativos usados pela linha Shop:
        importa_nfe_nfce
        xml_para_dat
        OpenDataSet
        teste_balanca
        TEF_Gertec

    Aplicativos usados pela linha Pack:    
        PG_Migrator
        PackClean

'''

#Links de instalação utilizados nas funções:

#--------------- Utilitários ---------------

url_Tree_Size           = "https://www.dropbox.com/scl/fi/yr6nvxhv7j7akl9yc2jxm/Tree-size-Free-4.8.1.exe?rlkey=gu9y30oh8gdgngpl57gezl3wo&st=g0b9ub5p&dl=1"
url_NFeasy_diagnostico  = "https://www.dropbox.com/scl/fo/xe3tby3m1wj0hnmvu1m3k/AHjJgc5UhNoYBmOViH5yJ5s?rlkey=76pkinyxw61qr0anod582blzw&st=hmp1mtpb&dl=1"
url_DBMonitor           = "https://www.dropbox.com/scl/fi/zexh8o3ioznqseryr4otr/dbMonitor.exe?rlkey=jvdyoxhap6x8st1a375v44sz2&st=biya8mno&dl=1"

#----------- AlterdataManager -----------

url_AlterdataManager2_3 = "https://www.dropbox.com/scl/fo/yn8uglbjxa3nwhxyvytj3/AAaMen07tr_8mFfNYDXXDt4?rlkey=dd1hoxio3vhpgc8sh9seagnph&st=cw0uouku&dl=1"
url_AlterdataManager3_7 = "https://www.dropbox.com/scl/fi/5lvw5ztc6eprg5hb4qcdq/AlterdataManager.exe?rlkey=o26dowymgo8ffumxoqwtzcfkm&st=nic35jjb&dl=1"


#--------------- Postgres ---------------
#PGadmin
url_pgadmin3 = "https://www.dropbox.com/scl/fi/fi6y0sydtgemsu16p837b/pgadmin3.msi?rlkey=3esjle8vodj3eup3pq5eqdidw&st=b7mpd6rf&dl=1"
url_pgadmin4 = "https://www.dropbox.com/scl/fi/7q9d0iejuxworp29rj68d/pgadmin4-9.8-x64.exe?rlkey=sdo1dq5uiq906iqg0x33f9v2d&st=g073edwg&dl=1"

#Postgres
url_Postgres9_6 = "https://www.dropbox.com/scl/fi/mzm3w08nfxxe3fr3ck8wn/Setup_postgres_9.6_x64-64bits.exe?rlkey=pxits07n1ee8a440v7oi46qp4&st=v4wcrxc3&dl=1"
url_Postgres11  = "https://www.dropbox.com/scl/fi/fdehi5xzkd9u13cka1h4b/postgresql-11.22-1-windows-x64.exe?rlkey=2tkixfmc2iadjd230jgwscsry&st=6e2kadod&dl=1"

#--------------- Menu de Downloads SHOP ---------------
url_importador_xml  = "https://www.dropbox.com/scl/fo/v16wk7twxc73kt7dbc5w9/AIr1c6A9FdfN3x_D10wk2Ag?rlkey=njyn5t4m3b00k4nntrsks70al&st=fcit1q96&dl=1"
url_xml_to_dat      = "https://www.dropbox.com/scl/fo/zgc5i4u16hwj9lci07stt/AK_POw6XaquuAUkx9ecHqgE?rlkey=keq7fm9lfa6vjkyarfx5d6o2n&st=c1skw78t&dl=1"
url_OpenDataSet     = "https://www.dropbox.com/scl/fi/4akskh8bepz19ylqrc2k7/OpenDataSet.exe?rlkey=yh9mpx5430l61uog9jf0woueh&st=7cbz1jh8&dl=1"
url_testeBalanca    = "https://www.dropbox.com/scl/fi/erjgljzwdahh2khuwxixg/Teste-de-balan-a.exe?rlkey=07rtwfyp8nrfd9mfplb258ut1&st=td69okqf&dl=1"
url_Driver_Gertec   = "https://www.dropbox.com/scl/fi/tq20zyd6tryiec9kti7tu/Driver_GERTEC_2.7.3.exe?rlkey=g4us8ni3wb51g5h0wrramii9u&st=9ydriyes&dl=1"

#--------------- Menu de Downloads PACK ---------------
url_PGMigrator = "https://www.dropbox.com/scl/fi/xynivl2o1ru67a54erle6/alt_pgmigrator.exe?rlkey=au0n2ifro43h6s0gqtzleqpjk&st=8upjh840&dl=1"
url_PackClean  = "https://www.dropbox.com/scl/fo/7pr4mw1oyn4opiftqlmi7/ANv0Dicdt3UEHErXEaT6z_0?rlkey=laev9g4v2lnss2kg510jefwqm&st=slb1fwbm&dl=1"

#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------


def ajuda_download(tipo):

    ajuda = {    
        # ------------------- Botões do menu de Download --------------------

        "downloads":"Abre um menu de opções de Downloads disponíveis:\n\n1. NFeasy Diagnóstico\n2. DBMonitor\n3. Alterdata Manager 3.7\n4. PGAdmin3\n5. PGAdmin4\n6. Postgres versão 9.6 e 11\n7. Aplicativos usados pela linha Shop\n8. Aplicativos usados pela linha Pack",

        "Tree_Size":"Esse é um programa que analisa o espaço em disco, onde podemos ver o que apagar em caso de estar com o disco qual todo cheio.\n\nEle é baixado no diretório: C:\ProgramData\Alterdata\Cirrus.\n\nNecessita fazer a instalação para o funcionamento.",

        "nfeasy_diagnostico":"Esse arquivo é responsável por fazer a manutenção quando as notas estão saindo em contingência, fazendo uma manutenção geral nesse quesito.\n\nO programa NFeasy Diagnóstico é baixado no diretório: C:\ProgramData\Alterdata\Cirrus.",

        "DBMonitor":"Esse programa é um monitoramento dos sistemas, que verifica cada query que é feita ao banco de dados, utilizado para descobrir a fonte de erros quando se trata de tabelas.\n\nBaixa o DBMonitor na máquina no diretório: C:\ProgramData\Alterdata\Cirrus.\n\nTambém é criado um atalho na Área de trabalho.",

        #------------------------- AlterdataManager ------------------------

        "AlterdataManager":"Contém executáveis do Alterdata Manager, com diferentes versões.\n\nTendo as opções:\n1. AlterdataManager 2.3 (Não é necessário login para uso)\n2. AlterdataManager3.7 (Necessário login para uso)",

        "AlterdataManager2_3":"Baixa o Alterdata Manager 2.3 na máquina no diretório: C:\ProgramData\Alterdata\Cirrus.\n\nTambém é criado um atalho na Área de trabalho.\n\nOBS: Para rodar query, consultar tabelas, entre outras funções, não é necessário login.",

        "AlterdataManager3_7":"Baixa o Alterdata Manager 3.7 na máquina no diretório: C:\ProgramData\Alterdata\Cirrus.\n\nTambém é criado um atalho na Área de trabalho.\n\nOBS: Para rodar query, consultar tabelas, entre outras funções, é necessário login.",

        #----------------------------- PGAdmin -----------------------------
        "download_PGAdmin":"Contém drivers do PGAdmin, que são programas para visualização de banco de dados postgresql.\n\nTendo as opções:\n1. PGAdmin3\n2. PGAdmin4",
        "Pgadmin3":r"Baixa o instalador do PGadmin3 no diretório: C:\ProgramData\Alterdata\Cirrus.",
        "Pgadmin4":r"Baixa o instalador do PGadmin4 no diretório: C:\ProgramData\Alterdata\Cirrus.",

        #----------------------------- Postgres -----------------------------

        "Download_Postgre":"Contém o Download das versões do postgres.\n\nTendo as versões:\n1. Postgres 9.6 x64\n2. Postgres 11  x64",
        "Postgres9_6":"Baixa o instalador do Postgres 9.6 no diretório: C:\ProgramData\Alterdata\Cirrus.",
        "Postgres11":"Baixa o instalador do Postgres 11 no diretório: C:\ProgramData\Alterdata\Cirrus.",
        
        # ----------------- Botões do menu de Download SHOP -----------------

        "download_shop":"Contém ferramentas que são utilizadas pela linha Shop, tais como:\n\n1. Importador de NF-e/NFC-e por xml\n2. Conversor de XML para DAT\n3. Teste de balança\n4. Driver de instalação TEF GERTEC",

        "importa_nfe_nfce":"Esse é um executável que permite configurar a importação de notas de venda para o movimento de estoque pelo arquivo xml. Permite a importação de NF-e e NFC-e, tanto para ISHOP ou WSHOP.\n\nO Download do importador de xml é feito no diretório:\nC:\ProgramData\Alterdata\Cirrus\n\nTambém é criado um atalho na Área de trabalho.",

        "xml_para_dat":"Serve para gerar dats a partir dos xmls, para possível integração via servidor offline ou integrador spice.\n\nBaixa o executável no diretório:\nC:\ProgramData\Alterdata\Cirrus\n\nTambém é criado um atalho da pasta na Área de trabalho.",

        "OpenDataSet":"Ferramenta para leitura e análise de arquivos .dat estruturados. Ao selecionar o arquivo, o programa interpreta seu conteúdo e exibe todos os campos presentes.\n\nEle é baixado no diretório:\nC:\ProgramData\Alterdata\Cirrus.\n\nTambém é criado um atalho na Área de Trabalho.",

        "teste_balanca":"Esse programa serve para testar a conexão da balança com o computador.\n\nEle é baixado no diretório:\nC:\ProgramData\Alterdata\Cirrus.\n\nTambém é criado um atalho na Área de Trabalho.",

        "TEF_Gertec":"Baixa o driver do TEF da Gertec na versão 2.7.3.\n\nEle é baixado no diretório:\nC:\ProgramData\Alterdata\Cirrus.\n\nTambém é criado um atalho na Área de Trabalho.",

        # ----------------- Botões do menu de Download PACK -----------------

        "download_pack":"Contém ferramentas que são utilizadas pela linha Pack, tais como:\n\n1. PG Migrator\n2. Pack Clean",

        "PG_Migrator":"Esse programa é responsável por fazer a migração de versão do banco de dados PostgreSQL, voltado mais para clientes PACK que estão rodando na versão 11 do postgres.\n\nEle é baixado no diretório:\nC:\ProgramData\Alterdata\Cirrus",

        "Pack_Clean":"Esse programa é usado para fazer uma limpeza na base de dados de clientes PACK, tem funções como:\n1. Apagar cadastro de empresas\n2. Cadastrar empresas excluídas pelo sistema\n3. Mudar código de empresa\n\nBaixa o executável no diretório:\nC:\ProgramData\Alterdata\Cirrus\n\nTambém é criado um atalho da pasta na Área de trabalho.",
    }

    texto = ajuda.get(tipo, "Nenhuma explicação disponível para essa opção.")
    messagebox.showinfo("Explicação", texto)

#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#Funções de Download

def Tree_Size(root, btn_Tree_Size, btn_voltar):
    btn_Tree_Size.config(state="disabled")
    btn_voltar.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()
 
    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()

    def task():
        try:
            
            try:
                subprocess.run(
                    ["taskkill", "/F", "/IM", "TreeSizeFree.exe", "/T"],
                    check=True, capture_output=True
                )
            except subprocess.CalledProcessError:
                pass

            url = url_Tree_Size

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            destino = destino_dir / "Tree Size.exe"

            atualizar_status("Baixando Tree Size...")

            # ================== DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(destino, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status("Executando instalador do Tree Size...")
           


            # ================== EXECUTAR ==================
            
            os.startfile(destino)


        except Exception as e:
            root.after(0, lambda err=e: messagebox.showerror(
                "Erro",
                f"Não foi possível baixar o Tree Size.\n\n{err}"
            ))
        finally:
            sleep(5)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino}\n\n"
            ))
            atualizar_status(""),
            btn_Tree_Size.config(state="normal"),
            btn_voltar.config(state="normal")


    threading.Thread(target=task, daemon=True).start()


#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------


#Função para baixar e executar o NFEasy Diagnóstico

#---------------- Função para pegar a Área de Trabalho ----------------
def get_desktop_path():
    CSIDL_DESKTOP = 0
    SHGFP_TYPE_CURRENT = 0
    buf = ctypes.create_unicode_buffer(260)
    ctypes.windll.shell32.SHGetFolderPathW(None, CSIDL_DESKTOP, None, SHGFP_TYPE_CURRENT, buf)
    return Path(buf.value)


def nfeasy_diagnostico(root, btn_nfeasy_diagnostico, btn_voltar):

    btn_nfeasy_diagnostico.config(state="disabled")
    btn_voltar.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()

    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()


    def criar_atalho(destino):
        pythoncom.CoInitialize()  
        try:
            shell = win32com.client.Dispatch("WScript.Shell")
            desktop = get_desktop_path()
            atalho = desktop / "NFeasy Diagnóstico.lnk"
            shortcut = shell.CreateShortcut(str(atalho))
            shortcut.TargetPath = str(destino)
            shortcut.WorkingDirectory = str(destino.parent)
            shortcut.IconLocation = str(destino)
            shortcut.save()
        finally:
            pythoncom.CoUninitialize() 
        return atalho

    def task():
        try:
            try:
                subprocess.run(
                    ["taskkill", "/F", "/IM", "Alterdata.NFeasy2.Diagnostico.exe", "/T"],
                    check=True, capture_output=True)
                
            except subprocess.CalledProcessError:
                pass

            url = url_NFeasy_diagnostico

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            diretorio_zip = destino_dir / "NFeasy_Diagnostico.zip"
            diretorio_extracao = destino_dir / "NFeasy Diagnóstico"
            destino = diretorio_extracao / "Alterdata.NFeasy2.Diagnostico.exe"

            sleep(1)
            if diretorio_zip.exists():
                os.remove(diretorio_zip)
            if diretorio_extracao.exists():
                shutil.rmtree(diretorio_extracao)

            atualizar_status("Baixando arquivo...")
            # ================== 1. DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(diretorio_zip, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status(f"Download concluído!")

            # ================== 2. Extrai a pasta ==================
            with zipfile.ZipFile(diretorio_zip, 'r') as zip_ref:
                zip_ref.extractall(diretorio_extracao)

            # ================== CRIAR ATALHO ==================
            atalho = criar_atalho(destino)

            atualizar_status("Executando NFeasy Diagnóstico...")

            # ================== 3. Abre o programa ==================
            os.remove(diretorio_zip)
            subprocess.Popen([str(destino)])

        except Exception as e:
            atualizar_status("Erro durante o download.")
            messagebox.showerror("Erro", f"Falha ao baixar o NFeasy Diagnóstico:\n{e}")

        finally:
            sleep(5)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino}\n\n"
                f"Atalho criado em:\n{atalho}"
            ))
            atualizar_status("")
            btn_nfeasy_diagnostico.config(state="normal")
            btn_voltar.config(state="normal")
            

    threading.Thread(target=task, daemon=True).start()

#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------




#Função para baixar e executar o DBMonitor

#---------------- Função para pegar a Área de Trabalho ----------------
def get_desktop_path():
    CSIDL_DESKTOP = 0
    SHGFP_TYPE_CURRENT = 0
    buf = ctypes.create_unicode_buffer(260)
    ctypes.windll.shell32.SHGetFolderPathW(None, CSIDL_DESKTOP, None, SHGFP_TYPE_CURRENT, buf)
    return Path(buf.value)

# ---------------- Função principal DBMonitor ----------------
def DBMonitor(root, btn_dbmonitor, btn_voltar):
    btn_dbmonitor.config(state="disabled")
    btn_voltar.config(state="disabled")


    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()

    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()

    def criar_atalho(destino):
        pythoncom.CoInitialize()  # Inicializa COM na thread
        try:
            shell = win32com.client.Dispatch("WScript.Shell")
            desktop = get_desktop_path()
            atalho = desktop / "DBMonitor.lnk"
            shortcut = shell.CreateShortcut(str(atalho))
            shortcut.TargetPath = str(destino)
            shortcut.WorkingDirectory = str(destino.parent)
            shortcut.IconLocation = str(destino)
            shortcut.save()
        finally:
            pythoncom.CoUninitialize() 
        return atalho

    def task():
        try:
            
            try:
                subprocess.run(
                    ["taskkill", "/F", "/IM", "dbMonitor.exe", "/T"],
                    check=True, capture_output=True
                )
            except subprocess.CalledProcessError:
                pass

            url = url_DBMonitor

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            destino = destino_dir / "dbMonitor.exe"

            atualizar_status("Baixando DBMonitor...")

            # ================== DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(destino, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status("Criando atalho na Área de Trabalho...")

            # ================== CRIAR ATALHO ==================
            atalho = criar_atalho(destino)

            atualizar_status("Executando DBMonitor...")


            # ================== EXECUTAR ==================
            sleep(5)
            os.startfile(destino)


        except Exception as e:
            root.after(0, lambda err=e: messagebox.showerror(
                "Erro",
                f"Não foi possível baixar o DBMonitor.\n\n{err}"
            ))
        finally:
            sleep(5)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino}\n\n"
                f"Atalho criado em:\n{atalho}"
            ))
            atualizar_status(""),
            btn_dbmonitor.config(state="normal"),
            btn_voltar.config(state="normal")
 

    threading.Thread(target=task, daemon=True).start()

#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------

#---------------- Função para pegar a Área de Trabalho ----------------
def get_desktop_path():
    CSIDL_DESKTOP = 0
    SHGFP_TYPE_CURRENT = 0
    buf = ctypes.create_unicode_buffer(260)
    ctypes.windll.shell32.SHGetFolderPathW(None, CSIDL_DESKTOP, None, SHGFP_TYPE_CURRENT, buf)
    return Path(buf.value)


def AlterdataManager2_3(root, btn_AlterdataManager2_3, btn_voltar):

    btn_AlterdataManager2_3.config(state="disabled")
    btn_voltar.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()

    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()


    def criar_atalho(destino):
        pythoncom.CoInitialize()  
        try:
            shell = win32com.client.Dispatch("WScript.Shell")
            desktop = get_desktop_path()
            atalho = desktop / "Manager 2.3.lnk"
            shortcut = shell.CreateShortcut(str(atalho))
            shortcut.TargetPath = str(destino)
            shortcut.WorkingDirectory = str(destino.parent)
            shortcut.IconLocation = str(destino)
            shortcut.save()
        finally:
            pythoncom.CoUninitialize() 
        return atalho

    def task():
        try:
            try:
                subprocess.run(
                    ["taskkill", "/F", "/IM", "AlterdataManager 2.3.exe", "/T"],
                    check=True, capture_output=True)
                
            except subprocess.CalledProcessError:
                pass

            url = url_AlterdataManager2_3

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            diretorio_zip = destino_dir / "AlterdataManager 2.3.zip"
            diretorio_extracao = destino_dir / "AlterdataManager 2.3"
            destino = diretorio_extracao / "AlterdataManager 2.3.exe"

            sleep(1)
            if diretorio_zip.exists():
                os.remove(diretorio_zip)
            if diretorio_extracao.exists():
                shutil.rmtree(diretorio_extracao)

            atualizar_status("Baixando arquivo...")
            # ================== 1. DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(diretorio_zip, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status(f"Download concluído!")

            # ================== 2. Extrai a pasta ==================
            with zipfile.ZipFile(diretorio_zip, 'r') as zip_ref:
                zip_ref.extractall(diretorio_extracao)

            # ================== CRIAR ATALHO ==================
            atalho = criar_atalho(destino)

            atualizar_status("Executando Alterdata Manager 2.3...")

            # ================== 3. Abre o programa ==================
            os.remove(diretorio_zip)
            subprocess.Popen([str(destino)])

        except Exception as e:
            atualizar_status("Erro durante o download.")
            messagebox.showerror("Erro", f"Falha ao baixar o Alterdata Manager 2.3:\n{e}")

        finally:
            sleep(5)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino}\n\n"
                f"Atalho criado em:\n{atalho}"
            ))
            atualizar_status("")
            btn_AlterdataManager2_3.config(state="normal")
            btn_voltar.config(state="normal")
            

    threading.Thread(target=task, daemon=True).start()



#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------


#---------------- Função para pegar a Área de Trabalho ----------------
def get_desktop_path():
    CSIDL_DESKTOP = 0
    SHGFP_TYPE_CURRENT = 0
    buf = ctypes.create_unicode_buffer(260)
    ctypes.windll.shell32.SHGetFolderPathW(None, CSIDL_DESKTOP, None, SHGFP_TYPE_CURRENT, buf)
    return Path(buf.value)




# ---------------- Função principal Alterdata Manager ----------------
def AlterdataManager3_7(root, btn_AlterdataManager3_7, btn_voltar):
    btn_AlterdataManager3_7.config(state="disabled")
    btn_voltar.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()
 
    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()

    def criar_atalho(destino):
        pythoncom.CoInitialize() 
        try:
            shell = win32com.client.Dispatch("WScript.Shell")
            desktop = get_desktop_path()
            atalho = desktop / "Alterdata Manager 3.7.lnk"
            shortcut = shell.CreateShortcut(str(atalho))
            shortcut.TargetPath = str(destino)
            shortcut.WorkingDirectory = str(destino.parent)
            shortcut.IconLocation = str(destino)
            shortcut.save()
        finally:
            pythoncom.CoUninitialize() 
        return atalho

    def task():
        try:
            
            try:
                subprocess.run(
                    ["taskkill", "/F", "/IM", "AlterdataManager.exe", "/T"],
                    check=True, capture_output=True
                )
            except subprocess.CalledProcessError:
                pass

            url = url_AlterdataManager3_7

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            destino = destino_dir / "Alterdata Manager 3.7.exe"

            atualizar_status("Baixando Alterdata Manager 3.7...")

            # ================== DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(destino, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status("Criando atalho na Área de Trabalho...")

            # ================== CRIAR ATALHO ==================
            atalho = criar_atalho(destino)

            atualizar_status("Executando Alterdata Manager 3.7...")


            # ================== EXECUTAR ==================
            os.startfile(destino)


        except Exception as e:
            root.after(0, lambda err=e: messagebox.showerror(
                "Erro",
                f"Não foi possível baixar o Alterdata Manager 3.7.\n\n{err}"
            ))
        finally:
            sleep(5)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino}\n\n"
                f"Atalho criado em:\n{atalho}"
            ))
            atualizar_status(""),
            btn_AlterdataManager3_7.config(state="normal"),
            btn_voltar.config(state="normal")





    threading.Thread(target=task, daemon=True).start()



#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------



# ---------------- Função principal PGAdmin3 ----------------
def pgadmin3(root, btn_pgadmin3, btn_voltar):
    btn_pgadmin3.config(state="disabled")
    btn_voltar.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()
 
    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()

    def task():
        try:
            
            try:
                subprocess.run(
                    ["taskkill", "/F", "/IM", "pgadmin3.exe", "/T"],
                    check=True, capture_output=True
                )
            except subprocess.CalledProcessError:
                pass

            url = url_pgadmin3

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            destino = destino_dir / "pgadmin3.msi"

            atualizar_status("Baixando PGAdmin3...")

            # ================== DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(destino, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status("Executando instalador do PGAdmin3...")
           


            # ================== EXECUTAR ==================
            
            os.startfile(destino)


        except Exception as e:
            root.after(0, lambda err=e: messagebox.showerror(
                "Erro",
                f"Não foi possível baixar o PGAdmin3.\n\n{err}"
            ))
        finally:
            sleep(5)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino}\n\n"
            ))
            atualizar_status(""),
            btn_pgadmin3.config(state="normal"),
            btn_voltar.config(state="normal")


    threading.Thread(target=task, daemon=True).start()



#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------


# ---------------- Função principal PGAdmin4 ----------------
def pgadmin4(root, btn_pgadmin4, btn_voltar):
    btn_pgadmin4.config(state="disabled")
    btn_voltar.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()
 
    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()

    def task():
        try:

            url = url_pgadmin4

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            destino = destino_dir / "pgadmin4-9.8-x64.exe"

            atualizar_status("Baixando PGAdmin4...")

            # ================== DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(destino, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status("Executando instalador do PGAdmin4...")
           


            # ================== EXECUTAR ==================
            
            os.startfile(destino)


        except Exception as e:
            root.after(0, lambda err=e: messagebox.showerror(
                "Erro",
                f"Não foi possível baixar o PGAdmin4.\n\n{err}"
            ))
        finally:
            sleep(5)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino}\n\n"
            ))
            atualizar_status(""),
            btn_pgadmin4.config(state="normal"),
            btn_voltar.config(state="normal")


    threading.Thread(target=task, daemon=True).start()




#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------

# ---------------- Função principal Postgres ----------------


#Postgres 9.6

def Postgres9_6(root, btn_Postgres9_6, btn_voltar):
    btn_Postgres9_6.config(state="disabled")
    btn_voltar.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()
 
    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()

    def task():
        try:

            url = url_Postgres9_6

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            destino = destino_dir / "Postgres 9.6.exe"

            atualizar_status("Baixando Postgres9_6..")

            # ================== DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(destino, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status("Executando instalador do Postgres9_6...")
           


            # ================== EXECUTAR ==================
            
            os.startfile(destino)


        except Exception as e:
            root.after(0, lambda err=e: messagebox.showerror(
                "Erro",
                f"Não foi possível baixar o Postgres9_6.\n\n{err}"
            ))
        finally:
            sleep(5)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino}\n\n"
            ))
            atualizar_status(""),
            btn_Postgres9_6.config(state="normal"),
            btn_voltar.config(state="normal")


    threading.Thread(target=task, daemon=True).start()

#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------


#Postgres 11

def Postgres11(root, btn_Postgres11, btn_voltar):
    btn_Postgres11.config(state="disabled")
    btn_voltar.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()
 
    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()

    def task():
        try:

            url = url_Postgres11

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            destino = destino_dir / "Postgres 11.exe"

            atualizar_status("Baixando Postgres 11...")

            # ================== DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(destino, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status("Executando instalador do Postgres 11...")
           


            # ================== EXECUTAR ==================
            
            os.startfile(destino)


        except Exception as e:
            root.after(0, lambda err=e: messagebox.showerror(
                "Erro",
                f"Não foi possível baixar o Postgres 11.\n\n{err}"
            ))
        finally:
            sleep(5)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino}\n\n"
            ))
            atualizar_status(""),
            btn_Postgres11.config(state="normal"),
            btn_voltar.config(state="normal")


    threading.Thread(target=task, daemon=True).start()



#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------



# Funções Download SHOP

#Função para baixar e executar o Importador de NFe/NFCe

#---------------- Função para pegar a Área de Trabalho ----------------
def get_desktop_path():
    CSIDL_DESKTOP = 0
    SHGFP_TYPE_CURRENT = 0
    buf = ctypes.create_unicode_buffer(260)
    ctypes.windll.shell32.SHGetFolderPathW(None, CSIDL_DESKTOP, None, SHGFP_TYPE_CURRENT, buf)
    return Path(buf.value)


def importa_nfe_nfce(root, btn_importa_nfe_nfce, btn_voltar_downloads_shop):

    btn_importa_nfe_nfce.config(state="disabled")
    btn_voltar_downloads_shop.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()

    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()


    def criar_atalho(destino):
        pythoncom.CoInitialize()  
        try:
            shell = win32com.client.Dispatch("WScript.Shell")
            desktop = get_desktop_path()
            atalho = desktop / "Importador de xml.lnk"
            shortcut = shell.CreateShortcut(str(atalho))
            shortcut.TargetPath = str(destino)
            shortcut.WorkingDirectory = str(destino.parent)
            shortcut.IconLocation = str(destino)
            shortcut.save()
        finally:
            pythoncom.CoUninitialize() 
        return atalho

    def task():
        try:
            try:
                subprocess.run(
                    ["taskkill", "/F", "/IM", "AltShopProc_ImportaXML.exe", "/T"],
                    check=True, capture_output=True)
                
            except subprocess.CalledProcessError:
                pass

            url = url_importador_xml

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            diretorio_zip = destino_dir / "Importador de xml.zip"
            diretorio_extracao = destino_dir / "Importador de xml"
            destino = diretorio_extracao / "AltShopProc_ImportaXML.exe"

            sleep(1)
            if diretorio_zip.exists():
                os.remove(diretorio_zip)
            if diretorio_extracao.exists():
                shutil.rmtree(diretorio_extracao)

            atualizar_status("Baixando arquivo...")
            # ================== 1. DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(diretorio_zip, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status(f"Download concluído!")

            # ================== 2. Extrai a pasta ==================
            with zipfile.ZipFile(diretorio_zip, 'r') as zip_ref:
                zip_ref.extractall(diretorio_extracao)

            # ================== CRIAR ATALHO ==================
            atalho = criar_atalho(destino)

            atualizar_status("Executando Importador de xml...")


            # ================== 3. Abre o programa ==================
            os.remove(diretorio_zip)
            subprocess.Popen([str(destino)])

        except Exception as e:
            atualizar_status("Erro durante o download.")
            messagebox.showerror("Erro", f"Falha ao baixar o Importador de xml:\n{e}")

        finally:
            sleep(5)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino}\n\n"
                f"Atalho criado em:\n{atalho}"
            ))
            atualizar_status("")
            btn_importa_nfe_nfce.config(state="normal")
            btn_voltar_downloads_shop.config(state="normal")
            

    threading.Thread(target=task, daemon=True).start()    


#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------

# Funções Download SHOP

#Função para baixar o gerador de dat por xml

#---------------- Função para pegar a Área de Trabalho ----------------
def get_desktop_path():
    CSIDL_DESKTOP = 0
    SHGFP_TYPE_CURRENT = 0
    buf = ctypes.create_unicode_buffer(260)
    ctypes.windll.shell32.SHGetFolderPathW(None, CSIDL_DESKTOP, None, SHGFP_TYPE_CURRENT, buf)
    return Path(buf.value)


def xml_para_dat(root, btn_xml_para_dat, btn_voltar_downloads_shop):

    btn_xml_para_dat.config(state="disabled")
    btn_voltar_downloads_shop.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()

    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()


    def criar_atalho(destino):
        pythoncom.CoInitialize()  
        try:
            shell = win32com.client.Dispatch("WScript.Shell")
            desktop = get_desktop_path()
            atalho = desktop / "Converter XML para DAT.lnk"
            shortcut = shell.CreateShortcut(str(atalho))
            shortcut.TargetPath = str(destino)
            shortcut.WorkingDirectory = str(destino.parent)
            shortcut.IconLocation = str(destino)
            shortcut.save()
        finally:
            pythoncom.CoUninitialize() 
        return atalho

    def task():
        try:

            url = url_xml_to_dat

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            diretorio_zip = destino_dir / "Conversor_xml_para_dat.zip"
            diretorio_extracao = destino_dir / "Conversor XML para DAT"

            sleep(1)
            if diretorio_zip.exists():
                os.remove(diretorio_zip)
            if diretorio_extracao.exists():
                shutil.rmtree(diretorio_extracao)

            atualizar_status("Baixando arquivo...")
            # ================== 1. DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(diretorio_zip, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status(f"Download concluído!")

            # ================== 2. Extrai a pasta ==================
            with zipfile.ZipFile(diretorio_zip, 'r') as zip_ref:
                zip_ref.extractall(diretorio_extracao)


            # ================== CRIAR ATALHO ==================
            atalho = criar_atalho(diretorio_extracao)
            atualizar_status("Criando atalho da pasta na Área de Trabalho.")
            


            # ================== 3. Apaga o arquivo ZIP ==================
            os.remove(diretorio_zip)


        except Exception as e:
            atualizar_status("Erro durante o download.")
            messagebox.showerror("Erro", f"Falha ao baixar o Conversor de XML para DAT:\n{e}")

        finally:
            sleep(5)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino_dir}\n\n"
                f"Atalho criado em:\n{atalho}"
            ))
            atualizar_status("")
            btn_xml_para_dat.config(state="normal")
            btn_voltar_downloads_shop.config(state="normal")
            

    threading.Thread(target=task, daemon=True).start()



#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------

# Funções Download SHOP
#Leitor de dats

#---------------- Função para pegar a Área de Trabalho ----------------
def get_desktop_path():
    CSIDL_DESKTOP = 0
    SHGFP_TYPE_CURRENT = 0
    buf = ctypes.create_unicode_buffer(260)
    ctypes.windll.shell32.SHGetFolderPathW(None, CSIDL_DESKTOP, None, SHGFP_TYPE_CURRENT, buf)
    return Path(buf.value)


def OpenDataSet(root, btn_OpenDataSet, btn_voltar_downloads_shop):
    btn_OpenDataSet.config(state="disabled")
    btn_voltar_downloads_shop.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()
 
    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()

    def criar_atalho(destino):
        pythoncom.CoInitialize() 
        try:
            shell = win32com.client.Dispatch("WScript.Shell")
            desktop = get_desktop_path()
            atalho = desktop / "OpenDataSet.lnk"
            shortcut = shell.CreateShortcut(str(atalho))
            shortcut.TargetPath = str(destino)
            shortcut.WorkingDirectory = str(destino.parent)
            shortcut.IconLocation = str(destino)
            shortcut.save()
        finally:
            pythoncom.CoUninitialize() 
        return atalho

    def task():
        try:
            
            try:
                subprocess.run(
                    ["taskkill", "/F", "/IM", "OpenDataSet.exe", "/T"],
                    check=True, capture_output=True
                )
            except subprocess.CalledProcessError:
                pass

            url = url_OpenDataSet

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            destino = destino_dir / "OpenDataSet.exe"

            atualizar_status("Baixando o OpenDataSet (Leitor de Dats)...")

            # ================== DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(destino, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status("Criando atalho na Área de Trabalho...")

            # ================== CRIAR ATALHO ==================
            atalho = criar_atalho(destino)

            atualizar_status("Executando o OpenDataSet (Leitor de Dats)")

            


            # ================== EXECUTAR ==================
            
            os.startfile(destino)


        except Exception as e:
            root.after(0, lambda err=e: messagebox.showerror(
                "Erro",
                f"Não foi possível baixar o OpenDataSet (Leitor de Dats).\n\n{err}"
            ))
        finally:
            sleep(2)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino}\n\n"
                f"Atalho criado em:\n{atalho}"
            ))

            atualizar_status(""),
            btn_OpenDataSet.config(state="normal"),
            btn_voltar_downloads_shop.config(state="normal")


    threading.Thread(target=task, daemon=True).start()

#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------


# Funções Download SHOP
#Programa do teste de balança

#---------------- Função para pegar a Área de Trabalho ----------------
def get_desktop_path():
    CSIDL_DESKTOP = 0
    SHGFP_TYPE_CURRENT = 0
    buf = ctypes.create_unicode_buffer(260)
    ctypes.windll.shell32.SHGetFolderPathW(None, CSIDL_DESKTOP, None, SHGFP_TYPE_CURRENT, buf)
    return Path(buf.value)


def teste_balanca(root, btn_teste_balanca, btn_voltar_downloads_shop):
    btn_teste_balanca.config(state="disabled")
    btn_voltar_downloads_shop.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()
 
    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()

    def criar_atalho(destino):
        pythoncom.CoInitialize() 
        try:
            shell = win32com.client.Dispatch("WScript.Shell")
            desktop = get_desktop_path()
            atalho = desktop / "Teste de Balança.lnk"
            shortcut = shell.CreateShortcut(str(atalho))
            shortcut.TargetPath = str(destino)
            shortcut.WorkingDirectory = str(destino.parent)
            shortcut.IconLocation = str(destino)
            shortcut.save()
        finally:
            pythoncom.CoUninitialize() 
        return atalho

    def task():
        try:
            
            try:
                subprocess.run(
                    ["taskkill", "/F", "/IM", "Teste_balança.exe", "/T"],
                    check=True, capture_output=True
                )
            except subprocess.CalledProcessError:
                pass

            url = url_testeBalanca

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            destino = destino_dir / "Teste_balança.exe"

            atualizar_status("Baixando o Teste de balança...")

            # ================== DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(destino, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status("Criando atalho na Área de Trabalho...")

            # ================== CRIAR ATALHO ==================
            atalho = criar_atalho(destino)

            atualizar_status("Executando o Teste de balança")

            


            # ================== EXECUTAR ==================
            
            os.startfile(destino)


        except Exception as e:
            root.after(0, lambda err=e: messagebox.showerror(
                "Erro",
                f"Não foi possível baixar o Teste de balança.\n\n{err}"
            ))
        finally:
            sleep(2)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino}\n\n"
                f"Atalho criado em:\n{atalho}"
            ))

            atualizar_status(""),
            btn_teste_balanca.config(state="normal"),
            btn_voltar_downloads_shop.config(state="normal")


    threading.Thread(target=task, daemon=True).start()


#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------


# Funções Download SHOP


#---------------- Função para pegar a Área de Trabalho ----------------
def get_desktop_path():
    CSIDL_DESKTOP = 0
    SHGFP_TYPE_CURRENT = 0
    buf = ctypes.create_unicode_buffer(260)
    ctypes.windll.shell32.SHGetFolderPathW(None, CSIDL_DESKTOP, None, SHGFP_TYPE_CURRENT, buf)
    return Path(buf.value)


def TEF_Gertec(root, btn_TEF_Gertec, btn_voltar_downloads_shop):
    btn_TEF_Gertec.config(state="disabled")
    btn_voltar_downloads_shop.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()
 
    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()

    def criar_atalho(destino):
        pythoncom.CoInitialize() 
        try:
            shell = win32com.client.Dispatch("WScript.Shell")
            desktop = get_desktop_path()
            atalho = desktop / "Driver TEF Gertec 2.7.3.lnk"
            shortcut = shell.CreateShortcut(str(atalho))
            shortcut.TargetPath = str(destino)
            shortcut.WorkingDirectory = str(destino.parent)
            shortcut.IconLocation = str(destino)
            shortcut.save()
        finally:
            pythoncom.CoUninitialize() 
        return atalho

    def task():
        try:
            
            try:
                subprocess.run(
                    ["taskkill", "/F", "/IM", "Driver_TEF_Gertec_2.7.3.exe", "/T"],
                    check=True, capture_output=True
                )
            except subprocess.CalledProcessError:
                pass

            url = url_Driver_Gertec

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            destino = destino_dir / "Driver_TEF_Gertec_2.7.3.exe"

            atualizar_status("Baixando o Driver do TEF Gertec...")

            # ================== DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(destino, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status("Criando atalho na Área de Trabalho...")

            # ================== CRIAR ATALHO ==================
            atalho = criar_atalho(destino)

            atualizar_status("Executando o driver do TEF Gertec")


            # ================== EXECUTAR ==================
            
            os.startfile(destino)


        except Exception as e:
            root.after(0, lambda err=e: messagebox.showerror(
                "Erro",
                f"Não foi possível baixar o driver do TEF Gertec.\n\n{err}"
            ))
        finally:
            sleep(2)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino}\n\n"
                f"Atalho criado em:\n{atalho}"
            ))
            root.after(0, lambda: [
                atualizar_status(""),
                btn_TEF_Gertec.config(state="normal"),
                btn_voltar_downloads_shop.config(state="normal")
            ])

    threading.Thread(target=task, daemon=True).start()


#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------

# Funções Download PACK


#---------------- Função para pegar a Área de Trabalho ----------------
def get_desktop_path():
    CSIDL_DESKTOP = 0
    SHGFP_TYPE_CURRENT = 0
    buf = ctypes.create_unicode_buffer(260)
    ctypes.windll.shell32.SHGetFolderPathW(None, CSIDL_DESKTOP, None, SHGFP_TYPE_CURRENT, buf)
    return Path(buf.value)


def PG_Migrator(root, btn_PG_Migrator, btn_voltar_download_pack):

    btn_PG_Migrator.config(state="disabled")
    btn_voltar_download_pack.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()

    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()


    def criar_atalho(destino):
        pythoncom.CoInitialize()  
        try:
            shell = win32com.client.Dispatch("WScript.Shell")
            desktop = get_desktop_path()
            atalho = desktop / "PG Migrator.lnk"
            shortcut = shell.CreateShortcut(str(atalho))
            shortcut.TargetPath = str(destino)
            shortcut.WorkingDirectory = str(destino.parent)
            shortcut.IconLocation = str(destino)
            shortcut.save()
        finally:
            pythoncom.CoUninitialize() 
        return atalho

    def task():
        try:
            try:
                subprocess.run(
                    ["taskkill", "/F", "/IM", "PG_Migrator.exe", "/T"],
                    check=True, capture_output=True
                )
            except subprocess.CalledProcessError:
                pass

            url = url_PGMigrator

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            destino = destino_dir / "PG_Migrator.exe"

            atualizar_status("Baixando PG Migrator...")
            # ===================  DOWNLOAD ===================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(destino, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status(f"Download concluído!")


            # ================== CRIAR ATALHO ==================
            atalho = criar_atalho(destino)
            atualizar_status("Criando atalho na Área de Trabalho.")
            # ================== EXECUTAR ==================
            os.startfile(destino)
            


        except Exception as e:
            atualizar_status("Erro durante o download.")
            messagebox.showerror("Erro", f"Falha ao baixar o PG_Migrator:\n{e}")

        finally:
            sleep(5)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino_dir}\n\n"
                f"Atalho criado em:\n{atalho}"
            ))
            atualizar_status("")
            btn_PG_Migrator.config(state="normal")
            btn_voltar_download_pack.config(state="normal")
            

    threading.Thread(target=task, daemon=True).start()



#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------

# Funções Download PACK


#---------------- Função para pegar a Área de Trabalho ----------------
def get_desktop_path():
    CSIDL_DESKTOP = 0
    SHGFP_TYPE_CURRENT = 0
    buf = ctypes.create_unicode_buffer(260)
    ctypes.windll.shell32.SHGetFolderPathW(None, CSIDL_DESKTOP, None, SHGFP_TYPE_CURRENT, buf)
    return Path(buf.value)


def PackClean(root, btn_PackClean, btn_voltar_downloads_pack):

    btn_PackClean.config(state="disabled")
    btn_voltar_downloads_pack.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()

    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()


    def criar_atalho(destino):
        pythoncom.CoInitialize()  
        try:
            shell = win32com.client.Dispatch("WScript.Shell")
            desktop = get_desktop_path()
            atalho = desktop / "PackClean.lnk"
            shortcut = shell.CreateShortcut(str(atalho))
            shortcut.TargetPath = str(destino)
            shortcut.WorkingDirectory = str(destino.parent)
            shortcut.IconLocation = str(destino)
            shortcut.save()
        finally:
            pythoncom.CoUninitialize() 
        return atalho

    def task():
        try:

            url = url_PackClean

            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            diretorio_zip = destino_dir / "PackClean.zip"
            diretorio_extracao = destino_dir / "PackClean"

            sleep(1)
            if diretorio_zip.exists():
                os.remove(diretorio_zip)
            if diretorio_extracao.exists():
                shutil.rmtree(diretorio_extracao)

            atualizar_status("Baixando arquivo...")
            # ================== 1. DOWNLOAD ==================
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(diretorio_zip, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status(f"Download concluído!")

            # ================== 2. Extrai a pasta ==================
            with zipfile.ZipFile(diretorio_zip, 'r') as zip_ref:
                zip_ref.extractall(diretorio_extracao)


            # ================== CRIAR ATALHO ==================
            atalho = criar_atalho(diretorio_extracao)
            atualizar_status("Criando atalho da pasta na Área de Trabalho.")
            


            # ================== 3. Apaga o arquivo ZIP ==================
            os.remove(diretorio_zip)


        except Exception as e:
            atualizar_status("Erro durante o download.")
            messagebox.showerror("Erro", f"Falha ao baixar o PackClean:\n{e}")

        finally:
            sleep(5)
            root.after(0, lambda: messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nArquivo salvo em:\n{destino_dir}\n\n"
                f"Atalho criado em:\n{atalho}"
            ))
            atualizar_status("")
            btn_PackClean.config(state="normal")
            btn_voltar_downloads_pack.config(state="normal")
            

    threading.Thread(target=task, daemon=True).start()



#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------


