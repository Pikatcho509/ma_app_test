# Déployer & Générer l'APK

## 1) Pousser le projet sur GitHub
- Créez un repo sur GitHub (https://github.com/new) ou utilisez `gh` (CLI). 
- Exemple avec `gh` (si vous êtes connecté):

  gh repo create <owner/repo> --public --source=. --remote=origin --push

- Ou manuellement :
  - `git remote add origin git@github.com:VOTRE_UTILISATEUR/VOTRE_REPO.git`
  - `git branch -M main`
  - `git push -u origin main`

Le workflow CI `.github/workflows/build-apk.yml` se déclenchera automatiquement lors du push.

## 2) Récupérer l'APK depuis GitHub Actions
- GitHub → votre repo → Actions → Sélectionnez le workflow "Build APK" → ouvrez le run → Artifacts → `app-debug-apk` → téléchargez.

## 3) Installer l'APK sur un appareil Android
- Assurez-vous que `adb` est installé et que le téléphone est en mode développeur + débogage USB.
- `adb install -r path/to/app-debug.apk`

## 4) Build local (si vous avez Android SDK)
- `flutter pub get`
- `flutter build apk --debug`
- `adb install -r build/app/outputs/flutter-apk/app-debug.apk`

## 5) Release signé (optionnel)
- Générer un keystore et ajouter les variables dans `android/key.properties`.
- Mettre en place un workflow CI pour signer l'APK en utilisant GitHub Secrets (je peux vous aider à ajouter ce workflow).

---

Si vous voulez, je peux créer le repo GitHub et pousser automatiquement (nécessite `gh` CLI installé et connecté). Dites-moi "Oui crée le repo" pour que j'essaie cela ici.