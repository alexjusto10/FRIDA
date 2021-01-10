import 'dart:convert';

CiudadanoModel ciudadanoModelFromJson(String str) =>
    CiudadanoModel.fromJson(json.decode(str));

String ciudadanoModelToJson(CiudadanoModel data) => json.encode(data.toJson());

class CiudadanoModel {
  CiudadanoModel({
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.fechaNacimiento,
    this.calleNumero,
    this.colonia,
    this.cp,
    this.alcaldiaMunicipio,
    this.estado,
    this.email,
    this.psswrd,
    this.idRecomendacion,
    this.idCiudadano,
  });

  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  DateTime fechaNacimiento;
  String calleNumero;
  String colonia;
  String cp;
  String alcaldiaMunicipio;
  String estado;
  String email;
  String psswrd;
  int idRecomendacion;
  int idCiudadano;

  factory CiudadanoModel.fromJson(Map<String, dynamic> json) => CiudadanoModel(
        nombre: json["nombre"],
        apellidoPaterno: json["apellido_paterno"],
        apellidoMaterno: json["apellido_materno"],
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        calleNumero: json["calle_numero"],
        colonia: json["colonia"],
        cp: json["cp"],
        alcaldiaMunicipio: json["alcaldia_municipio"],
        estado: json["estado"],
        email: json["email"],
        psswrd: json["psswrd"],
        idRecomendacion: json["id_recomendacion"],
        idCiudadano: json["id_ciudadano"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
        "fecha_nacimiento":
            "${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}",
        "calle_numero": calleNumero,
        "colonia": colonia,
        "cp": cp,
        "alcaldia_municipio": alcaldiaMunicipio,
        "estado": estado,
        "email": email,
        "psswrd": psswrd,
        "id_recomendacion": idRecomendacion,
        "id_ciudadano": idCiudadano,
      };
}
