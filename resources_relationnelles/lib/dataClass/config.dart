/*
> Page de configuration où mettre les informations en dur
> Ajouter des données si nécessaire
*/

class Config {
  static var serverIp =
      "10.0.2.2"; //IP du serveur test/réel (10.0.2.2 envoie à la machine où se trouve l'emulateur)
  static const serverPort = 3000; //Port de l'api
  static const apiPathBase = '/api'; //Chemain de base des apis
  static const registerRoute = "/register"; //route création de compte
  static const loginRoute = "/login"; //route connexion
  static const uploadRoute = "/ressources"; //route pour l'ajout de ressources
  static const lastRessources = "/ressources/recentes";
  static const historiqueRessources = "/ressources/historique";
  static const recuperationCategories = "/category/readCategory";
  static const recuperationEmail = "/user/emailByToken";
  static const recuperationInfoViaEmail = "/user/infosByEmail";
  static const editionCategories = "/category/edit";
  static const ajoutCategorie = "/category/addCategory";
  static const deleteCategorie = "/category/removeCategory";
  static const apiKey = ""; //Clé api
  static var configfile =
      ""; //Chemin vers le fichier de configuration de l'application
  static var timeoutValue = Duration(seconds: 5); //secondes

  static const mentionLegales = """
Mentions Légales – Application ReSources Relationnelles

Éditeur de l'application
Nom : NexGen
Statut juridique : PME
Adresse : 5 avenue de Victor Hugo, 51100 Reims, France
Téléphone : 03 45 12 02 54
Email : contact@nexgen.fr
SIRET : 9512151321654
Directeur de la publication : Quentin RICHARD

Hébergement
Hébergeur : Ministère des Solidarités et de la Santé
[Adresse non précisée – à ajouter si nécessaire]

Développement de l’application
Développeur : Quentin RICHARD
Contact : richard.quentin.t@gmail.com

Conditions d’utilisation
L’utilisation de l’application ReSources Relationnelles implique l’acceptation pleine et entière des conditions générales d’utilisation.
Ces conditions sont accessibles à tout moment depuis l’application.

Données personnelles
Conformément au Règlement Général sur la Protection des Données (RGPD), vous disposez d’un droit d’accès, de rectification, de suppression, d’opposition et de portabilité de vos données personnelles.

Pour toute demande concernant vos données personnelles, vous pouvez nous contacter à l’adresse suivante : contact@nexgen.fr

Les données collectées via l’application sont utilisées exclusivement pour le bon fonctionnement de l’outil et l’amélioration de l’accompagnement relationnel.
Aucune donnée ne sera transmise à des tiers sans consentement préalable.

Propriété intellectuelle
Tous les contenus présents dans l’application ReSources Relationnelles (textes, images, logos, icônes, sons, logiciels, etc.) sont protégés par le droit de la propriété intellectuelle et sont la propriété exclusive de NexGen ou de ses partenaires.

Toute reproduction, représentation, modification, publication, ou adaptation de tout ou partie des éléments de l’application, quel que soit le moyen ou le procédé utilisé, est interdite sans l’autorisation écrite préalable de NexGen.
""";

  static const conditionGeneralesUtilisation = """
Conditions Générales d’Utilisation – ReSources Relationnelles

Dernière mise à jour : 14/05/2025

1. Objet
Les présentes Conditions Générales d’Utilisation (CGU) ont pour objet de définir les modalités d’accès et d’utilisation de l’application mobile ReSources Relationnelles, éditée par NexGen.

2. Acceptation des conditions
En téléchargeant ou en utilisant l’application, l’utilisateur reconnaît avoir lu, compris et accepté sans réserve les présentes CGU.

3. Accès à l'application
L’accès à l’application est réservé aux utilisateurs autorisés par NexGen ou ses partenaires institutionnels. L’application est gratuite et disponible sur iOS/Android.

4. Propriété intellectuelle
Tous les éléments de l’application (textes, images, logos, graphismes, vidéos, logiciels, etc.) sont la propriété exclusive de NexGen ou de ses partenaires. Toute reproduction ou utilisation non autorisée est strictement interdite.

5. Responsabilités
NexGen ne peut être tenue responsable des dommages directs ou indirects résultant de l’utilisation de l’application, notamment en cas d’inaccessibilité, de perte de données ou d’erreur dans le contenu.

6. Données personnelles
Les données collectées via l’application sont traitées conformément au RGPD. Pour plus d’informations, veuillez consulter notre Politique de Confidentialité.

7. Modifications des CGU
NexGen se réserve le droit de modifier à tout moment les présentes CGU. Les utilisateurs seront informés de toute mise à jour via l’application.

8. Contact
Pour toute question relative à l’application ou aux présentes CGU, vous pouvez nous contacter à l’adresse suivante : contact@nexgen.fr
""";

