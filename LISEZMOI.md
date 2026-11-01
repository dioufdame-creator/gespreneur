# Gespreneur — application installable (PWA)

## Contenu
- `index.html` : l'application complète
- `manifest.webmanifest` : nom, icônes et couleurs de l'application installée
- `sw.js` : fonctionnement sans internet
- `icons/` : icônes du téléphone

## Mettre en ligne sur GitHub Pages
1. Ouvrir le dépôt **gespreneur** sur github.com.
2. **Add file → Upload files**.
3. Glisser le *contenu* de ce dossier (index.html, sw.js, manifest.webmanifest, LISEZMOI.md et le dossier icons), pas le dossier lui-même.
4. **Commit changes**.
5. **Settings → Pages** → Source : *Deploy from a branch* → Branch `main`, dossier `/ (root)` → **Save**.
6. Après une ou deux minutes : https://dioufdame-creator.github.io/gespreneur/

## Installer sur le téléphone
- **Android (Chrome)** : ouvrir l'adresse, toucher « Installer » sur l'accueil de l'app, ou menu ⋮ → « Installer l'application ».
- **iPhone (Safari)** : Partager → « Sur l'écran d'accueil ».

## Mettre à jour
1. Modifier les fichiers.
2. Dans `sw.js`, changer `VERSION` (ex. `gp-v2`).
3. Renvoyer les fichiers sur GitHub. Les téléphones prennent la nouvelle version à la prochaine ouverture avec internet.

## Données
Pour cette étape, les données restent sur le téléphone. Réglages → **Sauvegarder** crée un fichier à garder en lieu sûr ; **Restaurer** le recharge (sur le même ou un autre téléphone).
