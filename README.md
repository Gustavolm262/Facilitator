Facilitator-Python

📌 Sobre o projeto

Sou analista de sistemas na Angradata, representante da Alterdata. No dia a dia, a equipe de suporte precisa lidar com diversas rotinas manuais. Pensando nisso, criei este executável que reúne funções úteis para agilizar essas tarefas.

⚙️ Funcionalidades

Entre as principais funções, estão:

✅ Ajuste automático de permissões em pastas e firewall;
✅ Reinstalação rápida de aplicações;
✅ Download simplificado de drivers de impressora;
✅ Otimização de banco de dados;
✅ Outras rotinas de suporte recorrentes.

🗂 Estrutura do projeto

O código está dividido em duas partes principais:

facilitator.py  → Responsável pela interface gráfica da aplicação (menus, botões, janelas).
functions.py    → Contém todas as funções de backend que executam os processos utilizados pela interface.

📂 Estrutura simplificada:

Facilitator-Python/

│

├── facilitator.py    # Código principal (interface gráfica)

├── functions.py      # Todas as funções que dão suporte à interface

└── README.md         # Documentação do projeto


🚀 Tecnologias utilizadas

Python

ttkbootstrap (interface gráfica moderna baseada em Tkinter)

Bibliotecas auxiliares do Windows

📦 Como usar

Baixe o executável disponível na aba Releases.

Execute como administrador para garantir as permissões necessárias.

Utilize os menus para acessar as funcionalidades desejadas.


🌱 Branches

O repositório segue o padrão de duas branches:

main → Versão estável do projeto, recomendada para uso.
test → Versão em desenvolvimento, onde novas funcionalidades são testadas antes de serem integradas à main.

🤝 Contribuindo

Se você quiser contribuir com o projeto:

1 - Faça um fork do repositório.

2 - Crie uma branch a partir de test:

        git checkout test
        
        git checkout -b minha-nova-funcionalidade

3 - Realize suas alterações e faça commits claros e descritivos.

4 - Envie um pull request para a branch test.

5 - Após revisão e testes, a alteração será integrada à main.

📝 Licença

Este projeto está licenciado sob a MIT License
Você pode usar, modificar e distribuir o código livremente, respeitando os créditos ao autor.
