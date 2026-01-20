import ttkbootstrap as tb
from ttkbootstrap.constants import *
from ttkbootstrap.tooltip import ToolTip
from ttkbootstrap.dialogs import Messagebox
from Functions import (
    ajuda, permissoes, Add_sites, exe_admin, registra_midas,
    otimiza_banco, reinicia_postgres, reinstalar_updater,
    spool_impressao, 
    
)
from Function_Download import (
    ajuda_download, Tree_Size, nfeasy_diagnostico, DBMonitor, AlterdataManager2_3, AlterdataManager3_7,
    pgadmin3, pgadmin4, Postgres9_6, Postgres11, importa_nfe_nfce, xml_para_dat, 
    OpenDataSet, teste_balanca, TEF_Gertec, PG_Migrator, PackClean)

from Function_printer import ajuda_impressora, baixar_driver_por_modelo, copiar_link

'''
Todos os links de drivers, estão upados em uma conta do dropbox. 

Comando para transformar em .exe: 
pyinstaller --noconsole --onefile --icon=Logo.ico facilitator.py
'''

versao = "3.1"
# ----------------- Popup de novidades -----------------
def mostrar_novidades():
    novidades = (
        "- Ajustado o download do Postgres 9.6.\n"
        "- Adicionado download do banco de dados PostgreSQL, tendo as versões 9.6 e 11\n"
        "- Adicionado download do OpenDataSet (Leitor de Dats)\n"
        "- Adicionado download do Tree Size V4.8.1.\n"
        "- Agora na função de liberar permissões, é ativado o Firewall para conexões de entrada e também desabilita notificações dele.\n"
        "- Correção da reinicialização postgres 11 quando é feita a otimização.\n"
        "- Adicionado download do manager 2.3.\n"
    )
    Messagebox.show_info(novidades, f"📌 Novidades da Versão {versao}")


# ----------------- Configurações -----------------
root = tb.Window(themename="darkly")
root.title("Facilitator")

senha_sistema = "#abc123#"

largura = 440
altura = 540

largura_tela = root.winfo_screenwidth()
altura_tela = root.winfo_screenheight()