  static const politiqueConfidentialite = """
Politique de Confidentialité – ReSources Relationnelles

Dernière mise à jour : 14/05/2025

1. Introduction
La présente Politique de Confidentialité a pour objectif de vous informer sur la manière dont l’application ReSources Relationnelles, éditée par NexGen, collecte, utilise, conserve et protège vos données personnelles.

2. Responsable du traitement
Le responsable du traitement des données est :
NexGen  
5 avenue de Victor Hugo, 51100 Reims, France  
Email : contact@nexgen.fr

3. Données collectées
Les données suivantes peuvent être collectées lors de l’utilisation de l’application :
- Données d’identification : prénom, nom, adresse e-mail, organisation partenaire (le cas échéant)
- Données de navigation et d’utilisation : fréquence d’utilisation, interactions dans l’application, préférences utilisateur
- Données sensibles : uniquement si vous y consentez explicitement et si cela est nécessaire au bon fonctionnement de l’outil

4. Finalités du traitement
Les données collectées sont utilisées uniquement pour :
- Fournir et améliorer les fonctionnalités de l’application
- Suivre et personnaliser l’accompagnement relationnel
- Assurer la sécurité et la stabilité de l’application
- Répondre aux obligations légales

5. Base légale du traitement
Les traitements de données réalisés par NexGen reposent sur :
- Le consentement de l’utilisateur
- L’exécution du contrat d’utilisation de l’application
- Le respect des obligations légales
- L’intérêt légitime de NexGen pour l’amélioration de ses services

6. Partage des données
Aucune donnée personnelle n’est vendue ni transmise à des tiers sans le consentement explicite de l’utilisateur, sauf obligation légale ou réquisition judiciaire.

7. Durée de conservation
Les données personnelles sont conservées pour la durée strictement nécessaire à la finalité du traitement. Les données peuvent être supprimées à la demande de l’utilisateur ou au bout de 3 ans d’inactivité.

8. Sécurité des données
NexGen met en œuvre toutes les mesures techniques et organisationnelles appropriées pour garantir la sécurité et la confidentialité des données personnelles.

9. Vos droits
Conformément au RGPD, vous disposez des droits suivants :
- Droit d’accès
- Droit de rectification
- Droit à l’effacement (droit à l’oubli)
- Droit d’opposition
- Droit à la portabilité
- Droit à la limitation du traitement

Pour exercer ces droits, contactez-nous à l’adresse suivante : contact@nexgen.fr

10. Modifications de la politique
NexGen se réserve le droit de modifier la présente Politique de Confidentialité à tout moment. Toute mise à jour sera notifiée via l’application.

11. Contact
Pour toute question relative à cette politique ou à vos données personnelles, vous pouvez nous contacter par e-mail à : contact@nexgen.fr
""";

  static Uri connect(String targetApiPath,
      {Map<String, dynamic>? queryParams}) {
    print(
      "Tentative de connexion à http://$serverIp:$serverPort$apiPathBase$targetApiPath avec $queryParams",
    );

    return Uri(
      scheme: 'http',
      host: serverIp,
      port: serverPort,
      path: apiPathBase + targetApiPath, // Just the path
      queryParameters: queryParams, // Properly handled by Dart
    );
  }
}
