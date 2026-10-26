# Contrôle du livrable - 26 octobre 2026

Binôme : EVINA MBAHO Eric et MBOUKEM KEPGUIE Loic.

| Exigence | Vérification | État / limite |
|---|---|---|
| 3 à 5 pages | PDF de 5 pages | Contrôle automatique et rendu visuel |
| Résumé direction, 5 lignes | Page 1 | Cinq phrases, une ligne chacune dans la mise en page |
| Périmètre, autorisation, dates et outils | Page 1 | Labo personnel et réseaux simulés ; aucun réseau tiers |
| Six contrôles A.7 | Page 1 et six journaux A7 | Réussis dans les essais enregistrés du 25 octobre ; pas de nouvelle validation complète après le blocage de stockage |
| B.1-B.4 et valeurs demandées | Page 3, quatre PCAPNG et journaux | ARP, DORA et options, DNS UDP/TCP, TCP/80 et RST/8080 vérifiés |
| Quatre réponses entreprise argumentées | Page 3 | IP/MAC/port, DHCP snooping, DNS interne, RST/filtrage/journaux |
| Tableau C.5 complet | Page 2 | Service, protocole utilisé, contenu visible, remplacement et effort |
| Une capture d’écran par ligne C.5 | Page 2, figures 1 à 4 | Vues de synthèse TShark issues des preuves, pas interface Wireshark native |
| Avant/après HTTP/HTTPS | Pages 2 et 4, deux PCAPNG | Comparaison réalisée ; certificat auto-signé réservé au labo |
| Telnet vers SSH effectif | Page 4 et journaux C3 | SSH testé ; Telnet refusé ; algorithmes hérités signalés |
| SNMP temporaire retiré | Page 4 et journal C4 | Retrait testé ; SNMPv3 non déployé |
| Plan d’action réaliste | Page 4 | Priorités, critères de recette, heures/jours et achats conditionnels |
| Module du cours par service | Page 4 | M3 confirmé pour SNMPv3 ; sections C.1-C.3 citées pour les autres services ; numéros d’approfondissement indisponibles |
| Annexes des trois routeurs | Page 5 et configurations/ | Exports complets joints, secrets d’authentification expurgés |
| Aucun secret réel en clair dans les éléments à publier | Contrôles texte, PDF, flux réassemblés et champs sensibles | Copies expurgées ; originaux hors dépôt |
| Uniquement preuves du labo | Analyse des adresses et points de capture documentés | Le bureau Google n’est pas utilisé comme preuve de ce TP |
| Dépôt Git et Classroom | Préparation locale seulement | Aucun commit, push ou envoi Classroom réalisé automatiquement |

## Points à connaître avant de publier

1. Le programme détaillé manque pour numéroter les modules HTTPS, SFTP/FTPS et SSH. Demander cette correspondance à l’enseignant si elle est exigée : le rapport n’invente pas de module.
2. Les figures sont des captures de relevés d’analyse, clairement désignées. Si l’enseignant exige précisément des captures de l’interface Wireshark, il faudra ajouter ces vues natives.
3. Les PCAPNG sensibles sont des dérivés expurgés, reliés aux originaux par SHA-256 ; ne pas les décrire comme des fichiers bruts inchangés.
4. Pour attester d’un labo fonctionnant à la date de remise, relancer les six tests A.7 après reprise de la VM. Les succès du 25 octobre restent des résultats historiques réels.

Cette liste facilite votre vérification ; elle ne prédit pas la note.
