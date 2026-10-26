# CamTrust Bank - « Ce qui circule en clair »

**Binôme : EVINA MBAHO Eric et MBOUKEM KEPGUIE Loic.**

TP0.1 - Remise à niveau TCP/IP orientée sécurité. Version de travail du 26 octobre 2026, préparée pour le dépôt `Evijo30-max/CamTrustBank`.

## À lire en premier

- [Fiche professionnelle, noir et blanc, 5 pages](rapport/Ce-qui-circule-en-clair-CamTrustBank.pdf)
- [Contrôle des exigences et limites](CONTROLE-DU-LIVRABLE.md)
- [Mode d’emploi pour votre futur push](PUSH-APRES-LECTURE.md)

**Aucun push ni dépôt Classroom n’a été effectué.** Ce dossier est remis pour relecture. La notation appartient à l’enseignant ; aucune note n’est garantie.

## Contenu

| Dossier | Contenu |
|---|---|
| `rapport/` | PDF et source textuelle de la fiche |
| `captures/` | 10 PCAPNG : B.1-B.4 et C.1-C.4 ; les versions sensibles sont expurgées |
| `configurations/` | Exports finaux de R-SIEGE, R-DLA et R-FAI, sans secrets ni empreintes d’authentification |
| `preuves/` | Journaux A.7, analyses, vues de synthèse et traçabilité des captures |
| `topologie/` | Topologie EVE-NG du TP ; aucune image de machine |
| `outils/` | Génération du PDF et contrôle d’intégrité local |

## Résultats établis et périmètre

Les essais enregistrés le **25 octobre 2026** montrent les **six contrôles A.7 réussis**, les quatre observations B, HTTP/HTTPS et Telnet/SSH comparés, FTP et SNMPv2c observés en clair. Le refus Telnet après migration et l’absence de réponse SNMP après retrait de la communauté ont été vérifiés. **SFTP/FTPS et SNMPv3 sont recommandés, pas présentés comme déployés.**

Les essais appartiennent au seul labo CamTrust dans EVE-NG. Le poste graphique permettant de naviguer sur Google est séparé et exclu de ces preuves. Après l’interruption de stockage, aucune nouvelle validation complète en fonctionnement n’est déclarée dans ce dossier.

## Relecture des captures

Ouvrir chaque fichier dans Wireshark et appliquer le filtre indiqué :

| Capture | Filtre d’affichage |
|---|---|
| B1-arp | `arp` |
| B2-dhcp | `dhcp` |
| B3-dns | `dns` |
| B4-tcp | `tcp.port == 80 || tcp.port == 8080` |
| C1-http | `http.authorization` |
| C1-https | `tls` |
| C2-ftp | `ftp.request.command == "USER" || ftp.request.command == "PASS"` |
| C3-telnet | `telnet`, puis Suivre > Flux TCP |
| C3-ssh | `ssh` |
| C4-snmp | `snmp` |

B1 conserve l’ICMP qui a déclenché ARP ; B4 conserve le port 8080 fermé pour comparaison. Les fichiers B n’ont subi aucune modification.

## Secrets et traçabilité

Les originaux du TP restent conservés localement, hors de ce dossier. Les copies C1 HTTP, C2 FTP et C3 Telnet remplacent les secrets par des caractères de même longueur. C4 masque la communauté. Les sommes de contrôle des paquets modifiés ont été recalculées. Les horodatages, adresses, ports, numéros de séquence et résultats applicatifs restent conservés. Les versions HTTPS et SSH restent inchangées.

[La traçabilité](preuves/tracabilite-captures.json) donne les SHA-256 des originaux et des copies. [La validation](preuves/validation-captures.json) confirme la lecture des dix fichiers par TShark et l’absence de trame signalée malformée. Les quatre figures du PDF sont des **captures de vues de synthèse TShark**, et ne sont pas présentées comme des captures natives de Wireshark. Leur passage en niveaux de gris dans le PDF est uniquement une opération de mise en page.

Les exports sont des références techniques expurgées : définir de nouveaux accès avant restauration. **Ne pas importer une configuration expurgée en production.** Les images Cisco, Linux, MikroTik et VyOS, les disques, les clés privées et les fichiers d’identifiants sont exclus du dépôt.

## Reconstruction du PDF

Python 3 avec `reportlab` et `Pillow`, et polices Arial (Windows) ou DejaVu Sans (Linux) :

```text
python outils/construire_fiche.py
python outils/verifier_integrite.py
```

Après une reconstruction volontaire du PDF, régénérer aussi le fichier `SHA256SUMS.txt` : ses empreintes correspondent à l’état remis, pas à toutes les reconstructions possibles.

## Remise scolaire

Le sujet impose aussi une remise sur Google Classroom. Le push GitHub et la remise Classroom sont deux opérations distinctes, à effectuer après votre relecture. Les originaux communs au groupe ne doivent pas être présentés comme des expériences indépendantes si une autre version du rapport reprend les mêmes preuves.
