#!/bin/bash

# Define o endereço IP ou intervalo de IP a ser escaneado
ip="192.168.0.1/24"

# Realiza o scan de todos os portas abertas no IP especificado e salva em um arquivo XML
nmap -p 554 -Pn -oG - $ip | grep "open" | awk '{print $2}' > cameras.txt

# Verifica se existem câmeras listadas no arquivo
if [ -s cameras.txt ]; then
    echo "Câmeras encontradas na rede:"
    cat cameras.txt

    # Testa as vulnerabilidades de acesso nas câmeras
    echo "Testando vulnerabilidades de acesso nas câmeras..."
    msfconsole -q -x "use scanner/scada/modicon_modbus_detect; set RHOSTS `cat cameras.txt`; run; exit"
else
    echo "Nenhuma câmera encontrada na rede."
fi

# Limpa o arquivo de câmeras encontrado
rm cameras.txt
