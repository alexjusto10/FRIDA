import 'dart:convert';

List<CentroAcopioModel> centroAcopioModelFromJson(String str) =>
    List<CentroAcopioModel>.from(
        json.decode(str).map((x) => CentroAcopioModel.fromJson(x)));

String centroAcopioModelToJson(List<CentroAcopioModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CentroAcopioModel {
  CentroAcopioModel({
    this.idCentro,
    this.nombre,
    this.calleNumero,
    this.colonia,
    this.cp,
    this.alcaldiaMunicipio,
    this.estado,
    this.lat,
    this.lng,
  });

  int idCentro;
  String nombre;
  String calleNumero;
  String colonia;
  String cp;
  String alcaldiaMunicipio;
  String estado;
  String lat;
  String lng;

  factory CentroAcopioModel.fromJson(Map<String, dynamic> json) =>
      CentroAcopioModel(
        idCentro: json["idCentro"],
        nombre: json["nombre"],
        calleNumero: json["calle_numero"],
        colonia: json["colonia"],
        cp: json["cp"],
        alcaldiaMunicipio: json["alcaldia_municipio"],
        estado: json["estado"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "idCentro": idCentro,
        "nombre": nombre,
        "calle_numero": calleNumero,
        "colonia": colonia,
        "cp": cp,
        "alcaldia_municipio": alcaldiaMunicipio,
        "estado": estado,
        "lat": lat,
        "lng": lng,
      };
}
