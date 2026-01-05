# Cahier des charges — Application Auto-école

## 1. Objectif
Créer une application mobile Flutter permettant de gérer les activités d'une auto-école : gestion des élèves, planning des leçons, réservation, suivi pédagogique, paiements et administration.

## 2. Utilisateurs & rôles
- Élève : réserver/annuler des leçons, voir son planning, historique et progression.
- Moniteur (instructeur) : gérer ses disponibilités et ses leçons, noter la progression des élèves.
- Admin : gérer utilisateurs, moniteurs, statistiques, tarifs.

## 3. Fonctionnalités MVP
- Authentification (email/password) avec rôles (élève / moniteur / admin).
- Ecran profil (données personnelles, permis, documents).
- Planning & réservation des leçons (calendrier, créneaux disponibles, confirmation).
- Fiches de progression par élève (notes, remarques, progrès).
- Interface moniteur pour accepter/annuler leçons.
- Notifications push pour rappels de leçons.

## 4. Fonctionnalités avancées (phase 2)
- Paiement en ligne (Stripe).
- Facturation / reçus.
- GPS & trajets pour leçon (optionnel).
- Statistiques et dashboards administrateurs.

## 5. Architecture technique proposée
- Backend & services : Firebase (Authentication, Firestore, Cloud Functions, Cloud Storage).
- State management : Riverpod.
- Notifications : Firebase Cloud Messaging.
- Paiements : Stripe (via `flutter_stripe`).
- Cartes : `google_maps_flutter` (si nécessaire).

## 6. Modèle de données (Firestore)
Collections principales:
- users
  - uid, name, email, role, phone, licenseInfo, createdAt
- lessons
  - id, studentId, instructorId, startAt, endAt, status (scheduled, done, canceled), notes, price
- payments
  - id, userId, amount, status, method, createdAt
- progress
  - id, studentId, instructorId, date, skills, notes
- notifications
  - id, userId, type, payload, read, createdAt

## 7. Ecrans principaux
- Welcome / Onboarding
- Login / Signup
- Home (dashboard) — différent par rôle
- Planning (calendrier) + réservation
- Détail leçon
- Profil
- Moniteur: mes leçons
- Admin: dashboard gestion

## 8. Règles de sécurité & règles Firestore
- Users: lecture auto pour propre profil, écriture limitée aux admins pour rôle
- Lessons: lecture si studentId=in user.uid ou instructorId=in user.uid ou admin
- Payments: restreint au propriétaire et admins

## 9. Tests & QA
- Unit tests pour logique métier
- Widget tests pour écrans critiques (auth, planning)
- Integration tests pour flux réservation + notifications

## 10. Roadmap initiale
1. Auth & profils (MVP)
2. Planning & réservations (MVP)
3. Notifications & progression
4. Paiements & admin

---

## 11. Configuration Firebase (guide rapide)
1. Créer un projet Firebase sur https://console.firebase.google.com.
2. Ajouter une application Android (package `com.example.ma_app_test`) et/ou iOS ; télécharger `google-services.json` (Android) et `GoogleService-Info.plist` (iOS) et les placer dans les répertoires `android/app/` et `ios/Runner/` respectivement.
3. (Optionnel mais recommandé) Installer et configurer `flutterfire` CLI pour générer `lib/firebase_options.dart` :
   - `dart pub global activate flutterfire_cli`
   - `flutterfire configure --project=<votre-id-projet>`
4. Ajouter les dépendances dans `pubspec.yaml` : `firebase_core`, `firebase_auth`, `cloud_firestore`, etc. (déjà ajoutées dans ce projet).
5. Initialiser Firebase dans `main.dart` via `Firebase.initializeApp()` (déjà implémenté).
6. Ajouter règles Firestore pour sécuriser les collections (`users`, `lessons`, `payments`), limiter les écritures selon les rôles et valider les données.

---

*Prochaine étape : implémenter l'inscription / connexion (avec `AuthService`) et les règles Firestore de base.*

---

## 12. Comment tester l'application