pos_x = (largura_tela // 2) - (largura // 2)
pos_y = (altura_tela // 2) - (altura // 2)

root.geometry(f"{largura}x{altura}+{pos_x}+{pos_y}")
root.resizable(False, False)


# ----------------- Função de autenticação -----------------
def autenticar():
    senha = entry_senha.get().strip()
    if senha == senha_sistema:
        frame_menu.tkraise()
    else:
        mensagem.config(text="Senha inválida.\nDica: Senha do banco de dados")


# ----------------- Frame de Login -----------------
frame_login = tb.Frame(root, padding=20)
frame_login.place(relx=0, rely=0, relwidth=1, relheight=1)

tb.Label(frame_login, text="Login", font=("Segoe UI", 30, "bold"), bootstyle="light").pack(pady=(0,10))

senha_frame = tb.Frame(frame_login)
senha_frame.pack(pady=5, fill="x")

tb.Label(senha_frame, text="Senha:", bootstyle="light").pack(side="left", padx=(20,5))
entry_senha = tb.Entry(senha_frame, width=40, show="*")
entry_senha.pack(side="left", padx=(0,0))
entry_senha.focus_set() 

OLHO_ABERTO = "\U0001F441"  # 👁
OLHO_FECHADO = "\U0001F576" # 🕶

mostrar = False
def toggle_senha():
    global mostrar
    if mostrar:
        entry_senha.config(show="*")
        btn_mostrar.config(text=OLHO_ABERTO)
        mostrar = False
    else:
        entry_senha.config(show="")
        btn_mostrar.config(text=OLHO_FECHADO)
        mostrar = True

btn_mostrar = tb.Button(senha_frame, text=OLHO_ABERTO, bootstyle="secondary", command=toggle_senha)
btn_mostrar.pack(side="left", padx=(5,20))
ToolTip(btn_mostrar, text="Mostrar/Ocultar senha")

entry_senha.bind("<Return>", lambda event: autenticar())

mensagem = tb.Label(frame_login, text="", bootstyle="danger")
mensagem.pack(pady=5)

btn_login = tb.Button(frame_login, text="Entrar", bootstyle="success", command=autenticar)
btn_login.pack(pady=10)

# Rodapé com versão
lbl_versao_login = tb.Label(
    frame_login, 
    text=f"Versão {versao}",
    font=("Segoe UI", 9, "underline"),
    bootstyle="info"
    )
lbl_versao_login.pack(pady=2)

# Rodapé com informação
lbl_nome_login = tb.Label(
    frame_login,
    text="Rode como administrador para funcionar corretamente.",
    font=("Segoe UI", 9),
    bootstyle="secondary"
)
lbl_nome_login.pack(pady=(2))

# Rodapé com nome
lbl_nome_login = tb.Label(
    frame_login,
    text="Feito por Gustavo.angra",
    font=("Segoe UI", 9),
    bootstyle="secondary"
)
lbl_nome_login.pack(pady=(0,5))



lbl_versao_login.bind("<Enter>", lambda e: lbl_versao_login.config(cursor="hand2"))
lbl_versao_login.bind("<Leave>", lambda e: lbl_versao_login.config(cursor=""))
lbl_versao_login.bind("<Button-1>", lambda e: mostrar_novidades())


# ----------------- Funções auxiliares -----------------
def criar_botao(frame, texto, comando, ajuda_cmd=None):
    row = tb.Frame(frame)
    row.pack(fill="x", pady=5)

    btn = tb.Button(
        row,
        text=texto,
        bootstyle=("success", "outline", "toolbutton"),
        width=38
    )
    btn.pack(side="left", fill="x", expand=True)
    btn.config(command=lambda b=btn: comando(root, b))

    if ajuda_cmd is not None:
        ajuda_btn = tb.Button(
            row,
            text="?",
            bootstyle="info-outline",
            command=ajuda_cmd,
            width=3
        )
        ajuda_btn.pack(side="left", padx=5)
        ToolTip(ajuda_btn, text=f"Clique aqui para saber mais sobre a função.")

    return btn




def criar_frame(titulo, frame_pai=None):
    #Cria um frame genérico com título e botão de voltar (se houver pai).
    frame = tb.Frame(root, padding=20)
    frame.place(relx=0, rely=0, relwidth=1, relheight=1)

    tb.Label(frame, text=titulo, font=("Segoe UI", 20, "bold"), bootstyle="light").pack(pady=(0, 5))

    btn_voltar = None
    if frame_pai:
        btn_voltar = tb.Button(
            frame,
            text="⬅ Voltar",
            bootstyle="secondary",
            command=lambda: frame_pai.tkraise()
        )
        btn_voltar.pack(side="bottom")

    return frame, btn_voltar


# ----------------- Frames principais -----------------
frame_menu, _ = criar_frame("Menu de Opções")
frame_downloads, btn_voltar_downloads = criar_frame("Baixar Programas", frame_menu)
frame_impressoras, btn_voltar_impressoras = criar_frame("Impressoras", frame_menu)

# --------- Subframes gerais ---------
frame_alterdataManager, btn_voltar_alterdataManager = criar_frame("Baixar Programas -> Manager", frame_downloads) # SubFrame para AlterdataManager
frame_pgadmin, btn_voltar_pgadmin = criar_frame("Baixar Programas -> PGAdmin", frame_downloads) # SubFrame para PGAdmin
frame_Postgres, btn_voltar_Postgres = criar_frame("Baixar Programas -> Postgres", frame_downloads) #SubFrame para Postgres
frame_downloads_shop, btn_voltar_downloads_shop = criar_frame("Baixar Programas -> App Shop", frame_downloads) # SubFrame para os aplicativos SHOP
frame_downloads_pack, btn_voltar_downloads_pack = criar_frame("Baixar Programas -> App Pack", frame_downloads) # SubFrame para os aplicativos PACK
frame_etiqueta, btn_voltar_etiquetas = criar_frame("Impressoras -> Etiquetas", frame_impressoras) # SubFrame para as etiquetadoras


# --------- Subframes de impressoras por marca ---------
frame_bematech, btn_voltar_bematech = criar_frame("Impressoras -> Bematech", frame_impressoras)
frame_controlID, btn_voltar_controlID = criar_frame("Impressoras -> Control ID", frame_impressoras)
frame_daruma, btn_voltar_daruma = criar_frame("Impressoras -> Daruma", frame_impressoras)
frame_elgin, btn_voltar_elgin = criar_frame("Impressoras -> Elgin", frame_impressoras)
frame_epson, btn_voltar_epson = criar_frame("Impressoras -> Epson", frame_impressoras)
frame_gertec, btn_voltar_gertec = criar_frame("Impressoras -> Gertec", frame_impressoras)
frame_sweda, btn_voltar_sweda = criar_frame("Impressoras -> Sweda", frame_impressoras)

# Etiquetadoras

frame_argox, btn_voltar_argox = criar_frame("Etiquetas -> Argox", frame_etiqueta)
frame_brother, btn_voltar_brother = criar_frame("Etiquetas -> Brother", frame_etiqueta)
frame_zebra, btn_voltar_zebra = criar_frame("Etiquetas -> Zebra", frame_etiqueta)


# ----------------- Botões do menu principal -----------------
criar_botao(frame_menu, "Adiciona sites da Alterdata", Add_sites, lambda: ajuda("sites"))
criar_botao(frame_menu, "Liberar Permissões", permissoes, lambda: ajuda("permissoes"))
criar_botao(frame_menu, "Colocar executáveis como administrador", exe_admin, lambda: ajuda("exe_admin"))
criar_botao(frame_menu, "Manutenção e Registro Midas.Dll", registra_midas, lambda: ajuda("registra_midas"))
criar_botao(frame_menu, "Otimizar Banco de dados (servidor)", lambda root, btn: otimiza_banco(root, frame_menu, versao), lambda: ajuda("otimiza_banco"))
criar_botao(frame_menu, "Reiniciar o postgres com ResextLog/ResetWal", reinicia_postgres, lambda: ajuda("reinicia_postgres"))
criar_botao(frame_menu, "Reinstalar Updater Manager", reinstalar_updater, lambda: ajuda("reinstalar_updater"))
criar_botao(frame_menu, "Manutenção no Spooler de Impressão", spool_impressao, lambda: ajuda("spool_impressao"))
criar_botao(frame_menu, "Baixar Programas", lambda root, btn: frame_downloads.tkraise(), lambda: ajuda_download("downloads"))
criar_botao(frame_menu, "Impressoras", lambda root, btn: frame_impressoras.tkraise(), lambda: ajuda_impressora("Impressoras"))



# ----------------- Botões do menu de Download -----------------

criar_botao(frame_downloads, "Tree Size", lambda root, btn: Tree_Size(root, btn, btn_voltar_downloads), lambda: ajuda_download("Tree_Size"))
criar_botao(frame_downloads, "NFeasy Diagnóstico", lambda root, btn: nfeasy_diagnostico(root, btn, btn_voltar_downloads), lambda: ajuda_download("nfeasy_diagnostico"))
criar_botao(frame_downloads, "DBMonitor", lambda root, btn: DBMonitor(root, btn, btn_voltar_downloads), lambda: ajuda_download("DBMonitor"))

# ----------------- Botões do menu do AlterdataManager -----------------
criar_botao(frame_downloads, "Alterdata Manager", lambda root, btn: frame_alterdataManager.tkraise(), lambda: ajuda_download("AlterdataManager"))
criar_botao(frame_alterdataManager, "Alterdata Manager 2.3", lambda root, btn: AlterdataManager2_3(root, btn, btn_voltar_alterdataManager), lambda: ajuda_download("AlterdataManager2_3"))
criar_botao(frame_alterdataManager, "Alterdata Manager 3.7", lambda root, btn: AlterdataManager3_7(root, btn, btn_voltar_alterdataManager), lambda: ajuda_download("AlterdataManager3_7"))

# --------------------- Botões do menu de PGAdmin ----------------------
criar_botao(frame_downloads, "PGAdmin", lambda root, btn: frame_pgadmin.tkraise(), lambda: ajuda_download("download_PGAdmin"))
criar_botao(frame_pgadmin, "PGAdmin3", lambda root, btn: pgadmin3(root, btn, btn_voltar_downloads), lambda: ajuda_download("Pgadmin3"))
criar_botao(frame_pgadmin, "PGAdmin4", lambda root, btn: pgadmin4(root, btn, btn_voltar_downloads), lambda: ajuda_download("Pgadmin4"))

# ------------------- Botões do Submenu de Postgres --------------------

criar_botao(frame_downloads, "Posgtres", lambda root, btn: frame_Postgres.tkraise(), lambda: ajuda_download("Download_Postgre"))
criar_botao(frame_Postgres, "Postgres 9.6 x64", lambda root, btn: Postgres9_6(root, btn, btn_voltar_downloads), lambda: ajuda_download("Postgres9_6"))
criar_botao(frame_Postgres, "Postgres 11 x64", lambda root, btn: Postgres11(root, btn, btn_voltar_downloads), lambda: ajuda_download("Postgres11"))

# ----------------- Botões do Submenu de Download SHOP -----------------

criar_botao(frame_downloads, "Aplicativos Shop", lambda root, btn: frame_downloads_shop.tkraise(), lambda: ajuda_download("download_shop"))
criar_botao(frame_downloads_shop, "Baixar e executar Importador de NFe/NFCE por xml", lambda root, btn: importa_nfe_nfce(root, btn, btn_voltar_downloads_shop), lambda: ajuda_download("importa_nfe_nfce"))
criar_botao(frame_downloads_shop, "Transformar xml em dat", lambda root, btn: xml_para_dat(root, btn, btn_voltar_downloads_shop), lambda: ajuda_download("xml_para_dat"))
criar_botao(frame_downloads_shop, "OpenDataSet (Leitor de Dats)", lambda root, btn: OpenDataSet(root, btn, btn_voltar_downloads_shop), lambda: ajuda_download("OpenDataSet"))
criar_botao(frame_downloads_shop, "Teste de Balança", lambda root, btn: teste_balanca(root, btn, btn_voltar_downloads_shop), lambda: ajuda_download("teste_balanca"))
criar_botao(frame_downloads_shop, "Driver TEF Gertec", lambda root, btn: TEF_Gertec(root, btn, btn_voltar_downloads_shop), lambda: ajuda_download("TEF_Gertec"))


# ----------------- Botões do Submenu de Download PACK -----------------
criar_botao(frame_downloads, "Aplicativos Pack", lambda root, btn: frame_downloads_pack.tkraise(), lambda: ajuda_download("download_pack"))
criar_botao(frame_downloads_pack, "PG Migrator", lambda root, btn: PG_Migrator(root, btn, btn_voltar_downloads_pack), lambda: ajuda_download("PG_Migrator"))
criar_botao(frame_downloads_pack, "Pack Clean", lambda root, btn: PackClean(root, btn, btn_voltar_downloads_pack), lambda: ajuda_download("Pack_Clean"))

# ----------------- Botões do menu de Impressoras -----------------
criar_botao(frame_impressoras, "Bematech", lambda root, btn: frame_bematech.tkraise())
criar_botao(frame_impressoras, "Control ID", lambda root, btn: frame_controlID.tkraise())
criar_botao(frame_impressoras, "Daruma", lambda root, btn: frame_daruma.tkraise())
criar_botao(frame_impressoras, "Elgin", lambda root, btn: frame_elgin.tkraise())
criar_botao(frame_impressoras, "Epson", lambda root, btn: frame_epson.tkraise())
criar_botao(frame_impressoras, "Gertec", lambda root, btn: frame_gertec.tkraise())
criar_botao(frame_impressoras, "Sweda", lambda root, btn: frame_sweda.tkraise())

# Impressoras de Etiquetas
criar_botao(frame_impressoras, "Impressoras de Etiqueta", lambda root, btn: frame_etiqueta.tkraise())
criar_botao(frame_etiqueta, "Argox", lambda root, btn: frame_argox.tkraise())
criar_botao(frame_etiqueta, "Brother", lambda root, btn: frame_brother.tkraise())
criar_botao(frame_etiqueta, "Zebra", lambda root, btn: frame_zebra.tkraise())


# ----------------- Submenus por marca -----------------
# Função para criar o botão com um link para copiar o download
def criar_botao_com_link(frame, modelo, btn_voltar):
    row = tb.Frame(frame)
    row.pack(fill="x", pady=5)

    btn_download = tb.Button(row, text=modelo, bootstyle=("success", "outline", "toolbutton"), width=35)
    btn_download.pack(side="left", fill="x", expand=True)
    btn_download.config(command=lambda b=btn_download: baixar_driver_por_modelo(root, b, btn_voltar, modelo))

    btn_copiar = tb.Button(row, text="🔗", bootstyle="info-outline", width=3, command=lambda m=modelo: copiar_link(m))
    btn_copiar.pack(side="left", padx=5)

    ToolTip(btn_copiar, text=f"Copia o link de download da impressora {modelo}.")


# Bematech
for modelo in ["MP-100S TH", "MP-2500 TH", "MP-4200 TH"]:
    criar_botao_com_link(frame_bematech, modelo, btn_voltar_bematech)

# Control ID
for modelo in ["PrintID"]:
    criar_botao_com_link(frame_controlID, modelo, btn_voltar_controlID)

# Daruma 
for modelo in ["DR700", "DR800"]:
    criar_botao_com_link(frame_daruma, modelo, btn_voltar_daruma)

# Elgin
for modelo in ["Elgin I7", "Elgin I7 Plus", "Elgin I8", "Elgin I9", "Elgin L42 Pro", "Elgin L42 DT"]:
    criar_botao_com_link(frame_elgin, modelo, btn_voltar_elgin)

# Epson
for modelo in ["Epson TM-T20", "Epson TM-T20x", "Epson TM-T81"]:
    criar_botao_com_link(frame_epson, modelo, btn_voltar_epson)

# Gertec 
for modelo in ["Gertec G250"]:
    criar_botao_com_link(frame_gertec, modelo, btn_voltar_gertec)

# Sweda 
for modelo in ["Sweda SI150", "Sweda SI300s"]:
    criar_botao_com_link(frame_sweda, modelo, btn_voltar_sweda)


#--------- Etiquetadoras ---------
# Argox
for modelo in ["Argox CP-2140", "Argox OS-214"]:
    criar_botao_com_link(frame_argox, modelo, btn_voltar_argox)

#Brother
for modelo in ["Brother TD-4100"]:
    criar_botao_com_link(frame_brother, modelo, btn_voltar_brother)

#Zebra
for modelo in ["Zebra ZD 220"]:
    criar_botao_com_link(frame_zebra, modelo, btn_voltar_zebra)


# ----------------- Rodapé -----------------

# Nome
lbl_rodape_nome = tb.Label(
    frame_menu,
    text="Feito por Gustavo.angra",
    font=("Segoe UI", 9),
    bootstyle="secondary",
    anchor="e"
)
lbl_rodape_nome.pack(side="bottom", fill="x", padx=10, pady=(0,5))

# Versão
lbl_versao = tb.Label(
    frame_menu,
    text=f"Versão {versao}",
    font=("Segoe UI", 9, "underline"),
    bootstyle="info",
    anchor="e" 
)
lbl_versao.pack(side="bottom", fill="x", padx=10, pady=(0,0))




lbl_versao.bind("<Enter>", lambda e: lbl_versao.config(cursor="hand2"))
lbl_versao.bind("<Leave>", lambda e: lbl_versao.config(cursor=""))
lbl_versao.bind("<Button-1>", lambda e: mostrar_novidades())


# Inicia na tela de login
frame_login.tkraise()
root.mainloop()
