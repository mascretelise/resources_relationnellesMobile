/*
> Classe User
*/
class User {
  var id = -1;
  var nom = "";
  var prenom = "";
  var mail = "";
  var passwordHash = "";
  var status = 0;

  disconnect() {
    //remise des valeurs par défaut
    id = -1;
    nom = "";
    prenom = "";
    mail = "";
    passwordHash = "";
    status = 0;
  }
}
