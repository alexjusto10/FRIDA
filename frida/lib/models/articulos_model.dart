import 'dart:convert';

List<ArticulosModel> articulosModelFromJson(String str) =>
    List<ArticulosModel>.from(
        json.decode(str).map((x) => ArticulosModel.fromJson(x)));

String articulosModelToJson(List<ArticulosModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ArticulosModel {
  ArticulosModel({
    this.idArticulo,
    this.nombre,
  });

  int idArticulo;
  String nombre;

  factory ArticulosModel.fromJson(Map<String, dynamic> json) => ArticulosModel(
        idArticulo: json["idArticulo"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "idArticulo": idArticulo,
        "nombre": nombre,
      };
}
