from tkinter import messagebox, Label
from pathlib import Path
from ttkbootstrap.constants import *
from time import sleep

import pyperclip
import requests
import shutil
import ctypes
import threading
import zipfile



'''
Abaixo tem a função para baixar os drivers e também a central de ajuda do programa. 
As funções presentes no códigos são:

    Central de ajuda:
        ajuda_impressora

    Função de download do driver:
        baixar_driver_por_modelo

'''

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


#--------------- Drivers impressoras ---------------
#Bematech
url_mp_100s_TH  = "https://www.dropbox.com/scl/fi/ragfnyz2wxy6eauvgc9g1/MP-100S-TH.zip?rlkey=ol5s8d3fuphhmcw5m95ct2m3g&st=lmhhlj2x&dl=1"
url_mp_2500_TH  = "https://www.dropbox.com/scl/fi/e89fkft3pkddh7zrbr5g6/MP-2500-TH.zip?rlkey=0qzkalieojkc2digag5v4tc8w&st=hswfas0o&dl=1"
url_mp_4200_TH  = "https://www.dropbox.com/scl/fi/ca8dsfr7soe2clhsigl0p/MP-4200-TH.zip?rlkey=xvmnyw8e2utrmylpd8ihfh227&st=751kev2v&dl=1"

#Control ID
url_printID     = "https://www.dropbox.com/scl/fi/6osmmt3aebgjtlp88yx48/PrintiD.zip?rlkey=8cvyz45k3i3mklm18lyb1cvk7&st=j452zoil&dl=1"

#Daruma
url_DR700       = "https://www.dropbox.com/scl/fi/djls8v77lczyr0hirm216/DR700.zip?rlkey=38zekehqwbta25g8roj87lj5z&st=qqstxnp1&dl=1"
url_DR800       = "https://www.dropbox.com/scl/fi/s73hektzhut5cbx8nao03/DR800.zip?rlkey=m96yo5s0temi0gp00kattq0oh&st=0zspu2o0&dl=1"

#Elgin
url_I7          = "https://www.dropbox.com/scl/fi/aaghw4rcbsftu064fakfl/elgin-i8.zip?rlkey=um57a7zgdzfwwy423u1rw5n1v&st=3pvx4jje&dl=1"
url_I7_Plus     = "https://www.dropbox.com/scl/fi/pws3oe2loqnqy63aydfw7/elgin-i7-Plus.zip?rlkey=yx0d7u8ajew4hfdbecihdb8en&st=2alqdftv&dl=1"
url_I8          = "https://www.dropbox.com/scl/fi/y663va2cpm340ec63cs7q/elgin-i7.zip?rlkey=plnledopdeznjl0s2q2hm08a8&st=nru4ja3v&dl=1"
url_I9          = "https://www.dropbox.com/scl/fi/3mva2zapprh11y8nw3rtj/elgin-i9.zip?rlkey=bdfnr53txsuse259gd03rpcho&st=9b489zmg&dl=1"
url_L42Pro      = "https://www.dropbox.com/scl/fi/8oktwytfgne1f8nmzhb1o/Elgin-L42-Pro.zip?rlkey=sre6a006nue1v415zplhm3q2x&st=a6frtplj&dl=1"
url_L42DT       = "https://www.dropbox.com/scl/fi/n6tc9m2qf1z9pxs7gumum/Elgin-L42-DT.zip?rlkey=necvrqjb2osnty2efhbbbe6m4&st=6seom2uy&dl=1"

#Epson
url_TM_t20      = "https://www.dropbox.com/scl/fi/s7secl9qssuj4h2tuqsdw/Tm-T20.zip?rlkey=aeo2dakbz32bmbwpfaf8xpxoj&st=qcjlk1ww&dl=1"
url_TM_t20x     = "https://www.dropbox.com/scl/fi/fs7kfgg87s5xxqde5i7sg/Tm-T20x.zip?rlkey=a171ncxumf6y4x2d15ktazrep&st=bzp3r53y&dl=1"
url_TM_t81      = "https://www.dropbox.com/scl/fi/qpk5es7o5ry6up9i6mqee/TM-T81.zip?rlkey=i1kiuhdckkaydv19ies3qmzhz&st=j4792u29&dl=1"

#Gertec
url_G250        = "https://www.dropbox.com/scl/fi/xi6s46wbitp1pooi5po7q/Gertec-G250.zip?rlkey=6su8rljuwykn7hqws3zshr7qt&st=mtjsi9kr&dl=1"

#Sweda
url_SI150       = "https://www.dropbox.com/scl/fi/efg012duzepbll4ns8vy8/SI-150.zip?rlkey=6c9pn6p7r6c9oeovu1ug8x7wp&st=b83vgtap&dl=1"
url_SI300s      = "https://www.dropbox.com/scl/fi/hgcoik32f42b0738ckvdn/SI-300s.zip?rlkey=dilufky3oto99jrgyzeoixseo&st=ief98ukj&dl=1"

#Etiquetadoras
#Argox
url_CP_2140     = "https://www.dropbox.com/scl/fi/t2jsa1u4854caw7wg01q8/CP-2140.zip?rlkey=1443rlyczr9jxtm1u8hb8ix1h&st=9qj5l12p&dl=1"
url_OS_214      = "https://www.dropbox.com/scl/fi/qmqe3hyewycrz4368h6s6/OS-214.zip?rlkey=cy5f9blycxpt0igz0k8ioe1kl&st=0ep90vs3&dl=1"

