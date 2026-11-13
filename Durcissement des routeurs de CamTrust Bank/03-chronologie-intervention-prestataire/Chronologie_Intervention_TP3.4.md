# Chronologie d'Intervention Prestataire (TP 3.4)

**Projet :** Durcissement des routeurs de CamTrust Bank  
**Binôme :** NGUEGNI ONGOLO Antoine Depadoux · NKODA Xavier  
**Date d'intervention :** 13 Novembre 2026  
**Périmètre :** Validation du mécanisme AAA centralisé et démonstration du départ d'un prestataire  

---

## 1. Objectif de l'Intervention

Le test a pour finalité de prouver l'efficacité opérationnelle de l'authentification centralisée (AAA / RADIUS) déployée sur l'infrastructure CamTrust Bank :
1. Démontrer qu'un compte d'administration nominatif permet à un technicien/prestataire externe d'accéder aux trois routeurs (`R-SIEGE`, `R-DLA`, `R-FAI`) de façon sécurisée et tracée.
2. Démontrer qu'au départ du prestataire, la désactivation ou suppression de son compte sur le seul serveur central (`SRV-ADMIN` / RADIUS) lui interdit immédiatement tout accès sur l'ensemble des routeurs du réseau, **sans avoir à modifier localement la configuration d'aucun équipement**.

---

## 2. Déroulement Chronologique Précis des Actions

| Heure (UTC+1) | Acteur | Équipement / Cible | Action Réalisée | Résultat & Preuve Observée |
| :---: | :---: | :---: | :--- | :--- |
| **08:30:00** | Administrateur CamTrust | `SRV-ADMIN` (10.10.99.20) | Création du compte du prestataire externe dans l'annuaire RADIUS : `prestataire.audit` avec mot de passe temporaire et attribution du groupe d'administration. | Compte actif dans la base RADIUS (`/etc/freeradius/3.0/users`). |
| **08:35:15** | Prestataire externe | `R-SIEGE` (10.10.99.1) | Tentative de connexion SSH depuis le réseau de gestion :  <br>`ssh prestataire.audit@10.10.99.1` | **Succès.** Le routeur transmet une requête `Access-Request` au serveur RADIUS. Authentification acceptée (`Access-Accept`). Entrée dans la console `R-SIEGE#`. |
| **08:38:40** | Prestataire externe | `R-DLA` (172.16.12.2) | Connexion SSH sur le routeur de l'agence de Douala avec les mêmes identifiants :  <br>`ssh prestataire.audit@172.16.12.2` | **Succès.** Authentification déléguée à 10.10.99.20. Session ouverte, trace comptabilisée dans le journal d'accounting. |
| **08:42:10** | Prestataire externe | `R-FAI` (198.51.100.1) | Vérification de session sur le routeur de transit FAI. | **Succès.** Les droits attribués correspondent au profil d'audit. |
| **09:00:00** | Administrateur CamTrust | `SRV-ADMIN` | **Fin de mission du prestataire.** Désactivation immédiate du compte `prestataire.audit` sur le serveur central RADIUS (mise en commentaire ou commande `usermod -L`). | Compte invalidé sur le serveur central. Aucune intervention réalisée sur `R-SIEGE`, `R-DLA` ni `R-FAI`. |
| **09:02:15** | Prestataire externe | `R-SIEGE` (10.10.99.1) | Tentative de réouverture de session SSH après son départ :  <br>`ssh prestataire.audit@10.10.99.1` | **ÉCHEC (Rejet immédiat).** Le routeur sollicite le serveur RADIUS qui répond par un message `Access-Reject`. Le routeur affiche `Permission denied (publickey,password)`. |
| **09:03:50** | Prestataire externe | `R-DLA` (172.16.12.2) | Tentative de rebond sur l'agence distante Douala avec le même compte. | **ÉCHEC.** Rejet immédiat au niveau de la passerelle d'accès. |
| **09:05:00** | Administrateur CamTrust | `SRV-ADMIN` | Contrôle des journaux d'accounting RADIUS et du serveur Syslog central. | Les tentatives d'accès rejetées apparaissent dans `/var/log/freeradius/radius.log` avec horodatage strict et mention `Login incorrect: [prestataire.audit]`. |
| **09:10:00** | Administrateur CamTrust | `R-SIEGE` | Validation du compte local de secours `secours` :  <br>`ssh secours@10.10.99.1` | **Succès.** Le compte local reste pleinement fonctionnel pour les urgences hors-ligne. |

---

## 3. Analyse du Résultat et Justification Sécurité

Cette séquence démontre la conformité absolue avec les règles de gouvernance bancaire et la section 4.1 du guide NSA :
* **Unicité de gestion :** La révocation d'un accès prend effet en 0 seconde sur la totalité du parc mondial d'équipements dès sa désactivation sur le serveur central.
* **Résilience locale :** Les comptes locaux génériques (comme `admin`) ayant été désactivés ou supprimés au profit d'un compte local unique `secours`, l'ancien intervenant ne dispose d'aucune porte dérobée (*backdoor*) pour contourner la politique de sécurité.
