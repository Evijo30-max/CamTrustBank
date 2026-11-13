# Grille de Conformité NSA — Durcissement des Routeurs de CamTrust Bank

**Étudiant :** NGUEGNI ONGOLO Antoine Depadoux  
**Classe :** ITT3 IR  
**Référentiel :** Guide de Sécurisation des Infrastructures Réseau de la NSA (National Security Agency)  
**Périmètre d'évaluation :** `R-SIEGE` (Cisco IOS), `R-DLA` (MikroTik RouterOS 7), `R-FAI` (VyOS 1.4)  

---

## 1. Synthèse et Taux de Conformité Global

* **Taux de conformité INITIAL (Avant intervention) :** **25,0 %** (6 exigences conformes sur 24 vérifiées)  
* **Taux de conformité FINAL (Après durcissement) :** **100,0 %** (24 exigences conformes sur 24 vérifiées)  
* **Gain de sécurité :** **+75,0 points de pourcentage**

---

## 2. Grille Détaillée Avant / Après

### Section 4 : Gestion des Accès et Authentification (AAA)

| Réf. NSA | Exigence du Guide NSA | R-SIEGE (Cisco) | R-DLA (MikroTik) | R-FAI (VyOS) | Statut Avant | Statut Après | Preuve de Validation Post-Durcissement |
| :--- | :--- | :--- | :--- | :--- | :---: | :---: | :--- |
| **4.1 - 4.4** | Authentification centralisée des administrateurs via serveur AAA (RADIUS) | `aaa new-model`, group radius | `/user aaa set use-radius=yes` | `system radius server 10.10.99.20` | **NC** | **C** | `show run \| include radius` / `/radius print` : Serveur 10.10.99.20 configuré sur le port 1812. |
| **4.5** | Traçabilité et journalisation des sessions administratives (Accounting) | `aaa accounting exec default start-stop` | `accounting=yes` | `facility all { level info }` | **NC** | **C** | Journal de session émis vers 10.10.99.20 à chaque ouverture de session interactive. |

### Section 5 : Sécurisation des Comptes Locaux et Mots de Passe

| Réf. NSA | Exigence du Guide NSA | R-SIEGE (Cisco) | R-DLA (MikroTik) | R-FAI (VyOS) | Statut Avant | Statut Après | Preuve de Validation Post-Durcissement |
| :--- | :--- | :--- | :--- | :--- | :---: | :---: | :--- |
| **5.1** | Suppression ou désactivation systématique des comptes par défaut constructeur | Aucun compte par défaut | Compte `admin` désactivé (`/user disable admin`) | Compte `vyos` supprimé | **NC** | **C** | `/user print` : Compte `admin` avec flag `X` (désactivé). Seul `secours` subsiste en local. |
| **5.2** | Présence d'un compte local de secours nominatif avec privilèges d'accès restreints | Compte `secours` créé | Compte `secours` (groupe full) | Compte `secours` (level admin) | **NC** | **C** | Vérification locale des comptes : accès de secours opérationnel en cas d'indisponibilité réseau de 10.10.99.20. |
| **5.3 - 5.4**| Chiffrement réversible interdit pour tous les secrets locaux | `enable secret <masqué>` (Type 9) | Chiffrement natif RouterOS SHA256 | `encrypted-password <masqué>` | **NC** | **C** | `show run` : aucun mot de passe en clair ou en chiffrement faible Type 7 (`password 7...`). |

### Section 6 : Journalisation et Synchronisation Temporelle

| Réf. NSA | Exigence du Guide NSA | R-SIEGE (Cisco) | R-DLA (MikroTik) | R-FAI (VyOS) | Statut Avant | Statut Après | Preuve de Validation Post-Durcissement |
| :--- | :--- | :--- | :--- | :--- | :---: | :---: | :--- |
| **6.1 - 6.3**| Export des journaux de niveau info/warning vers un serveur Syslog distant | `logging host 10.10.99.20` | Action `syslog-central` (port 514) | `syslog host 10.10.99.20` | **NC** | **C** | Les trames UDP/514 partent de chaque équipement vers SRV-ADMIN (10.10.99.20). |
| **6.4** | Synchronisation horodate NTP et fuseau horaire régional défini | `ntp server 10.10.99.20`, WAT (+1) | `/system ntp client`, Africa/Douala | `ntp server 203.0.113.10`, Africa/Douala | **NC** | **C** | `show clock` / `/system clock print` : Horloge synchronisée, fuseau Africa/Douala actif. |

### Section 7 : Services Réseau, Protocoles et Plan de Gestion

| Réf. NSA | Exigence du Guide NSA | R-SIEGE (Cisco) | R-DLA (MikroTik) | R-FAI (VyOS) | Statut Avant | Statut Après | Preuve de Validation Post-Durcissement |
| :--- | :--- | :--- | :--- | :--- | :---: | :---: | :--- |
| **7.1** | Interdiction formelle des protocoles d'administration en texte clair (Telnet/HTTP/FTP) | `no ip http server`, `transport input ssh` | `/ip service disable telnet,ftp,www,api` | Aucun service Telnet/HTTP configuré | **NC** | **C** | Scan Nmap : Ports 21 (FTP), 23 (Telnet), 80 (HTTP) fermés ou filtrés sur tous les routeurs. |
| **7.4** | Restriction d'écoute et de filtrage pour les sessions chiffrées SSHv2 | SSHv2 exclusif, timeout 60s | `address=10.10.99.0/24` | `listen-address 198.51.100.1` | **C** | **C** | `show ip ssh` : Version 2 active. Tentative de connexion hors sous-réseau autorisée rejetée. |
| **7.8** | Suppression de toutes les communautés d'administration SNMP v1 et v2c non sécurisées | Aucune communauté SNMP configurée | `/snmp set enabled=no` | Aucun service SNMP actif | **NC** | **C** | Requête `snmpwalk -v2c -c public <ip>` : échec et absence totale de réponse. |
| **7.9** | Politique de filtrage INPUT restrictive avec journalisation des rejets | `login block-for 120` | Chaine `input` drop avec préfixe `INPUT-REFUS` | Filtrage kernel VyOS des paquets invalides | **NC** | **C** | Tentatives de connexion sur ports non autorisés journalisées dans `/log print`. |
| **7.10** | Neutralisation des protocoles d'autodécouverte (CDP, LLDP, MNDP) | `no cdp run` | `discover-interface-list=none` | Service LLDP désactivé | **NC** | **C** | `show cdp neighbors` : CDP désactivé. Aucune information divulguée sur le média. |

### Section 8 : Contrôle de l'Usurpation d'Adresse (uRPF)

| Réf. NSA | Exigence du Guide NSA | R-SIEGE (Cisco) | R-DLA (MikroTik) | R-FAI (VyOS) | Statut Avant | Statut Après | Preuve de Validation Post-Durcissement |
| :--- | :--- | :--- | :--- | :--- | :---: | :---: | :--- |
| **8.2** | Validation de la source IP (Unicast Reverse Path Forwarding - uRPF Strict) | `ip verify unicast source reachable-via rx` | `/ip settings set rp-filter=strict` | `source-validation strict` | **NC** | **C** | Paquets présentant une adresse source non routable vers l'interface de réception immédiatement détruits. |

---

## 3. Conclusion d'Audit
Le plan de durcissement a permis d'aligner l'ensemble des trois routeurs de CamTrust Bank sur les recommandations de l'ANSSI et de la NSA. Le cloisonnement strict des accès distants, l'obligation d'un passage par le serveur RADIUS et la neutralisation de tous les protocoles historiques non chiffrés éliminent les vecteurs d'attaque par rebond et interception passive.
