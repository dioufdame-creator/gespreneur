# Gespreneur — application installable avec comptes en ligne

## Contenu
- `index.html` : l'application complète
- `config.js` : adresse et clé de votre projet Supabase (à remplir)
- `supabase.js` : bibliothèque de connexion au serveur
- `supabase/schema.sql` : création de la base de données (à exécuter une fois)
- `manifest.webmanifest`, `sw.js`, `icons/` : installation et fonctionnement sans internet

## 1. Préparer Supabase (une seule fois)
1. Créer un projet sur supabase.com.
2. **Authentication → Sign In / Providers → Email** : désactiver **Confirm email**, enregistrer.
3. **SQL Editor → New query** : coller tout le contenu de `supabase/schema.sql`, puis **Run**. Le message doit être « Success ».
4. **Project Settings → API** : copier le **Project URL** et la clé **anon public** (ou *publishable*).

## 2. Remplir `config.js`
Remplacer `VOTRE_PROJECT_URL` et `VOTRE_CLE_ANON` par les deux valeurs copiées.
La clé *anon* peut être publique : chaque entrepreneur ne voit que ses données grâce aux règles de la base.
**Ne jamais mettre la clé `service_role` / `secret` dans l'application.**

## 3. Mettre en ligne sur GitHub Pages
1. Dépôt **gespreneur** → **Add file → Upload files**.
2. Glisser le *contenu* de ce dossier (pas le dossier lui-même), y compris le dossier `supabase`.
3. **Commit changes**.
4. **Settings → Pages** → Branch `main`, dossier `/ (root)` → **Save**.
5. Adresse : https://dioufdame-creator.github.io/gespreneur/

## Comment ça marche
- **Compte** : numéro de téléphone + code secret à 6 chiffres. Pas d'email ni de SMS.
- **Hors connexion** : tout continue de fonctionner. Les modifications attendent sur le téléphone (« Hors ligne · 3 en attente ») et partent dès que le réseau revient.
- **Plusieurs téléphones** : en se connectant avec le même numéro, on retrouve les mêmes données.
- **Stock** : calculé à partir du stock de départ, des achats et des ventes. Deux téléphones qui vendent en même temps hors connexion ne s'écrasent pas.
- **Démonstration** : sur l'écran de connexion, « Voir une démonstration » ouvre des données d'exemple, sans compte.
- Les données d'une ancienne version (sans compte) sont ajoutées automatiquement au premier compte créé ou connecté sur ce téléphone.

## Mettre à jour l'application
1. Modifier les fichiers.
2. Dans `sw.js`, changer `VERSION` (ex. `gp-v3`).
3. Renvoyer les fichiers sur GitHub.

## Limites connues (prochaines étapes)
- Code oublié : pour l'instant, le réinitialiser dans Supabase (Authentication → Users). Une procédure par WhatsApp viendra plus tard.
- Un code à 6 chiffres est simple mais moins solide qu'un mot de passe. Supabase limite le nombre d'essais ; une vérification par SMS ou WhatsApp pourra s'ajouter.
- Un seul utilisateur par boutique pour l'instant (patron + vendeurs : plus tard).
- Les photos sont enregistrées dans la base ; pour un grand catalogue, on les passera dans Supabase Storage.
