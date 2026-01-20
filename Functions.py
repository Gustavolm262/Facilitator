from tkinter import messagebox, ttk, END, Label
from pathlib import Path
from ttkbootstrap.constants import *
from subprocess import run, CalledProcessError
from time import sleep

import requests
import platform
import tkinter as tk
import ttkbootstrap as tb
import os
import shutil
import ctypes
import locale
import subprocess
import threading
import glob
import winreg
import zipfile
import psutil
import win32com.client
import pythoncom


'''
Todas funções inclusas nesse código são:
Utilize Ctrl+shift+O e pesquise com esses nomes para localizar a conferir as funções.

    Central de ajuda:
        ajuda

    Funções úteis:

        Add_sites
        permissoes
        exe_admin
        registra_midas
    
    Funções para o banco de dados POSTGRES:
        otimiza_banco
        reinicia_postgres

    Demais funções:
        reinstalar_updater
        spool_impressao

'''




#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------------------------------


#Função de ajuda, onde mostra um botão do lado da opção com uma mensagem do que cada opção faz.

def ajuda(tipo):

    ajuda = {
        #Funções gerais
        "sites":"Adiciona os sites ajuda:\n1. SHOP\n2. Suporte via karoo\n3. Suporte remoto.\nTodos vão para a Área de Trabalho do computador.",

        "permissoes":"1. Libera as permissões nas portas TCP e UDP Firewall\n2. Pastas do gerenciador de banco de dados\n3. Pastas do sistema Alterdata\n4. Permissão firewall dos executáveis da Alterdata\n5. Adiciona links nos sites confiáveis\n6. Ajusta o fuso horário do computador.",

        "exe_admin":"Faz com que todos Executáveis da Alterdata fiquem para abrir como administrador.",

        "registra_midas":"Verifica se o Windows é 32 ou 64 bits. Depois faz o Registro da Midas.DLL.",

        "otimiza_banco":"Permite fazer otimização do banco de dados Postgres, selecionando uma predefinição de acordo com a quantidade de memória RAM e faz um backup de segurança do arquivo Postgresql.conf.\n\nLista de otimização:\n\n4Gb de Memória Ram:\nMax_Connectios: 100\nShared_Buffers: 400\nWork_Mem: 10\nMaintenance Work Mem: 110\nMax_Locks_Per_Transactions: 300\n\n6Gb de Memória Ram:\nMax_Connectios: 120\nShared_Buffers: 800\nWork_Mem: 20\nMaintenance Work Mem: 210\nMax_Locks_Per_Transactions: 400\n\n8Gb de Memória Ram:\nMax_Connectios: 150\nShared_Buffers: 1600\nWork_Mem: 40\nMaintenance Work Mem: 310\nMax_Locks_Per_Transactions: 400\n\n16Gb de Memória Ram:\nMax_Connectios: 300\nShared_Buffers: 2900\nWork_Mem: 60\nMaintenance Work Mem: 700\nMax_Locks_Per_Transactions: 400\n\nRode apenas no servidor.",

        "reinicia_postgres":"Força a reinicialização do Postgres, apagando o arquivo postmaster.pid e rodando um resetxLog para postgres 9.6 ou um resetwal para postgres 11.",

        "reinstalar_updater":"Desinstala o UpdaterManager da máquina do cliente e automaticamente já baixa o arquivo e executa para ser reinstalado.",

        "spool_impressao":r"Reinicia o Spooler de impressão e apaga os arquivos temporários da pasta System32\spool\PRINTERS.",

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




#Função para adicionar sites do ajuda, remoto e karoo na Área de trabalho do cliente.

#função que pega o diretório da Área de trabalho   
def get_desktop_path():
    CSIDL_DESKTOP = 0
    SHGFP_TYPE_CURRENT = 0
    buf = ctypes.create_unicode_buffer(260)
    ctypes.windll.shell32.SHGetFolderPathW(None, CSIDL_DESKTOP, None, SHGFP_TYPE_CURRENT, buf)
    return Path(buf.value)



def Add_sites(root, btn_add_sites):
    area_trabalho = get_desktop_path()
    btn_add_sites.config(state="disabled")


    if not area_trabalho.exists():
        messagebox.showerror("Erro", "Não foi possível encontrar a área de trabalho.")
        btn_add_sites.config(state="normal")
        return

    links = [
        ("Ajuda Alterdata", "https://ajuda.alterdata.com.br/suporteexpress"),
        ("Suporte via Chat", "https://widget.karoo.com.br/c/275"),
        ("Acesso remoto Alterdata", "https://cliente.alterdata.com.br/pg/remoto/suporte-remoto")
    ]

    for nome, url in links:
        atalho = area_trabalho / f"{nome}.url"
        with open(atalho, "w", encoding="utf-8") as f:
            f.write("[InternetShortcut]\n")
            f.write(f"URL={url}\n")

    btn_add_sites.config(state="normal")
    messagebox.showinfo("Sucesso", f"Atalhos criados com sucesso em:\n{area_trabalho}")


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




#Função para dar permissão nas pastas da Alterdata, postgres, regedit, colocar sites como Sites confiáveis,


def permissoes(root, btn_permissoes):
    btn_permissoes.config(state="disabled")

    idioma = locale.getlocale()[0]
    usuario = "Todos" if idioma and idioma.startswith("pt_") else "Everyone"
    permissao = "F"
    erros = []
    LOG_FILE = r"C:\permissoes_Log.log"
    popup = tk.Toplevel(root)
    popup.title("Aplicando permissões")
    popup.geometry("500x120")
    popup.resizable(False, False)

    label_info = tk.Label(popup, text="Iniciando...", wraplength=480, font=("Arial", 12, "bold"))
    label_info.pack(pady=10)

    progress = ttk.Progressbar(popup, length=450, mode='determinate', bootstyle="Success")
    progress.pack(pady=5)

    #Pastas para liberar permissão no sistema
    pastas = [
        r"C:\ALTERDAT", 
        r"C:\Alterdata",
        r"C:\Program Files\PostgreSQL",
        r"C:\DadosNFeasy",
        r"C:\Backup",
        r"C:\Program Files (x86)\Alterdata"
    ]


    #Pasta do postgres, onde já verifica todas dentro de PostgreSQL e faz a liberação
    pastas_postgres = glob.glob(r"C:\Arquivos de Programas\PostgreSQL\*\bin")


    #Sites que serão adicionados como Sites confiáveis
    sites = [
        "contas.pack.alterdata.com.br",
        "nfeasy-admin.alterdata.com.br",
        "services.nfstock.com.br",
        "www.alterdatatecnologia.com.br",
        "dfe.alterdata.com.br",
        "nfeasy.alterdata.com.br",
        "e-api.alterdata.com.br/api/bimer/v1",
        "*.karoo.com.br",
        "widget.karoo.com.br/c/275",
        "*.pusher.com",
        "*.pusherapp.com",
        "*.amazonaws.com",
        "*.newrelic.com",
        "*.userreport.com",
        "*.bam.nr-data.net",
        "*.mandrillapp.com",
        "*.mailchimp.com",
        "*.vipera.io",
        "www.alterdata.com.br/",
        "www.passaporte2.alterdata.com.br/",
        "www.passaporte.alterdata.com.br/",
        "*.comodoca.com",
        "*.usertrust.com",
        "*.amazonaws.com",
        "*.jrsoftware.org",
        "*.comodo.com",
        "updatecenter.alterdatasoftware.com.br/api/v1/licenca-web",
        "livedesktop.alterdata.com.br",
        "www.alterdatatecnologia.com.br",
        "www.karoo.com.br",
        "wscards.alterdata.com.br",
        "www.alterdata.com.br",
        "tempuri.org",
        "schemas.microsoft.com",
        "kb.alterdata.com.br",
        "www.portalfiscal.inf.br",
        "api-shop-feedback.alterdatasoftware.com.br",
        "taxadvisor.consultatributaria.com.br",
        "parceiro.scanntech.com",
        "parceiro1.scanntech.com",
        "parceiro2.scanntech.com",
        "test.parceiro.scanntech.com",
        "superpack.alterdata.com.br",
        "universosped.alterdata.com.br",
        "updatecenter.alterdata.com.br",
        "livechat.alterdata.com.br",
        "ajuda.alterdata.com.br",
        "m.correios.com.br",
        "www.receita.fazenda.gov.br",
        "services.nfstock.com.br",
        "www.nfe.fazenda.gov.br",
        "wsishop.alterdata.com.br",
        "telemetria.alterdata.com.br",
        "www.correios.com.br",
        "cards.alterdata.com.br",
        "express.alterdata.com.br",
        "loja.4keep.com.br",
        "wspackweb.alterdata.com.br",
        "cargatributaria.supershop.alterdata.com.br",
        "conhecimento.alterdata.com.br",
        "webservices.sef.sc.gov.br",
        "webservices.sathomologa.sef.sc.gov.br",
        "sefaznet.ac.gov.br",
        "nfce.sefaz.al.gov.br",
        "sistemas.sefaz.am.gov.br",
        "nfe.sefaz.ba.gov.br",
        "nfce.sefaz.ce.gov.br",
        "dec.fazenda.df.gov.br",
        "app.sefaz.es.gov.br",
        "nfe.sefaz.go.gov.br",
        "www.nfce.sefaz.ma.gov.br",
        "www.sefaz.mt.gov.br",
        "/appnfc.sefa.pa.gov.br",
        "/www5.receita.pb.gov.br",
        "webas.sefaz.pi.gov.br",
        "www.sped.fazenda.pr.gov.br",
        "www4.fazenda.rj.gov.br",
        "nfce.set.rn.gov.br",
        "www.nfce.sefin.ro.gov.br",
        "www.sefaz.rr.gov.br",
        "www.sefaz.rs.gov.br",
        "www.nfe.se.gov.br",
        "/www.nfce.fazenda.sp.gov.br",
        "www.fazenda.sp.gov.br",
        "passad.alterdata.com.br",
        "wspassad.alterdata.com.br",
        "help.alterdata.com.br",
        "images.alterdata.com.br",
        "www.spicesoftware.com.br",
        "spice-cardapiodigital.alterdatasoftware.com.br",
        "passaporte2.alterdata.com.br",
        "ajuda.alterdata.com.br",
        "viacep.com.br/ws",
        "log-shop.alterdata.com.br",
        "contas.pack.alterdata.com.br",
        "pos-api.ifood.com.br",
        "delivery-dev.alterdata.com.br",
        "static-images.ifood.com.br",
        "delivery-hml.alterdata.com.br",
        "meiospagamento.alterdata.com.br",
        "bimer-lisa.alterdata.com.br",
        "contas-service-nfstock.alterdatasoftware.com.br",
        "www.receitaws.com.br",
        "sms.alterdata.com.br",
        "telemetria.alterdata.com.br",
        "muven-api.c2bsoftware.com.br",
        "player.vimeo.com",
        "accounts.c2bsoftware.com.br",
        "delivery.alterdata.com.br",
        "empresas.btgpactual.com",
        "dws-shop.alterdata.com.br",
        "web.whatsapp.com",
        "www.java.com",
    ]


    #Executáveis a serem adicionados no firewall do windows
    regras_firewall = [
        ("AltShopProc_ExportadorNeoGrid.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_ExportadorNeoGrid.exe"),
        ("altshopproc_cadastroprodutos.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_cadastroprodutos.exe"),
        ("RegAsm.exe", r"C:\Program Files (x86)\Alterdata\Shop\RegAsm.exe"),
        ("AltShopProcExtratorXML.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProcExtratorXML.exe"),
        ("AltShopProc_ManutencaoPrecoProduto.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_ManutencaoPrecoProduto.exe"),
        ("altshopproc_manutencaoprodutos.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_manutencaoprodutos.exe"),
        ("AltShopProc_AtualizarDocNFeWShop.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AtualizarDocNFeWShop.exe"),
        ("AltShopProc_AtualizarDocNFeIShop.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AtualizarDocNFeIShop.exe"),
        ("worc_2005.exe", r"C:\Program Files (x86)\Alterdata\Shop\worc_2005.exe"),
        ("altshopproc_movestoqueotimizado.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_movestoqueotimizado.exe"),
        ("altshopordemservicoentrada.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopordemservicoentrada.exe"),
        ("IAgendaAdmin.exe", r"C:\Program Files (x86)\Alterdata\Shop\IAgendaAdmin.exe"),
        ("altshopproc_gerarsintegra.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_gerarsintegra.exe"),
        ("altshopproc_gerarsped.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_gerarsped.exe"),
        ("altshopimpressaocarne.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopimpressaocarne.exe"),
        ("altshopconfig_pdvalterdata.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopconfig_pdvalterdata.exe"),
        ("AltShop_GerenciadorNotas.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShop_GerenciadorNotas.exe"),
        ("AltShop_InutilizacaoFaixaNFCe.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShop_InutilizacaoFaixaNFCe.exe"),
        ("altshopreldocumentos.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopreldocumentos.exe"),
        ("altshopproc_integracaoorcamentopdalogicalafv.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_integracaoorcamentopdalogicalafv.exe"),
        ("AltShopProc_AVARElatorios.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AVARElatorios.exe"),
        ("WSched.exe", r"C:\Program Files (x86)\Alterdata\Shop\WSched.exe"),
        ("altshopproc_financeiro.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_financeiro.exe"),
        ("altshoprel_simplificadodeprodutos.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshoprel_simplificadodeprodutos.exee"),
        ("WToten.exe", r"C:\Program Files (x86)\Alterdata\Shop\WToten.exe"),
        ("altshoprel_produtosvendidosclientevendedor.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshoprel_produtosvendidosclientevendedor.exe"),
        ("altshoprelextratoprodutos.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshoprelextratoprodutos.exe"),
        ("AltShopProc_Tesouraria.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_Tesouraria.exe"),
        ("AltShopProc_Sincronizador4Keep.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_Sincronizador4Keep.exe"),
        ("AltShopProc_CadastroProdutosSimples.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_CadastroProdutosSimples.exe"),
        ("AltShopProc_Delivery.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_Delivery.exe"),
        ("AltShopProc_CompraFacil", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_CompraFacil"),
        ("altshopproc_cadastroempresas.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_cadastroempresas.exe"),
        ("AltShopProc_ControleRomaneio.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_ControleRomaneio.exe"),
        ("AltShop_DashBoard.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShop_DashBoard.exe"),
        ("AltShop_Configuracoes.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShop_Configuracoes.exe"),
        ("worc_200.exe", r"C:\Program Files (x86)\Alterdata\Shop\worc_200.exe"),
        ("WAgendaAdmin.exe", r"C:\Program Files (x86)\Alterdata\Shop\WAgendaAdmin.exe"),
        ("WShopSE.exe", r"C:\Program Files (x86)\Alterdata\Shop\WShopSE.exe"),
        ("winv.exe", r"C:\Program Files (x86)\Alterdata\Shop\winv.exe"),
        ("altshopanalisedesempenhovendedor.exe", r"C:\Program Files (x86)\Alterdata\altshopanalisedesempenhovendedor.exe"),
        ("AltShop_AVA.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShop_AVA.exe"),
        ("altshoprelatorioinventario.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshoprelatorioinventario.exe"),
        ("altshopproc_maladireta.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_maladireta.exe"),
        ("altshopproc_manutencaoprodutos2.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_manutencaoprodutos2.exe"),
        ("AltShopProc_AuditorEventos.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AuditorEventos.exe"),
        ("AltShopOrdemServicoConfig.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopOrdemServicoConfig.exe"),
        ("AdminEmissaoOtimizada.exe", r"C:\Program Files (x86)\Alterdata\Shop\AdminEmissaoOtimizada.exe"),
        ("AltShopProc_BaixarNFESefaz.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_BaixarNFESefaz.exe"),
        ("AlterdataManager.exe", r"C:\Program Files (x86)\Alterdata\Shop\AlterdataManager.exe"),
        ("OrdemServicoIshop.exe", r"C:\Program Files (x86)\Alterdata\Shop\OrdemServicoIshop.exe"),
        ("OSAdmin.exe", r"C:\Program Files (x86)\Alterdata\Shop\OSAdmin.exe"),
        ("WorcAdmin.exe", r"C:\Program Files (x86)\Alterdata\Shop\WorcAdmin.exe"),
        ("IOrcAdmin.exe", r"C:\Program Files (x86)\Alterdata\Shop\IOrcAdmin.exe"),
        ("IAdminEmissaoOtimizada.exe", r"C:\Program Files (x86)\Alterdata\Shop\IAdminEmissaoOtimizada.exe"),
        ("altshopproc_gerenciadormdfe.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_gerenciadormdfe.exe"),
        ("AltshopRel_AnaliseFiscal.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltshopRel_AnaliseFiscal.exe"),
        ("altshoprel_contasreceberpagar.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshoprel_contasreceberpagar.exe"),
        ("altshopproc_integracaofciproduto.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_integracaofciproduto.exe"),
        ("AltShopProc_ControleEntregas_Expedicao.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_ControleEntregas_Expedicao.exe"),
        ("AltShopProc_AlinhamentoTransacaoPendenteWShop.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AlinhamentoTransacaoPendenteWShop.        exe"),
        ("AltShopProc_AlinhamentoTransacaoPendenteIShop.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AlinhamentoTransacaoPendenteIShop.        exe"),
        ("AltShopProc_AlterarStatusMonitor.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_AlterarStatusMonitor.exe"),
        ("AltShopProc_Promocao.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_Promocao.exe"),
        ("CotacaoAdmin.exe", r"C:\Program Files (x86)\Alterdata\Shop\CotacaoAdmin.exe"),
        ("WDelivery.exe", r"C:\Program Files (x86)\Alterdata\Shop\WDelivery.exe"),
        ("MonitorIntegracao.exe", r"C:\Program Files (x86)\Alterdata\Shop\MonitorIntegracao.exe"),
        ("IDelivery.exe", r"C:\Program Files (x86)\Alterdata\Shop\IDelivery.exe"),
        ("AltShopRel_ResumoDoDia.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopRel_ResumoDoDia.exe"),
        ("AltShopProc_SincronizadorECommerce.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_SincronizadorECommerce.exe"),
        ("altshopproc_geracaodav.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_geracaodav.exe"),
        ("AltShop_SincronizadorScanntechGuardian.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShop_SincronizadorScanntechGuardian.exe"),
        ("altshopgeracaobase.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopgeracaobase.exe"),
        ("AltShop_ServicoGuardian.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShop_ServicoGuardian.exe"),
        ("AltShopProc_FerramentasCadastroCliente.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_FerramentasCadastroCliente.exe"),
        ("CotacaoAdminIshop.exe", r"C:\Program Files (x86)\Alterdata\Shop\CotacaoAdminIshop.exe"),
        ("AlterAgente.exe", r"C:\Program Files (x86)\Alterdata\Shop\AlterAgente.exe"),
        ("AlterAgenteGuardian.exe", r"C:\Program Files (x86)\Alterdata\Shop\AlterAgenteGuardian.exe"),
        ("AltShopProc_BoletoExpress_Integrador.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_BoletoExpress_Integrador.exe"),
        ("altshoprel_quadrovendadiaria.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshoprel_quadrovendadiaria.exe"),
        ("ExecuteDll.exe", r"C:\Program Files (x86)\Alterdata\Shop\ExecuteDll.exe"),
        ("Shell.exe", r"C:\Program Files (x86)\Alterdata\Shop\AShell.exe"),
        ("AltShopProc_GerenciadorCartaCredito.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopProc_GerenciadorCartaCredito.exe"),
        ("AltShopOSWorkFlow.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopOSWorkFlow.exe"),
        ("AltShopOSEquipamentos.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopOSEquipamentos.exe"),
        ("altshopmaparesumo.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopmaparesumo.exe"),
        ("AltShop_SincronizadorScanntech.exe", r"C:\Program Files (x86)\Alterdata\Shop\aAltShop_SincronizadorScanntech.exe"),
        ("altshopproc_cadastroprodutosspice.exe", r"C:\Program Files (x86)\Alterdata\Shop\altshopproc_cadastroprodutosspice.exe"),
        ("AltShopConv_ImagensProduto.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShopConv_ImagensProduto.exe"),
        ("configurador_ambiente_postgresql.exe", r"C:\Program Files (x86)\Alterdata\Shop\configurador_ambiente_postgresql.exe"),
        ("AltShop_GeradorDeArquivos.exe", r"C:\Program Files (x86)\Alterdata\Shop\AltShop_GeradorDeArquivos.exe"),
        ("Alterdata.Updater.ConsoleApp", r"C:\Program Files (x86)\Alterdata\Updater\bin\Alterdata.Updater.ConsoleApp.exe"),
        ("AlterdataAutoUpdate", r"C:\Program Files (x86)\Alterdata\Updater\bin\AlterdataAutoUpdate.exe"),
        ("UpdaterManager", r"C:\Program Files (x86)\Alterdata\Updater\bin\UpdaterManager.exe"),
        ("Guardian", r"C:\Program Files (x86)\Alterdata\Updater\bin\Guardian.exe"),
        ("Alterdata.Prevenda", r"C:\Program Files (x86)\Alterdata\PreVenda\Alterdata.Prevenda.exe"),
        ("PDVAlterdata", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\PDVAlterdata.exe"),
        ("ServidorOffLine", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\PinPadFinder.exe"),
        ("PinPadFinder", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\PDVAlterdata.exe"),
        ("AltShop_InutilizacaoFaixaNFCe", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_InutilizacaoFaixaNFCe.exe"),
        ("LiberaECF", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\LiberaECF"),
        ("AltShop_GeradorBlocoX_DataBase", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GeradorBlocoX_DataBase.exe"),
        ("GerenciadorBlocoX", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\GerenciadorBlocoX.exe"),
        ("AltShop_GerenciadorNotas", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GerenciadorNotas.exe"),
        ("ImpOffLine", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\ImpOffLine.exe"),
        ("ExpOffLine", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\ExpOffLine.exe"),
        ("AltShop_ConfigBasePadrao", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_ConfigBasePadrao.exe"),
        ("AltShopConfCegaPDV", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShopConfCegaPDV.exe"),
        ("ServidorOffLineGuardian", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\ServidorOffLineGuardian.exe"),
        ("AltShop_GeradorCargaBalancaPDV", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GeradorCargaBalancaPDV.exe"),
        ("AltShop_GeradorMovimentoECF", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShop_GeradorMovimentoECF.exe"),
        ("AltShopProc_EntradaProducao", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\AltShopProc_EntradaProducao.exe"),
        ("TMVirtualPortDriver860a", r"C:\Program Files (x86)\Alterdata\PDV Alterdata\TMVirtualPortDriver860a.exe"),
        ("IntegradorPreVendaPDV", r"C:\Program Files (x86)\Alterdata\OrcamentoOffline\IntegradorPreVendaPDV.exe"),
        ("Alterdata.OrcamentoOffline", r"C:\Program Files (x86)\Alterdata\OrcamentoOffline\Alterdata.OrcamentoOffline.exe"),
        ("OrcamentoOffLineAdmin", r"C:\Program Files (x86)\Alterdata\OrcamentoOffline\OrcamentoOffLineAdmin.exe"),
        ("ISSEasy", r"C:\Program Files (x86)\Alterdata\ISS-Easy\ISSEasy.exe"),
        ("GuardiaoISSEasy", r"C:\Program Files (x86)\Alterdata\ISS-Easy\GuardiaoISSEasy.exe"),
        ("RegAsm", r"C:\Program Files (x86)\Alterdata\ISS-Easy\RegAsm.exe")
    ]


    #Portas a serem liberadas no Firewall do Windows
    regras_portas = [
        ("Postgre TCP", "TCP", 5432),
        ("Postgre TCP", "TCP", 5432),
        ("Postgre UDP", "UDP", 5432),
        ("Postgre UDP", "UDP", 5432),
        ("Alterdata Porta 80", "TCP", 80),
        ("Alterdata Porta 80", "TCP", 80),
        ("Alterdata Porta 80", "UDP", 80),
        ("Alterdata Porta 80", "UDP", 80),
        ("Alterdata Porta 1433", "TCP", 1433),
        ("Alterdata Porta 1433", "TCP", 1433),
        ("Alterdata Porta 1433", "UDP", 1433),
        ("Alterdata Porta 1433", "UDP", 1433),
        ("Alterdata Porta 8081", "TCP", 8081),
        ("Alterdata Porta 8081", "TCP", 8081),
        ("Alterdata Porta 8081", "UDP", 8081),
        ("Alterdata Porta 8081", "UDP", 8081),
        ("Alterdata Porta 8080", "TCP", 8080),
        ("Alterdata Porta 8080", "TCP", 8080),
        ("Alterdata Porta 8080", "UDP", 8080),
        ("Alterdata Porta 8080", "UDP", 8080),
        ("Alterdata Porta 3128", "TCP", 3128),
        ("Alterdata Porta 3128", "TCP", 3128),
        ("Alterdata Porta 3128", "UDP", 3128),
        ("Alterdata Porta 3128", "UDP", 3128),
        ("Alterdata Porta 5484", "TCP", 5484),
        ("Alterdata Porta 5484", "TCP", 5484),
        ("Alterdata Porta 5484", "UDP", 5484),
        ("Alterdata Porta 5484", "UDP", 5484),
        ("Alterdata Porta 13000", "TCP", 13000),
        ("Alterdata Porta 13000", "TCP", 13000),
        ("Alterdata Porta 13000", "UDP", 13000),
        ("Alterdata Porta 13000", "UDP", 13000),
        ("Alterdata Porta 49169", "TCP", 49169),
        ("Alterdata Porta 49169", "TCP", 49169),
        ("Alterdata Porta 49169", "UDP", 49169),
        ("Alterdata Porta 49169", "UDP", 49169),
        ("Alterdata Porta 443", "TCP", 443),
        ("Alterdata Porta 443", "TCP", 443),
        ("Alterdata Porta 443", "UDP", 443),
        ("Alterdata Porta 443", "UDP", 443),
        ("Alterdata Porta 8768", "TCP", 8768),
        ("Alterdata Porta 8768", "TCP", 8768),
        ("Alterdata Porta 8768", "UDP", 8768),
        ("Alterdata Porta 8768", "UDP", 8768),
        ("Alterdata Porta 8766", "TCP", 8766),
        ("Alterdata Porta 8766", "TCP", 8766),
        ("Alterdata Porta 8766", "UDP", 8766),
        ("Alterdata Porta 8766", "UDP", 8766),
        ("Alterdata Porta 587", "TCP", 587),
        ("Alterdata Porta 587", "TCP", 587),
        ("Alterdata Porta 587", "UDP", 587),
        ("Alterdata Porta 587", "UDP", 587),
        ("Alterdata Porta 8877", "TCP", 8877),
        ("Alterdata Porta 8877", "TCP", 8877),
        ("Alterdata Porta 8877", "UDP", 8877),
        ("Alterdata Porta 8877", "UDP", 8877),
        ("Alterdata Porta 465", "UDP", 465),
        ("Alterdata Porta 465", "UDP", 465),
        ("Alterdata Porta 465", "TCP", 465),
        ("Alterdata Porta 465", "TCP", 465),
        ("Alterdata Porta 2525", "UDP", 2525),
        ("Alterdata Porta 2525", "UDP", 2525),
        ("Alterdata Porta 2525", "TCP", 2525),
        ("Alterdata Porta 2525", "TCP", 2525)
    ]

    #Criação da barra de progresso de todos os dados
    total_pasta = len(pastas)
    total_postgres = sum(len(glob.glob(os.path.join(pasta_bin, "*.exe")))*2 for pasta_bin in pastas_postgres if os.path.exists(pasta_bin))
    total_sites = len(sites)
    total_firewall = len(regras_firewall)*2
    total_portas = len(regras_portas)*2
    progress["maximum"] = total_pasta + total_postgres + total_sites + total_firewall + total_portas

    def desativar_notificacoes_firewall_reg():
        comando = [
            "powershell",
            "-Command",
            """
            Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\DomainProfile' -Name  'DisableNotifications' -Value 1;
            Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\StandardProfile' -Name    'DisableNotifications' -Value 1;
            Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\PublicProfile' -Name  'DisableNotifications' -Value 1;
            """
        ]
        subprocess.run(comando, check=True)

    desativar_notificacoes_firewall_reg()
    def permitir_conexoes_entrada():
        comando = [
            "powershell",
            "-Command",
            "Set-NetFirewallProfile -Profile Domain,Private,Public -DefaultInboundAction Allow"
        ]
        subprocess.run(comando, check=True)

    permitir_conexoes_entrada()
    def fechar_popup():
        btn_permissoes.config(state="normal")
        if popup.winfo_exists():
            popup.destroy()

    popup.protocol("WM_DELETE_WINDOW", fechar_popup)

    def tarefa_completa():
        valor = 0

        def atualiza_label(texto):
            if popup.winfo_exists():
                label_info.config(text=texto)
                popup.update_idletasks()

        def atualiza_progress():
            nonlocal valor
            if popup.winfo_exists():
                progress["value"] = valor
                popup.update_idletasks()

        


        def registrar_log(msg):
            with open(LOG_FILE, "a", encoding="utf-8") as f:
                f.write(msg + "\n")

        # -------------------- Libera permissão nas pastas gerais --------------------
        for pasta in pastas:
            atualiza_label(f"Aplicando permissões em:\n{pasta}")
            if os.path.exists(pasta):
                comando_raiz = f'icacls "{pasta}" /inheritance:e /grant "{usuario}":(OI)(CI){permissao} /C /Q'
                comando_sub  = f'icacls "{pasta}" /grant "{usuario}":(OI)(CI){permissao} /T /C /Q'

                for cmd in [comando_raiz, comando_sub]:
                    resultado = subprocess.run(cmd, shell=True, capture_output=True, text=True)
                    if resultado.returncode != 0:
                        registrar_log(f"[ERRO] Pasta: {pasta}\nComando: {cmd}\nErro: {resultado.stderr.strip()}\n")
                    else:
                        registrar_log(f"[OK] Pasta: {pasta}\nComando: {cmd}\nSaída: {resultado.stdout.strip()}\n")

            else:
                erros.append(f"{pasta}: Pasta não encontrada")
                registrar_log(f"[ERRO] Pasta não encontrada: {pasta}")

            valor += 1
            atualiza_progress()


        # -------------------- Libera as Permissões PostgreSQL --------------------
        for pasta_bin in pastas_postgres:
            if not os.path.exists(pasta_bin):
                continue
            for caminho in glob.glob(os.path.join(pasta_bin, "*.exe")):
                exe = os.path.basename(caminho)
                for direcao in ("in", "out"):
                    atualiza_label(f"Aplicando permissão em:\n{exe} ({direcao})")
                    comando = ["netsh", "advfirewall", "firewall", "add", "rule",
                               f"name={exe}", f"dir={direcao}", "action=allow",
                               f"program={caminho}", "enable=yes", "profile=private,public,domain"]
                    try:
                        subprocess.run(comando, check=True, stdout=subprocess.DEVNULL,
                                       stderr=subprocess.DEVNULL, creationflags=subprocess.CREATE_NO_WINDOW)
                    except subprocess.CalledProcessError:
                        erros.append(f"{exe}: Falha ao aplicar regra firewall {direcao}")
                    valor += 1
                    atualiza_progress()

        # -------------------- Adiciona os Sites confiáveis --------------------
        for site in sites:
            atualiza_label(f"Adicionando site confiável:\n{site}")
            chave = rf"HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\{site}"
            comando = ["reg", "add", chave, "/v", "http", "/t", "REG_DWORD", "/d", "2", "/f"]
            try:
                subprocess.run(comando, check=True, stdout=subprocess.DEVNULL,
                               stderr=subprocess.DEVNULL, creationflags=subprocess.CREATE_NO_WINDOW)
            except subprocess.CalledProcessError:
                erros.append(f"{site}: Falha ao adicionar site confiável")
            valor += 1
            atualiza_progress()

        # -------------------- Liberação dos executáveis no Firewall --------------------
        for nome, caminho in regras_firewall:
            for direcao in ("in", "out"):
                atualiza_label(f"Liberando permissão em:\n{nome} ({direcao})")
                comando = ["netsh", "advfirewall", "firewall", "add", "rule",
                           f"name={nome}", f"dir={direcao}", "action=allow",
                           f"program={caminho}", "enable=yes"]
                try:
                    subprocess.run(comando, check=True, stdout=subprocess.DEVNULL,
                                   stderr=subprocess.DEVNULL, creationflags=subprocess.CREATE_NO_WINDOW)
                except subprocess.CalledProcessError:
                    erros.append(f"{nome}: Falha ao aplicar regra firewall {direcao}")
                valor += 1
                atualiza_progress()

        # -------------------- Liberação das portas no Firewall --------------------
        for nome, protocolo, porta in regras_portas:
            for direcao in ("in", "out"):
                atualiza_label(f"Liberando porta:\n{nome} ({direcao})")
                comando = [
                    "netsh", "advfirewall", "firewall", "add", "rule",
                    f"name={nome}", f"dir={direcao}", "action=allow",
                    f"protocol={protocolo}", f"localport={porta}"
                ]
                try:
                    subprocess.run(comando, check=True, stdout=subprocess.DEVNULL,
                                   stderr=subprocess.DEVNULL, creationflags=subprocess.CREATE_NO_WINDOW)
                except subprocess.CalledProcessError:
                    erros.append(f"{nome}: Falha ao liberar porta {direcao}")
                valor += 1
                atualiza_progress()
        #Ativar firewall
        try:
            atualiza_label("Ativando Firewall")
            comando = ["netsh", "advfirewall", "set", "allprofiles", "state", "on"]
            subprocess.run(comando, check=True, shell=True)
        except subprocess.CalledProcessError:
            erros.append("Falha ao ativar Firewall.")
        atualiza_progress()
        #Permitir conexão de entrada do firewall
        try:
            atualiza_label("Permitindo conexão de Entrada do Firewall")
            comando = [
                "powershell",
                "-Command",
                "Set-NetFirewallProfile -Profile Domain,Private,Public -DefaultInboundAction Allow"
            ]
            subprocess.run(comando, check=True)
        except subprocess.CalledProcessError:
            erros.append("Falha ao configurar Firewall.")
        atualiza_progress()

        #Desativar notificações firewall
        try:    
            atualiza_label("Desativando notificações do Firewall")
            comando = [
                "powershell",
                "-Command",
                """
                Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\DomainProfile' -Name  'DisableNotifications' -Value 1;
                Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\StandardProfile'  -Name 'DisableNotifications' -Value 1;
                Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\PublicProfile' -Name  'DisableNotifications' -Value 1;
                """
            ]
            subprocess.run(comando, check=True)

        except subprocess.CompletedProcess:
            erros.append("Falha ao desativar notificações do Firewall.")
        atualiza_progress()

        # -------------------- Faz o ajuste no relógio do windows  --------------------
        # Ajustes do formato de data e hora e também sincroniza a hora do windows.
        ajustes_reg = [
            (r"HKCU\Control Panel\International", "sShortDate", "dd/MM/yyyy", "REG_SZ"),
            (r"HKCU\Control Panel\International", "sLongDate", "dddddddddddddddddddddd, dd 'de 'MMMM' de 'yyyy", "REG_SZ"),
            (r"HKCU\Control Panel\International", "sTimeFormat", "HH:mm:ss", "REG_SZ"),
            (r"HKCU\Control Panel\International", "sLongTimeFormat", "HH:mm:ss", "REG_SZ"),
            (r"HKCU\Control Panel\International", "iFirstDayOfWeek", "7", "REG_DWORD"),
            (r"HKCU\Control Panel\International", "sDecimal", ",", "REG_SZ"),
            (r"HKCU\Control Panel\International", "iDigits", "2", "REG_DWORD"),
            (r"HKCU\Control Panel\International", "sThousand", ".", "REG_SZ"),
            (r"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "EnableLUA", "0", "REG_DWORD"),
            (r"HKLM\SOFTWARE\WOW6432Node\Alterdata\ExpOffLine", "Ativo", "1", "REG_SZ"),
            (r"HKLM\SOFTWARE\WOW6432Node\Alterdata\ExpOffLine", "HabilitaTimeOut", "1", "REG_DWORD"),
            (r"HKLM\SOFTWARE\WOW6432Node\Alterdata\ExpOffLine", "TimeOut", "30", "REG_DWORD"),
            (r"HKLM\SOFTWARE\WOW6432Node\Alterdata\impOffLine", "Ativo", "1", "REG_SZ"),
            (r"HKLM\SOFTWARE\WOW6432Node\Alterdata\impOffLine", "HabilitaTimeOut", "1", "REG_DWORD"),
            (r"HKLM\SOFTWARE\WOW6432Node\Alterdata\impOffLine", "TimeOut", "30", "REG_DWORD"),
        ]

        # Faz a atualização dos registros
        for chave, nome, valor_dado, tipo in ajustes_reg:
            atualiza_label("Ajustando formato de data e hora.")
            try:
                subprocess.run(
                    ["reg", "add", chave, "/v", nome, "/t", tipo, "/d", str(valor_dado), "/f"],
                    check=True,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                    creationflags=subprocess.CREATE_NO_WINDOW
                )
            except subprocess.CalledProcessError:
                erros.append(f"{nome} ({chave}): Falha")
            atualiza_progress()

        #Sincronização de hora no windows 
        try:
            subprocess.run(
                ["w32tm", "/resync"],
                check=False,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                creationflags=subprocess.CREATE_NO_WINDOW
            )
        except Exception:
            erros.append("Falha ao sincronizar o relógio do Windows")


        # -------------------- Finalização da função --------------------
        # Aqui volta o botão ao normal e verifica se teve erros ao longo do processo.
        btn_permissoes.config(state="normal")
        if popup.winfo_exists():
            popup.destroy()

            if erros:
                messagebox.showwarning("Permissões aplicadas, com exceção dos", "\n".join(erros), parent=root)
            else:
                messagebox.showinfo("Sucesso", "Permissões aplicadas com sucesso!", parent=root)

    threading.Thread(target=tarefa_completa, daemon=True).start()


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




#Função para dar permissão de administrador para todos executáveis das pastas citadas:
#C:\Program Files (x86)\Alterdata
#C:\Program Files\PostgreSQL
#C:\ProgramData\Alterdata
#C:\Alterdata


def exe_admin(root, btn_exe_admin):
    btn_exe_admin.config(state="disabled")

    pastas = [
        r"C:\Program Files (x86)\Alterdata",
        r"C:\Program Files\PostgreSQL",
        r"C:\ProgramData\Alterdata",
        r"C:\Alterdata"
    ]

    popup = tk.Toplevel(root)
    popup.title("Aplicando permissões de administrador")
    popup.geometry("520x150")
    popup.resizable(False, False)

    label_info = tk.Label(popup, text="Iniciando...", wraplength=500, justify="left", anchor="w")
    label_info.pack(pady=10, fill="x", padx=10)

    progress = tb.Progressbar(popup, length=480, mode='determinate', bootstyle="success")
    progress.pack(pady=5)

    def fechar_popup():
        if popup.winfo_exists():
            popup.destroy()
        btn_exe_admin.config(state="normal")
    popup.protocol("WM_DELETE_WINDOW", fechar_popup)

    exe_files = []
    for pasta in pastas:
        if os.path.exists(pasta):
            for root_dir, _, files in os.walk(pasta):
                for f in files:
                    if f.lower().endswith(".exe"):
                        exe_files.append(os.path.join(root_dir, f))

    total = len(exe_files)
    progress["maximum"] = max(1, total)

    # --- Helpers de registro ---
    KEY_PATH = r"Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
    VALUE_DATA = "~ RUNASADMIN"  

    def set_layer_for_view(exe_path, hive, view_flag):
        access = winreg.KEY_SET_VALUE | view_flag
        key = winreg.CreateKeyEx(hive, KEY_PATH, 0, access)
        winreg.SetValueEx(key, exe_path, 0, winreg.REG_SZ, VALUE_DATA)
        winreg.CloseKey(key)

    def set_layer_all_views(exe_path, hive, try_both_views=True):
        errors_local = []
        views = [winreg.KEY_WOW64_64KEY, winreg.KEY_WOW64_32KEY] if try_both_views else [0]
        for v in views:
            try:
                set_layer_for_view(exe_path, hive, v)
            except Exception as e:
                errors_local.append((v, e))
        return errors_local

    def is_admin():
        try:
            return bool(ctypes.windll.shell32.IsUserAnAdmin())
        except Exception:
            return False

    def tarefa():
        errs = []
        admin = is_admin()

        def ui(i, path):
            if popup.winfo_exists():
                label_info.config(text=f"Aplicando ({i}/{total}):\n{path}")
                progress["value"] = i

        for i, exe_path in enumerate(exe_files, 1):
            if not popup.winfo_exists():
                return
            popup.after(0, ui, i, exe_path)

            try:
                set_layer_all_views(exe_path, winreg.HKEY_CURRENT_USER)

                if admin:
                    set_layer_all_views(exe_path, winreg.HKEY_LOCAL_MACHINE)
            except Exception as e:
                errs.append((exe_path, e))

        def fim():
            fechar_popup()
            if errs:
                msg = (f"Concluído com alertas.\n"
                       f"Aplicado em {total - len(errs)} de {total} executáveis.\n"
                       f"Alguns falharam (permissão/arquivo protegido/rede).")
                messagebox.showwarning("Concluído", msg)
            else:
                messagebox.showinfo("Sucesso", f"Aplicado em {total} executáveis.")
        root.after(0, fim)

    threading.Thread(target=tarefa, daemon=True).start()

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




#Função que faz o registro da Midas.DLL, verificando se é 32 ou 64 bits.


def registra_midas(root, btn_registra_midas):
    btn_registra_midas.config(state="disabled")

    # Verifica privilégios de administrador
    try:
        subprocess.run("openfiles >nul 2>&1", check=True, shell=True)
    except subprocess.CalledProcessError:
        messagebox.showerror("Erro", "Execute este programa como administrador.")
        btn_registra_midas.config(state="normal")
        return

    # Define caminhos possíveis das DLLs
    dlls = []

    dll32_origem = r"C:\Program Files\Alterdata\Biblioteca\midas.dll"
    dll64_origem = r"C:\Program Files (x86)\Alterdata\Biblioteca\midas.dll"



    is_64bits = platform.machine().endswith("64")

    # Define destinos corretos
    if is_64bits:
        if os.path.exists(dll32_origem):
            dlls.append((dll32_origem, r"C:\Windows\SysWOW64\midas.dll"))
        if os.path.exists(dll64_origem):
            dlls.append((dll64_origem, r"C:\Windows\System32\midas.dll"))
    else:
        if os.path.exists(dll32_origem):
            dlls.append((dll32_origem, r"C:\Windows\System32\midas.dll"))

    if not dlls:
        messagebox.showerror("Erro", "Nenhuma DLL midas.dll encontrada para registro.")
        btn_registra_midas.config(state="normal")
        return

    sucesso = []
    falha = []

    for origem, destino in dlls:
        try:
            # Copia somente se o destino não existir
            if not os.path.exists(destino):
                shutil.copy2(origem, destino)

            # Registra a DLL
            cmd = f'regsvr32 "{destino}"'
            subprocess.run(cmd, check=True, shell=True)
            sucesso.append(destino)
        except subprocess.CalledProcessError as e:
            falha.append(destino)
            print(f"Erro ao registrar {destino}: {e}")
        except PermissionError:
            falha.append(destino)
            print(f"Arquivo em uso ou sem permissão: {destino}")
        except Exception as e:
            falha.append(destino)
            print(f"Erro inesperado: {destino} - {e}")

    msg = ""
    if sucesso:
        msg += f"Registrado com sucesso:\n" + "\n".join(sucesso) + "\n"
    if falha:
        msg += f"Falha ao registrar:\n" + "\n".join(falha) + "\n"
        msg += "Verifique se os programas que usam a DLL estão fechados e execute como administrador."

    if falha:
        messagebox.showerror("Registro de Midas", msg)
    else:
        messagebox.showinfo("Registro de Midas", msg)

    btn_registra_midas.config(state="normal")
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




#Função que faz a otimização no banco de dados
#Função que faz a otimização no banco de dados
def otimiza_banco(root, frame_menu, versao):

    stop_event = threading.Event()

    frame_otimiza = tb.Frame(root, padding=20)
    frame_otimiza.place(relx=0, rely=0, relwidth=1, relheight=1)

    # ================= STATUS NO TOPO =================
    if hasattr(frame_otimiza, "status_label") and frame_otimiza.status_label.winfo_exists():
        frame_otimiza.status_label.destroy()

    frame_otimiza.status_label = tb.Label(frame_otimiza, text="",
                                          bootstyle="light")
    frame_otimiza.status_label.pack(pady=5)
    # ==================================================

    def atualizar_status(msg):
        root.after(0, lambda: frame_otimiza.status_label.config(text=msg))

    tb.Label(frame_otimiza, text="Otimizar Banco de Dados",
             font=("Segoe UI", 20, "bold"), bootstyle="light").pack(pady=10)

    progress = tb.Progressbar(frame_otimiza, length=380, mode="indeterminate")
    progress.pack(pady=10)

    frame_radios = tb.Frame(frame_otimiza)
    frame_radios.pack(fill="both", expand=True, pady=5)

    label_info = tb.Label(frame_otimiza, text="Clique em iniciar para buscar arquivos...", wraplength=380)
    label_info.pack(pady=5)

    label_alteracoes = tb.Label(frame_otimiza, text="", wraplength=380)
    label_alteracoes.pack(pady=5)

    radios = []
    arquivo_selecionado = tb.StringVar()

    frame_predef = tb.Frame(frame_otimiza)   # predefinições
    frame_acoes = tb.Frame(frame_otimiza)    # ações
    frame_footer = tb.Frame(frame_otimiza)   # rodapé
    frame_footer.pack(side="bottom", fill="x", pady=5)


    # ====================== VOLTAR ======================
    def voltar():
        stop_event.set()
        progress.stop()
        label_info.config(text="Clique em iniciar para buscar arquivos...")
        label_alteracoes.config(text="")
        for r in radios:
            r.destroy()
        radios.clear()
        frame_otimiza.destroy()
        frame_menu.tkraise()

    # ====================== FUNÇÃO DE APLICAÇÃO DE PREDEF ======================
    def aplicar_predef(predef):
        arquivo_Banco = arquivo_selecionado.get()
        if not arquivo_Banco:
            messagebox.showwarning("Atenção", "Selecione um arquivo para otimizar.")
            return

        backup_path = arquivo_Banco + ".bak"
        if not Path(backup_path).exists():
            shutil.copy2(arquivo_Banco, backup_path)

        config_map = {
            "1": {"max_connections": 100, "shared_buffers": "400MB",
                  "work_mem": "10MB", "maintenance_work_mem": "110MB", "max_locks_per_transaction": 300},
            "2": {"max_connections": 120, "shared_buffers": "800MB",
                  "work_mem": "20MB", "maintenance_work_mem": "210MB", "max_locks_per_transaction": 400},
            "3": {"max_connections": 150, "shared_buffers": "1600MB",
                  "work_mem": "40MB", "maintenance_work_mem": "310MB", "max_locks_per_transaction": 400},
            "4": {"max_connections": 300, "shared_buffers": "2900MB",
                  "work_mem": "60MB", "maintenance_work_mem": "700MB", "max_locks_per_transaction": 400}
        }

        cfg = config_map[predef]

        with open(arquivo_Banco, "r", encoding="utf-8") as f:
            linhas = f.readlines()

        def atualizar(linhas, chave, valor):
            import re
            padrao = re.compile(rf"^\s*#?\s*{chave}\s*=\s*\S+", re.IGNORECASE)
            for i, linha in enumerate(linhas):
                if padrao.match(linha):
                    linhas[i] = f"{chave} = {valor}\n"
            return linhas

        for chave, valor in cfg.items():
            linhas = atualizar(linhas, chave, valor)

        with open(arquivo_Banco, "w", encoding="utf-8") as f:
            f.writelines(linhas)

        label_alteracoes.config(text="\n".join(f"{k} = {v}" for k, v in cfg.items()))
        label_info.config(text=f"O arquivo {arquivo_Banco} foi configurado com as seguintes informações:")

    # ====================== FUNÇÃO DE REINÍCIO DO POSTGRES ======================
    def reiniciar_postgres():
        def task():
            try:
                # Versões e serviços possíveis
                versoes = [
                    {
                        "versao": "11",
                        "base_path": r"C:\Program Files\PostgreSQL\11",
                        "servicos": ["postgresql-11", "postgresql-x64-11"],
                        "reset_exe": r"C:\Program Files\PostgreSQL\11\bin\pg_resetwal.exe"
                    },
                    {
                        "versao": "9.6",
                        "base_path": r"C:\Program Files\PostgreSQL\9.6",
                        "servicos": ["postgresql-9.6", "postgresql-x64-9.6"],
                        "reset_exe": r"C:\Program Files\PostgreSQL\9.6\bin\pg_resetxlog.exe"
                    }
                ]

                atualizar_status("Finalizando processos PostgreSQL...")
                
                executaveis_pg = [
                    "postgres.exe",
                    "postmaster.exe",
                    "pg_ctl.exe",
                    "pg_ctl64.exe",
                    "postgresql.exe"
                ]
                            
                for exe in executaveis_pg:
                    subprocess.run(["taskkill", "/F", "/IM", exe, "/T"],
                               check=False, capture_output=True)

                sleep(1)

                reiniciado = False

                for v in versoes:
                    base = v["base_path"]
                    data_dir = fr"{base}\data"
                    reset_exe = v["reset_exe"]
                    servicos = v["servicos"]
                    

                    # ------------- verifica se a versão existe -------------
                    if not os.path.exists(base):
                        continue  # não instalado

                    atualizar_status(f"Processando PostgreSQL {v['versao']}...")

                    # ------------- Excluir postmaster.pid -------------
                    pid_file = os.path.join(data_dir, "postmaster.pid")
                    atualizar_status(f"Excluindo postmaster.pid ({v['versao']})...")
                    if os.path.exists(pid_file):
                        try:
                            os.remove(pid_file)
                        except Exception as e:
                            atualizar_status(f"Erro ao excluir PID: {e}")

                    sleep(1)

                    # ------------- Executar pg_resetwal/pg_resetxlog -------------
                    if os.path.exists(reset_exe):
                        atualizar_status(f"Reiniciando WAL/XLOG ({v['versao']})...")
                        subprocess.run([reset_exe, "-f", data_dir],
                                       check=True, capture_output=True)
                    else:
                        atualizar_status(f"Reset não encontrado: {reset_exe}")
                        continue

                    sleep(1)

                    # ------------- Tentar todos os nomes de serviço possíveis -------------
                    for servico in servicos:
                        atualizar_status(f"Iniciando serviço {servico}...")
                        result = subprocess.run(
                            ["net", "start", servico],
                            check=False, capture_output=True, text=True
                        )

                        # verifica sucesso
                        if ("iniciado" in result.stdout.lower()
                                or "running" in result.stdout.lower()
                                or "sucesso" in result.stdout.lower()):
                            atualizar_status(f"PostgreSQL {v['versao']} iniciado com sucesso!")
                            sleep(5)
                            reiniciado = True
                            break  # serviço certo encontrado e iniciado

                    if reiniciado:
                        break  # para na primeira versão que subir

                if not reiniciado:
                    messagebox.showerror(
                        "Erro",
                        "Não foi possível iniciar nenhuma versão do PostgreSQL.\n"
                        "Verifique se o serviço está instalado corretamente."
                    )

            except Exception as e:
                messagebox.showerror("Erro", str(e))

            atualizar_status("")
            btn_Voltar.config(state="normal")
            Btn_reinicia_postgres.config(state="normal")

        threading.Thread(target=task, daemon=True).start()


    # ====================== FUNÇÃO DE BUSCA ======================
    def busca_arquivos():
        radios.clear()
        arquivo_selecionado.set("")
        label_alteracoes.config(text="")
        for w in frame_radios.winfo_children():
            w.destroy()
        for w in frame_predef.winfo_children():
            w.destroy()
        frame_predef.pack_forget()
        for w in frame_acoes.winfo_children():
            w.destroy()
        frame_acoes.pack_forget()

        label_info.config(text="Buscando arquivos postgresql.conf...")
        progress.start(10)

        arquivos_encontrados = []

        try:
            padroes = [r"C:\Program Files\PostgreSQL", r"C:\Program Files (x86)\PostgreSQL"]
            for base in padroes:
                base_path = Path(base)
                if not base_path.exists():
                    continue
                for root, dirs, files in os.walk(base_path):
                    if "postgres.exe" in files:
                        data_dir = Path(root).parent / "data"
                        conf_path = data_dir / "postgresql.conf"
                        if conf_path.exists():
                            arquivos_encontrados.append(str(conf_path))

            if not arquivos_encontrados:
                raise ValueError("Nenhum arquivo postgresql.conf encontrado. Verifique se o PostgreSQL está instalado.")

        except Exception as e:
            progress.stop()
            btn_iniciar.config(state="normal")
            messagebox.showerror("Erro", str(e))
            return

        progress.stop()
        progress.config(mode="determinate", value=100)
        btn_iniciar.config(state="normal")

        # ====================== MOSTRAR MEMÓRIA RAM ======================
        memoria_total = psutil.virtual_memory().total
        memoria_gb = round(memoria_total / (1024 ** 3), 2)

        label_info.config(
            text=f"Agora, selecione o arquivo que quer otimizar e selecione uma opção abaixo:\n"
                 f"Memória RAM total detectada: {memoria_gb} GB"
        )

        frame_botoes_iniciais.pack_forget()
        contador = 1
        for caminho in arquivos_encontrados:
            r = tb.Radiobutton(frame_radios, text=f"{contador} - {caminho}",
                               variable=arquivo_selecionado, value=caminho, bootstyle="round-toggle")
            r.pack(anchor="w", pady=2)
            radios.append(r)
            contador += 1

        # Botões de predefinição
        frame_predef.pack(pady=5)
        tb.Button(frame_predef, text="4GB de ram", bootstyle="info",
                  command=lambda: aplicar_predef("1")).pack(side="left", padx=3)
        tb.Button(frame_predef, text="6GB de ram", bootstyle="info",
                  command=lambda: aplicar_predef("2")).pack(side="left", padx=3)
        tb.Button(frame_predef, text="8GB de ram", bootstyle="info",
                  command=lambda: aplicar_predef("3")).pack(side="left", padx=3)
        tb.Button(frame_predef, text="16GB de ram", bootstyle="info",
                  command=lambda: aplicar_predef("4")).pack(side="left", padx=3)

        # Botões de ação
        frame_acoes.pack(pady=10)
        tb.Button(frame_acoes, text="Buscar novamente", bootstyle="warning",
                  command=iniciar_busca).pack(side="left", padx=5)
        global Btn_reinicia_postgres
        Btn_reinicia_postgres = tb.Button(frame_acoes, text="Reiniciar Serviço Postgres", bootstyle="success",
                                          command=reiniciar_postgres)
        Btn_reinicia_postgres.pack(side="left", padx=5)

    # ====================== INICIAR BUSCA ======================
    def iniciar_busca():
        for r in radios:
            r.destroy()
        radios.clear()
        arquivo_selecionado.set("")
        label_alteracoes.config(text="")
        label_info.config(text="Buscando arquivos postgresql.conf...")
        btn_iniciar.config(state="disabled")
        stop_event.clear()
        threading.Thread(target=busca_arquivos, daemon=True).start()

    # ---------------- BOTÃO INICIAR ----------------
    frame_botoes_iniciais = tb.Frame(frame_otimiza)
    frame_botoes_iniciais.pack(pady=10)
    btn_iniciar = tb.Button(frame_botoes_iniciais, text="Iniciar", bootstyle="success",
                            command=iniciar_busca)
    btn_iniciar.pack(side="left", padx=5)

    # ---------------- RODAPÉ ----------------
    btn_Voltar = tb.Button(frame_footer, text="⬅ Voltar ao Menu", bootstyle="secondary",
              command=voltar)
    btn_Voltar.pack(side="left", padx=5)


    frame_otimiza.tkraise()



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




#Função para reiniciar o postgres com resetxlog ou resetWal




def is_admin():
    """Verifica se o script está rodando com privilégios de Administrador."""
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except Exception:
        return False


def reinicia_postgres(root, btn_reinicia_postgres):
    
    # --- VERIFICAÇÃO DE ADMIN ---
    if not is_admin():
        messagebox.showerror("Erro de Permissão", 
                             "Esta ação requer privilégios de Administrador.\n\n"
                             "Por favor, reinicie o aplicativo como Administrador.")
        return


    confirmar = messagebox.askyesno(
        "Confirmação",
        "Essa ação vai reiniciar o PostgreSQL e irá derrubar o sistema em todas as máquinas.\n\nDeseja continuar?"
    )
    if not confirmar:
        return 


    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()

    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.after(0, lambda: root.status_label.config(text=msg))


    def task():
        try:
            # Versões e serviços possíveis
            versoes = [
                {
                    "versao": "11",
                    "base_path": r"C:\Program Files\PostgreSQL\11",
                    "servicos": ["postgresql-11", "postgresql-x64-11"],
                    "reset_exe": r"C:\Program Files\PostgreSQL\11\bin\pg_resetwal.exe"
                },
                {
                    "versao": "9.6",
                    "base_path": r"C:\Program Files\PostgreSQL\9.6",
                    "servicos": ["postgresql-9.6", "postgresql-x64-9.6"],
                    "reset_exe": r"C:\Program Files\PostgreSQL\9.6\bin\pg_resetxlog.exe"
                }
            ]

            atualizar_status("Finalizando processos PostgreSQL...")
            subprocess.run(["taskkill", "/F", "/IM", "postgres.exe", "/T"],
                           check=False, capture_output=True)

            sleep(1)

            reiniciado = False

            for v in versoes:
                base = v["base_path"]
                data_dir = fr"{base}\data"
                reset_exe = v["reset_exe"]
                servicos = v["servicos"]

                # ------------- verifica se a versão existe -------------
                if not os.path.exists(base):
                    continue  # não instalado

                atualizar_status(f"Processando PostgreSQL {v['versao']}...")

                # ------------- Excluir postmaster.pid -------------
                pid_file = os.path.join(data_dir, "postmaster.pid")
                atualizar_status(f"Excluindo postmaster.pid ({v['versao']})...")
                if os.path.exists(pid_file):
                    try:
                        os.remove(pid_file)
                    except Exception as e:
                        atualizar_status(f"Erro ao excluir PID: {e}")

                sleep(1)

                # ------------- Executar pg_resetwal/pg_resetxlog -------------
                if os.path.exists(reset_exe):
                    atualizar_status(f"Reiniciando WAL/XLOG ({v['versao']})...")
                    subprocess.run([reset_exe, "-f", data_dir],
                                   check=True, capture_output=True)
                else:
                    atualizar_status(f"Reset não encontrado: {reset_exe}")
                    continue

                sleep(1)

                # ------------- Tentar todos os nomes de serviço possíveis -------------
                for servico in servicos:
                    atualizar_status(f"Iniciando serviço {servico}...")
                    result = subprocess.run(
                        ["net", "start", servico],
                        check=False, capture_output=True, text=True
                    )
                    
                    # verifica sucesso
                    if ("iniciado" in result.stdout.lower()
                            or "running" in result.stdout.lower()
                            or "sucesso" in result.stdout.lower()):
                        atualizar_status(f"PostgreSQL {v['versao']} iniciado com sucesso!")
                        reiniciado = True
                        break  # serviço certo encontrado e iniciado

                if reiniciado:
                    break  # para na primeira versão que subir

            # ------------------ Resultado final ------------------
            if reiniciado:
                root.after(0, lambda: messagebox.showinfo(
                    "Sucesso",
                    f"Processo finalizado com sucesso.\n(PostgreSQL {'versao'} )"
                ))
            else:
                atualizar_status("Nenhum serviço conseguiu iniciar.")
                root.after(0, lambda: messagebox.showerror(
                    "Erro",
                    "Não foi possível iniciar nenhuma versão do PostgreSQL (9.6 ou 11)."
                ))

        except Exception as e:
            atualizar_status(f"Erro: {e}")
            root.after(0, lambda: messagebox.showerror(
                "Erro",
                f"Ocorreu um erro: {e}"
            ))

        finally:
            root.after(0, lambda: btn_reinicia_postgres.config(state="normal"))



    btn_reinicia_postgres.config(state="disabled")
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




#Função que desinstala o updater e reinstala


def reinstalar_updater(root, btn_reinstalar_updater):
    
    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()

    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)


    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()

    def task():
        try:
            url = "https://www.dropbox.com/scl/fi/wml4pwdj59sfefomwd3fw/Updater-8.10.3.0.exe?rlkey=lxqck6zvaf92yadcu2hnmrm1g&st=m7yt85cn&dl=1"
            caminhos = [
                r"C:\Program Files (x86)\Alterdata\Updater\unins000.exe",
                r"C:\Program Files\Alterdata\Updater\unins000.exe",
            ]

            
            # ================== 1. DESINSTALAR ==================
            atualizar_status("Procurando instaladores existentes...")
            for uninstaller in caminhos:
                if os.path.exists(uninstaller):
                    pasta = os.path.dirname(uninstaller)
                    atualizar_status(f"Desinstalando Updater em: {pasta}")
                    subprocess.run([uninstaller, "/SILENT", "/VERYSILENT", "/NORESTART"], check=False)

                    guardian = os.path.join(pasta.replace("Updater", "Updater-Guardian"), "unins000.exe")
                    if os.path.exists(guardian):
                        atualizar_status("Desinstalando Updater-Guardian...")
                        subprocess.run([guardian, "/SILENT", "/VERYSILENT", "/NORESTART"], check=False)

                    atualizar_status("Updater desinstalado com sucesso.")
                    break

            # ================== 2. DOWNLOAD ==================
            destino_dir = Path(r"C:\ProgramData\Alterdata\Cirrus")
            destino_dir.mkdir(parents=True, exist_ok=True)
            destino = destino_dir / "Updater 8.10.3.0.exe"

            atualizar_status("Baixando o novo Updater...")
            with requests.get(url, stream=True, verify=False) as r:
                r.raise_for_status()
                with open(destino, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status(f"Download concluído: {destino}")

            # ================== 3. INSTALAR ==================
            atualizar_status("Iniciando instalação do novo Updater...")
            subprocess.Popen([str(destino)], shell=True)

            atualizar_status("Updater iniciado com sucesso!")
            messagebox.showinfo("Sucesso", "Novo Updater baixado e iniciado com sucesso!")

        except Exception as e:
            atualizar_status("Erro durante a reinstalação.")
            messagebox.showerror("Erro", f"Falha ao reinstalar Updater:\n{e}")
        finally:
            atualizar_status("")
            btn_reinstalar_updater.config(state="normal")

    
    btn_reinstalar_updater.config(state="disabled")


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




#Função que faz manutenção no spooler de impressão

def spool_impressao(root, btn_spool_impressao):

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()

    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()

    btn_spool_impressao.config(state="disabled")

    def task():

        try:
            check = subprocess.run(["sc", "query", "spooler"], capture_output=True, text=True)
            if check.returncode != 0 or "FAILED" in check.stdout:
                messagebox.showerror("Erro", "Serviço de spooler não encontrado ou com falha")
                return
            
            temp_spool = r"C:\Windows\System32\spool\PRINTERS"

            atualizar_status("Parando o Spooler de impressão")

            subprocess.run(["net", "stop", "spooler"], check=True)

            #Faz a limpeza na pasta do spooler
            if os.path.exists(temp_spool):
                for arquivo in os.listdir(temp_spool):
                    caminho = os.path.join(temp_spool, arquivo)
                    try:
                        atualizar_status("Apagando arquivos temporários do Spooler")
                        os.remove(caminho)
                    except Exception as e:
                        messagebox.showerror("Erro", f"Falha ao limpar arquivos temporários do spooler de impressão:\n{e}")

            atualizar_status("Iniciando serviço Spooler de impressão")
            subprocess.run(["net", "start", "spooler"], check=True)
            atualizar_status("")
            messagebox.showinfo("Sucesso", "Spool de impressão limpo com sucesso!")
        except Exception as e:
            messagebox.showerror("Erro", f"Falha ao limpar spool de impressão:\n{e}")
        finally:
            btn_spool_impressao.config(state="normal")  # só libera quando a thread terminar
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

