# ==============================================================================
# CamTrust Bank - Routeur Agence Douala R-DLA (MikroTik RouterOS 7)
# Configuration finale durcie - Conformite Politique M1 & Guide NSA
# Etudiant : NGUEGNI ONGOLO Antoine Depadoux | Classe : ITT3 IR
# Remarque : Conformement aux consignes, tous les secrets sont remplaces par <masque>
# ==============================================================================

# [M1.7 / NSA --] Identite du routeur
/system identity set name=R-DLA

# [M1.1 / NSA 5.1-5.4] Gestion des comptes locaux - Desactivation 'admin' et creation compte 'secours'
/user add name=secours group=full password=<masque> comment="Compte local de secours"
/user disable admin

# [M1.3 / NSA 4.1-4.4] Integration AAA RADIUS vers SRV-ADMIN
/radius add address=10.10.99.20 secret=<masque> service=login authentication-port=1812 accounting-port=1813 timeout=3s comment="Serveur AAA CamTrust"
/radius incoming set accept=yes
/user aaa set use-radius=yes default-group=read accounting=yes

# [M1.4 / NSA 7.1, 7.9] Desactivation des services non securises et restriction SSH/Winbox
/ip service disable telnet
/ip service disable ftp
/ip service disable www
/ip service disable api
/ip service disable api-ssl
/ip service set ssh port=22 address=10.10.99.0/24,10.20.10.0/24 disabled=no
/ip service set winbox address=10.10.99.0/24,10.20.10.0/24 disabled=no

# [M1.4 / NSA 7.9, 7.10] Desactivation des protocoles de decouverte et serveurs de maintenance
/tool mac-server set allowed-interface-list=none
/tool mac-server mac-winbox set allowed-interface-list=none
/tool mac-server ping set enabled=no
/tool bandwidth-server set enabled=no
/ip neighbor discovery-settings set discover-interface-list=none
/snmp set enabled=no

# [M1.4 / NSA 7.9] Restriction des fonctions serveurs applicatives
/ip dns set allow-remote-requests=no
/ip socks set enabled=no
/ip upnp set enabled=no
/ip proxy set enabled=no

# [M1.5 / NSA 8.2] Controle de la source d'adresse (uRPF Strict)
/ip settings set rp-filter=strict

# [M1.6 / NSA 6.4] Synchronisation temporelle NTP et fuseau horaire
/system clock set time-zone-name=Africa/Douala
/system ntp client set enabled=yes
/system ntp client servers add address=10.10.99.20

# [M1.6 / NSA 6.1-6.3] Journalisation centralisee Syslog
/system logging action add name=syslog-central remote=10.10.99.20 remote-port=514 target=remote
/system logging add action=syslog-central topics=info
/system logging add action=syslog-central topics=warning
/system logging add action=syslog-central topics=error
/system logging add action=syslog-central topics=critical
/system logging add action=syslog-central topics=account

# [M1.5 / NSA 7.9] Pare-feu de filtrage (Chaine INPUT avec refus journalise par defaut)
/ip firewall filter
add chain=input action=accept connection-state=established,related comment="Accepter trafic etabli et lie"
add chain=input action=drop connection-state=invalid comment="Rejeter paquets invalides"
add chain=input action=accept protocol=icmp comment="Autoriser ICMP diagnostique"
add chain=input action=accept src-address=10.10.99.0/24 comment="Autoriser reseau administration centrale"
add chain=input action=accept src-address=10.20.10.0/24 in-interface=ether2 dst-port=22 protocol=tcp comment="Autoriser administration locale SSH"
add chain=input action=log log-prefix="INPUT-REFUS: " comment="Journaliser les tentatives rejetees"
add chain=input action=drop comment="Refus par defaut de tout autre flux vers le routeur"

# Plan d'adressage et routage d'infrastructure
/interface ethernet set [ find default-name=ether1 ] disable-running-check=no comment="Liaison WAN vers R-SIEGE"
/interface ethernet set [ find default-name=ether2 ] disable-running-check=no comment="LAN Agence Douala"
/ip address add address=172.16.12.2/30 interface=ether1 network=172.16.12.0
/ip address add address=10.20.10.1/24 interface=ether2 network=10.20.10.0
/ip route add dst-address=0.0.0.0/0 gateway=172.16.12.1
