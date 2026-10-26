# Votre push après relecture

Ce dossier est un dépôt Git local relié à :

https://github.com/Evijo30-max/CamTrustBank.git

**Aucun envoi n’a été effectué.** Le dépôt distant était vide lors de sa consultation. Les captures expurgées, le PDF et les configurations sont prêts pour votre examen.

## 1. Relire

- Ouvrir le PDF dans rapport/ et contrôler les deux noms.
- Lire CONTROLE-DU-LIVRABLE.md, notamment les limites.
- Ouvrir les PCAPNG dans Wireshark ; les mots de passe doivent apparaître masqués.
- Exécuter `python outils/verifier_integrite.py` si Python est disponible.
- Ne pas ajouter ACCES-LABO-PRIVE.txt ni credentials-private.json provenant du dossier parent.

## 2. Vérifier l’identité locale de votre compte Git

Dans un terminal ouvert dans CE dossier :

```text
git config user.name
git config user.email
git remote -v
git status --short
```

Si le nom ou l’adresse ne correspondent pas à l’auteur qui fera le commit, les configurer **pour ce dépôt uniquement**, avec votre vrai nom et une adresse reconnue par votre compte GitHub. Aucun changement d’identité Git globale n’a été fait par l’assistant.

## 3. Préparer le commit et contrôler exactement ce qui part

```text
git add README.md CONTROLE-DU-LIVRABLE.md PUSH-APRES-LECTURE.md SHA256SUMS.txt .gitignore rapport captures configurations preuves topologie outils
git diff --cached --stat
git diff --cached --check
```

Examiner les fichiers sélectionnés dans GitHub Desktop ou votre éditeur. Le fichier .gitignore exclut les disques, images, clés et noms courants de fichiers d’identifiants ; il ne remplace pas la relecture.

## 4. Publier seulement lorsque vous êtes prêts

```text
git commit -m "Livrable CamTrust : fiche de securisation et preuves expurgees"
git push -u origin main
```

S’authentifier avec le compte autorisé à écrire dans le dépôt. Si le distant a changé depuis la préparation, ne pas utiliser de force-push : examiner et intégrer ses changements.

Chaque collaborateur peut ensuite cloner le même dépôt et travailler avec son propre compte. La seconde version de présentation se préparera dans le second dépôt lorsqu’il sera indiqué, avec les noms et le style qui lui correspondent, tout en conservant les faits et la provenance commune des preuves.
