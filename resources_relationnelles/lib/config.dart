/*
> Page de configuration où mettre les informations en dur
> Ajouter des données si nécessaire
*/

class Config {
  static var serverIp =
      "10.0.2.2"; //IP du serveur test/réel (10.0.2.2 envoie à la machine où se trouve l'emulateur)
  static const serverPort = 3000;
  static var apiPathBase = '/api';
  static var registerRoute="/register";
  static var loginRoute="/login";
  static var uploadRoute="/upload";
  static var apiKey = ""; //Clé api
  static var configfile =
      ""; //Chemin vers le fichier de configuration de l'application
  static var timeoutValue = Duration(seconds: 10); //secondes

  static connect(String targetApi){
    return Uri(
                scheme: 'http',
                host: serverIp,
                port: serverPort,
                path: apiPathBase+targetApi,
    );
  }
}