### Prérequis
- Installer Flutter (stable) et configurer un appareil/emulateur Android ou iOS.
- Créer un projet Firebase et ajouter une application Android et/ou iOS.
- Télécharger `google-services.json` (Android) et/ou `GoogleService-Info.plist` (iOS) et les placer respectivement dans `android/app/` et `ios/Runner/`.
- (Optionnel mais recommandé) Installer `flutterfire` CLI et exécuter `flutterfire configure` pour générer `lib/firebase_options.dart`.

### Tests manuels (fonctionnels)
1. Ouvrir un terminal à la racine du projet.
2. Exécuter `flutter pub get` pour installer les dépendances.
3. Lancer l'application sur un émulateur ou appareil : `flutter run`.
4. Tester le flux d'inscription : Ouvrir l'écran Inscription, remplir nom/email/mot de passe, choisir rôle et soumettre. Vérifier que l'utilisateur est créé dans Firestore (`collection: users`).
5. Tester la connexion : Fermer l'app, relancer, se connecter avec l'email créé et vérifier la navigation vers l'écran d'accueil.
6. Tester la déconnexion depuis l'écran d'accueil.

### Tests automatisés
- Unitaires / Widget tests : exécuter `flutter test` (ex : le test `test/auth_widget_test.dart` valide la présence des champs, `test/planning_widget_test.dart` vérifie le formulaire planning). Pour des tests plus avancés qui touchent Firebase, utilisez des émulateurs Firebase ou des mocks.
- Integration tests : ajoutez `integration_test` et écrivez des tests qui automatisent la navigation et les flux (signup/login/reservation). Exécuter avec `flutter test integration_test` ou `flutter drive` selon la configuration.

### Générer un APK (rapide)

Pour installer et tester sur un appareil Android, vous pouvez générer un APK debug (pas besoin de keystore) ou un APK release (requiert un keystore signing). Exemples :

- Debug APK (rapide, pour tests locaux) :

  1. Installer le SDK Android et configurez `ANDROID_HOME` / `PATH` (Android Studio ou SDK standalone).
  2. `flutter pub get`
  3. `flutter build apk --debug`
  4. L'APK généré : `build/app/outputs/flutter-apk/app-debug.apk`
  5. Installer sur un appareil connecté : `adb install -r build/app/outputs/flutter-apk/app-debug.apk`

  Si vous ne voulez pas configurer Android localement, j'ai ajouté un workflow GitHub Actions qui construit automatiquement un **APK debug** et le mettra en tant qu'artéfact téléchargeable sur chaque push (workflow : `.github/workflows/build-apk.yml`).

- Release APK (préparer la signature) :

  1. Générer un keystore si vous n'en avez pas :
     `keytool -genkey -v -keystore /chemin/vers/keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key` (gardez les informations en lieu sûr)
  2. Configurer `android/key.properties` et `android/app/build.gradle` selon la doc Flutter (voir https://flutter.dev/docs/deployment/android)
  3. `flutter build apk --release`
  4. L'APK généré : `build/app/outputs/flutter-apk/app-release.apk`

> Remarque: la construction directe dans cet environnement CI a échoué car le SDK Android n'est pas installé ici — le workflow GitHub Actions construit l'APK dans un runner qui a accès au SDK Android.

> Remarque: pour iOS, la génération d'IPA et l'installation sur device nécessitent un Mac, un compte Apple et une configuration de provisioning profiles.

### Test de sécurité Firestore
- Déployer temporairement `firestore.rules` dans la console Firebase ou via `firebase deploy --only firestore:rules` (attention à la production).
- Utiliser l'outil "Rules Playground" dans la console Firebase pour valider les scénarios d'accès (lecture/écriture selon rôles).

### Conseils & dépannage
- Si l'initialisation Firebase échoue, vérifiez la présence et l'emplacement correct de `google-services.json` / `GoogleService-Info.plist` et la console pour le bundle id / applicationId.
- Pour tester les notifications (FCM), configurez les clés serveur et utilisez la console Firebase ou `curl` pour envoyer messages de test.

---

*Prochaine étape proposée : ajouter le calendrier (planning) et les opérations CRUD pour les `lessons`.*