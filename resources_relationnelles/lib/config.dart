/*
> Page de configuration où mettre les informations en dur
> Ajouter des données si nécessaire
*/

class Config {
  static var serverIp =
      "http://10.0.2.2:3000/api"; //IP du serveur test/réel (10.0.2.2:80 envoie à la machine où se trouve l'emulateur)
  static var apiKey = ""; //Clé api
  static var configfile =
      ""; //Chemin vers le fichier de configuration de l'application
  static var loginRoute = "/login";
  static var registerRoute = "/register";
  static var timeoutValue = 5; //secondes
}
