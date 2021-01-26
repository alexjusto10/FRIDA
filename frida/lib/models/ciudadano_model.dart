import 'dart:convert';

CiudadanoModel ciudadanoModelFromJson(String str) =>
    CiudadanoModel.fromJson(json.decode(str));

String ciudadanoModelToJson(CiudadanoModel data) => json.encode(data.toJson());

class CiudadanoModel {
  CiudadanoModel({
    this.id,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.nombreUsuario,
    this.email,
    this.password,
    this.roles,
    
  });

  int id;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String nombreUsuario;
  String email;
  String password;
  List<Role> roles;

  factory CiudadanoModel.fromJson(Map<String, dynamic> json) => CiudadanoModel(
        id: json["id"],
        nombre: json["nombre"],
        apellidoPaterno: json["apellido_paterno"],
        apellidoMaterno: json["apellido_materno"],
        nombreUsuario: json["nombreUsuario"],
        email: json["email"],
        password: json["password"],
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
        "nombreUsuario": nombreUsuario,
        "email": email,
        "password": password,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
      };
}

class Role {
  Role({
    this.id,
    this.rolNombre,
  });

  int id;
  String rolNombre;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        rolNombre: json["rolNombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rolNombre": rolNombre,
      };
}