#Brother
url_TD_4100     = "https://www.dropbox.com/scl/fi/gqo7fevj5g4f34bijtqwa/TD-4100N.zip?rlkey=ixadfvgqkqbastz8v47ged6qu&st=2ah9bntj&dl=1"

#Zebra
url_ZD220       = "https://www.dropbox.com/scl/fi/3bswikvrfptmnu4idtqzz/ZD220.zip?rlkey=lun15evun96j73fb8fr7zojhq&st=u232w0dr&dl=1"


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

def ajuda_impressora(tipo):

    # --------------------------- Impressoras ---------------------------
    ajuda = {    
        "Impressoras":"Abre um menu de opções para selecionar o modelo e driver da impressora. Tendo os seguintes modelos:\n\nImpressoras não fiscais:\n Bematech\n Daruma\n Elgin\n Epson\n Gertec\n\nImpressoras de etiquetas:\n Argox\n Brother\n Zebra"
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


# ---------------- Função para pegar a Área de Trabalho ----------------
def get_desktop_path():
    CSIDL_DESKTOP = 0
    SHGFP_TYPE_CURRENT = 0
    buf = ctypes.create_unicode_buffer(260)
    ctypes.windll.shell32.SHGetFolderPathW(None, CSIDL_DESKTOP, None, SHGFP_TYPE_CURRENT, buf)
    return Path(buf.value)

# ---------------- Lista/Dicionário de drivers ----------------
DRIVERS = {
    #Impressoras não fiscais
    #Bematech
    "MP-100S TH"        : url_mp_100s_TH,
    "MP-2500 TH"        : url_mp_2500_TH,
    "MP-4200 TH"        : url_mp_4200_TH,
    #Control ID
    "PrintID"           : url_printID,
    #Daruma
    "DR700"             : url_DR700,
    "DR800"             : url_DR800,
    #Elgin
    "Elgin I7"          : url_I7,
    "Elgin I7 Plus"     : url_I7_Plus,
    "Elgin I8"          : url_I8,
    "Elgin I9"          : url_I9,
    "Elgin L42 Pro"     : url_L42Pro, 
    "Elgin L42 DT"      : url_L42DT,
    #Epson
    "Epson TM-T20"      : url_TM_t20,
    "Epson TM-T20x"     : url_TM_t20x,
    "Epson TM-T81"      : url_TM_t81,
    #Gertec
    "Gertec G250"       : url_G250,
    #Sweda
    "Sweda SI150"       : url_SI150,
    "Sweda SI300s"      : url_SI300s,
    #Etiquetas
    #Argox
    "Argox CP-2140"     : url_CP_2140,
    "Argox OS-214"      : url_OS_214,
    #Brother
    "Brother TD-4100"   : url_TD_4100,
    #Zebra
    "Zebra ZD 220"      : url_ZD220
}

# ---------------- Função para baixar e extrair pelo modelo ----------------
def baixar_driver_por_modelo(root, btn, btn_voltar, modelo):
    if modelo not in DRIVERS:
        messagebox.showerror("Erro", f"Modelo {modelo} não encontrado na lista de drivers.")
        return

    url = DRIVERS[modelo]
    nome_arquivo_zip = f"{modelo.replace(' ','')}.zip"
    nome_pasta = modelo

    btn.config(state="disabled")
    btn_voltar.config(state="disabled")

    if hasattr(root, "status_label") and root.status_label.winfo_exists():
        root.status_label.destroy()

    root.status_label = Label(root, text="", fg="red")
    root.status_label.pack(pady=5)

    def atualizar_status(msg):
        root.status_label.config(text=msg)
        root.update_idletasks()


    def tarefa():
        try:
            desktop = get_desktop_path()
            zip_path = desktop / nome_arquivo_zip
            pasta_destino = desktop / nome_pasta


            if zip_path.exists():
                zip_path.unlink()
            if pasta_destino.exists():
                shutil.rmtree(pasta_destino)

            atualizar_status("Baixando arquivo...")

            # Download
            with requests.get(url, stream=True, verify=True) as r:
                r.raise_for_status()
                with open(zip_path, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)

            atualizar_status("Download concluído! Extraindo...")
            # Extrai ZIP
            with zipfile.ZipFile(zip_path, 'r') as zip_ref:
                zip_ref.extractall(pasta_destino)
            sleep(3)

            zip_path.unlink()
            

            atualizar_status("Concluído!")
            messagebox.showinfo(
                "Sucesso",
                f"O download foi concluído!\n\nConteúdo extraído em:\n{pasta_destino}"
            )

        except Exception as e:
            atualizar_status("Erro durante o download.")
            messagebox.showerror("Erro", f"Falha ao baixar o driver:\n{e}")

        finally:
            sleep(1)
            atualizar_status("")
            btn.config(state="normal")
            btn_voltar.config(state="normal")

    threading.Thread(target=tarefa, daemon=True).start()
# ---------- Copiar link ----------
def copiar_link(modelo):
    if modelo in DRIVERS:
        pyperclip.copy(DRIVERS[modelo])
        messagebox.showinfo("Link copiado!", f"Link da impressora {modelo} copiado para a Área de transferência.")
    else:
        messagebox.showerror("Erro", f"Modelo {modelo} não encontrado.")