// ==============================================================================
// CamTrust Bank - Routeur Fournisseur d'Acces R-FAI (VyOS 1.4)
// Configuration finale durcie - Conformite Politique M1 & Guide NSA
// Etudiant : NGUEGNI ONGOLO Antoine Depadoux | Classe : ITT3 IR
// Remarque : Conformement aux consignes, tous les secrets sont remplaces par <masque>
// ==============================================================================

interfaces {
    ethernet eth0 {
        address "198.51.100.1/30"
        description "Liaison vers R-SIEGE"
        // [M1.5 / NSA 8.2] Verification de la source d'adresse (uRPF Strict)
        ip {
            source-validation strict
        }
    }
    ethernet eth1 {
        address "203.0.113.1/24"
        description "Liaison vers SRV-INTERNET"
        ip {
            source-validation strict
        }
    }
    loopback lo {
    }
}

protocols {
    static {
        route 10.0.0.0/8 {
            next-hop 198.51.100.2 {
            }
        }
        route 172.16.0.0/12 {
            next-hop 198.51.100.2 {
            }
        }
    }
}

service {
    // [M1.2 / NSA 7.4] SSH durci et restreint aux interfaces de management
    ssh {
        listen-address "198.51.100.1"
        port 22
        disable-password-authentication false
    }
    // [M1.6 / NSA 6.4] Synchronisation d'horloge NTP
    ntp {
        server 203.0.113.10 {
        }
    }
    // [M1.4 / NSA 7.8, 7.10] Suppression de SNMPv1/v2c et LLDP
}

system {
    // [M1.7 / NSA --] Nom d'hote et domaine
    host-name "R-FAI"
    domain-name "fai-transit.lan"
    
    // [M1.6 / NSA 6.4] Fuseau horaire
    time-zone "Africa/Douala"
    
    // [M1.7 / NSA 7.10] Banniere d'avertissement d'acces
    login {
        banner {
            pre-login "==============================================================\n   EQUIPEMENT D'OPERATEUR - ACCES RESERVE ET JOURNALISE\n=============================================================="
        }
        // [M1.1 / NSA 5.1-5.4] Suppression du compte 'vyos' et creation de 'secours'
        user secours {
            authentication {
                encrypted-password "<masque>"
            }
            level "admin"
        }
    }
    
    // [M1.3 / NSA 4.1-4.4] Authentification centralisee RADIUS
    radius {
        server 10.10.99.20 {
            key "<masque>"
            port 1812
            timeout 3
        }
    }
    
    // [M1.6 / NSA 6.1-6.3] Journalisation distante Syslog
    syslog {
        host 10.10.99.20 {
            facility all {
                level "info"
            }
        }
    }
    
    // [M1.5 / NSA 7.9] Filtrage par defaut du trafic destine au routeur
    firewall {
        all-ping "enable"
        broadcast-ping "disable"
        config-trap "disable"
        ipv6-receive-redirects "disable"
        ipv6-src-route "disable"
        ip-src-route "disable"
        log-martians "enable"
        receive-redirects "disable"
        send-redirects "disable"
        source-validation "strict"
        syn-cookies "enable"
        twa-hazards-protection "enable"
    }
}
