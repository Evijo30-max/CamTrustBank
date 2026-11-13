# PROCÉDURE TECHNIQUE : DURCISSEMENT D'UN NOUVEAU ROUTEUR D'AGENCE

**Document de référence :** PROC-SEC-RTR-01 | **Classification :** Interne CamTrust Bank  
**Cible :** Routeur de déploiement d'agence (Exemple : MikroTik RouterOS 7 / Cisco IOS)  
**Public :** Techniciens de déploiement et support réseau  
**Temps estimé :** 15 minutes  

---

### Objectif
Cette fiche opératoire décrit la séquence stricte à appliquer obligatoirement sur tout routeur avant son raccordement au réseau de production de CamTrust Bank.

---

### Séquence Opératoire en 5 Étapes

```
[ Étape 1 : Isolation ] ➔ [ Étape 2 : Identité ] ➔ [ Étape 3 : AAA/Comptes ] ➔ [ Étape 4 : Services ] ➔ [ Étape 5 : uRPF & Pare-feu ]
```

#### Étape 1 : Raccordement et mode sécurisé
1. Raccorder le poste technicien sur le port d'administration local (hors production).
2. Activer le **Mode Sûr** (`Ctrl + X` sur MikroTik ou `commit-confirm 10` sur VyOS) pour éviter toute coupure accidentelle d'accès.

#### Étape 2 : Attribution du nom et horodatage (NTP)
1. Définir le nom standardisé de l'agence :
   * Commande : `/system identity set name="R-AGENCE-<CODE_VILLE>"`
2. Configurer le fuseau horaire et le serveur de temps de référence :
   * Fuseau : `Africa/Douala`
   * Serveur NTP : pointer vers le serveur central `10.10.99.20`.

#### Étape 3 : Gestion des comptes et délégation AAA
1. **Créer le compte local de secours d'urgence :**
   * Nom : `secours` avec mot de passe robuste conforme à la politique M1 (12 caractères min, majuscules, minuscules, chiffres, symboles).
2. **Désactiver immédiatement le compte d'usine :**
   * Désactiver le compte `admin` (`/user disable admin`).
3. **Activer l'authentification centralisée RADIUS :**
   * Pointer vers l'adresse `10.10.99.20` avec le secret partagé d'infrastructure.
   * Définir le groupe de repli en lecture seule (`read`).

#### Étape 4 : Neutralisation des services non sécurisés
1. Désactiver formellement tous les protocoles en clair :
   * Couper : Telnet, HTTP, FTP, API, API-SSL.
2. Restreindre l'accès SSH et Winbox aux seuls sous-réseaux d'administration autorisés (`10.10.99.0/24` et le LAN d'administration de l'agence).
3. Désactiver les protocoles de découverte et de broadcast :
   * Couper MNDP, CDP et LLDP (`discovery-settings set discover-interface-list=none`).
   * Désactiver le serveur de test de débit (`bandwidth-server`).

#### Étape 5 : Filtrage IP et protection uRPF (Anti-Spoofing)
1. Activer le contrôle strict de la source IP :
   * Activer le filtre anti-usurpation : `rp-filter=strict`.
2. Appliquer la politique de filtrage sur la chaîne `input` :
   * Autoriser le trafic établi et lié (`established,related`).
   * Autoriser ICMP à des fins de diagnostic.
   * Terminer la règle par un rejet journalisé avec préfixe `INPUT-REFUS:`.

---

### Grille de Vérification Finale avant Mise en Production (Checklist)

| Point de contrôle | Résultat attendu | Validé (Visa) |
| :--- | :--- | :---: |
| Connexion Telnet sur port 23 | Connexion refusée | [  ] |
| Connexion SSH depuis une IP non autorisée | Rejet immédiat par le pare-feu | [  ] |
| Connexion SSH avec compte d'annuaire RADIUS | Authentification réussie | [  ] |
| Désactivation du compte usine `admin` | Absence de connexion possible avec `admin` | [  ] |
| Sauvegarde de la configuration durcie | Export sauvegardé sous `R-AGENCE.rsc` | [  ] |
