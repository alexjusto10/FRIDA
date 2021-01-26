import 'dart:convert';

List<RecomendacionModel> recomendacionModelFromJson(String str) =>
    List<RecomendacionModel>.from(
        json.decode(str).map((x) => RecomendacionModel.fromJson(x)));

String recomendacionModelToJson(List<RecomendacionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecomendacionModel {
  RecomendacionModel({
    this.textoRecomendacion,
    this.idRecomendacion,
  });

  String textoRecomendacion;
  int idRecomendacion;

  factory RecomendacionModel.fromJson(Map<String, dynamic> json) =>
      RecomendacionModel(
        textoRecomendacion: json["texto_recomendacion"],
        idRecomendacion: json["id_recomendacion"],
      );

  Map<String, dynamic> toJson() => {
        "texto_recomendacion": textoRecomendacion,
        "id_recomendacion": idRecomendacion,
      };
}
