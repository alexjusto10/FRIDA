import 'dart:convert';

List<ArticulosExistenciaModel> articulosExistenciaModelFromJson(String str) =>
    List<ArticulosExistenciaModel>.from(
        json.decode(str).map((x) => ArticulosExistenciaModel.fromJson(x)));

String articulosExistenciaModelToJson(List<ArticulosExistenciaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ArticulosExistenciaModel {
  ArticulosExistenciaModel({
    this.idExistenciaArticuloCentro,
    this.existencia,
    this.urgencia,
    this.cantReq,
    this.idCentro,
    this.idArticulo,
  });

  int idExistenciaArticuloCentro;
  int existencia;
  int urgencia;
  int cantReq;
  int idCentro;
  int idArticulo;

  factory ArticulosExistenciaModel.fromJson(Map<String, dynamic> json) =>
      ArticulosExistenciaModel(
        idExistenciaArticuloCentro: json["idExistenciaArticuloCentro"],
        existencia: json["existencia"],
        urgencia: json["urgencia"],
        cantReq: json["cant_req"],
        idCentro: json["idCentro"],
        idArticulo: json["idArticulo"],
      );

  Map<String, dynamic> toJson() => {
        "idExistenciaArticuloCentro": idExistenciaArticuloCentro,
        "existencia": existencia,
        "urgencia": urgencia,
        "cant_req": cantReq,
        "idCentro": idCentro,
        "idArticulo": idArticulo,
      };
}
