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
  static const apiKey = ""; //Clé api
  static var configfile =
      ""; //Chemin vers le fichier de configuration de l'application
  static var timeoutValue = Duration(seconds: 5); //secondes

  static connect(String targetApi) {
    var apiPath = apiPathBase + targetApi; //Chemin de l'api
    print(
        "Tentative de connexion à http://${serverIp}:${serverPort}${apiPath}");
    return Uri(
      scheme: 'http',
      host: serverIp,
      port: serverPort,
      path: apiPath,
    );
  }
}
