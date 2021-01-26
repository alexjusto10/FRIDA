import 'dart:convert';

CasoModel casoModelFromJson(String str) => CasoModel.fromJson(json.decode(str));

String casoModelToJson(CasoModel data) => json.encode(data.toJson());

class CasoModel {
  CasoModel({
    this.idCaso,
    this.prioridad,
    this.tipoDanio,
    this.colonia,
    this.cp,
    this.estado,
    this.statusCaso,
    this.fechaReportado,
    this.fechaEvaluado,
    this.idCuestionario,
    this.idCiudadano,
    this.calleNumero,
    this.alcaldiaMunicipio,
  });

  int idCaso;
  int prioridad;
  String tipoDanio;
  String colonia;
  String cp;
  String estado;
  int statusCaso;
  DateTime fechaReportado;
  dynamic fechaEvaluado;
  int idCuestionario;
  int idCiudadano;
  String calleNumero;
  String alcaldiaMunicipio;

  factory CasoModel.fromJson(Map<String, dynamic> json) => CasoModel(
        idCaso: json["idCaso"],
        prioridad: json["prioridad"],
        tipoDanio: json["tipo_danio"],
        colonia: json["colonia"],
        cp: json["cp"],
        estado: json["estado"],
        statusCaso: json["status_caso"],
        fechaReportado: DateTime.parse(json["fecha_reportado"]),
        fechaEvaluado: json["fecha_evaluado"],
        idCuestionario: json["idCuestionario"],
        idCiudadano: json["idCiudadano"],
        calleNumero: json["calle_numero"],
        alcaldiaMunicipio: json["alcaldia_municipio"],
      );

  Map<String, dynamic> toJson() => {
        "idCaso": idCaso,
        "prioridad": prioridad,
        "tipo_danio": tipoDanio,
        "colonia": colonia,
        "cp": cp,
        "estado": estado,
        "status_caso": statusCaso,
        "fecha_reportado":
            "${fechaReportado.year.toString().padLeft(4, '0')}-${fechaReportado.month.toString().padLeft(2, '0')}-${fechaReportado.day.toString().padLeft(2, '0')}",
        "fecha_evaluado": fechaEvaluado,
        "idCuestionario": idCuestionario,
        "idCiudadano": idCiudadano,
        "calle_numero": calleNumero,
        "alcaldia_municipio": alcaldiaMunicipio,
      };
}
