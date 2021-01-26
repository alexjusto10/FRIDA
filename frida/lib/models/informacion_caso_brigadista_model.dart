import 'dart:convert';

InformacionCasoBrigadistaModel informacionCasoBrigadistaModelFromJson(
        String str) =>
    InformacionCasoBrigadistaModel.fromJson(json.decode(str));

String informacionCasoBrigadistaModelToJson(
        InformacionCasoBrigadistaModel data) =>
    json.encode(data.toJson());

class InformacionCasoBrigadistaModel {
  InformacionCasoBrigadistaModel({
    this.idCaso,
    this.prioridad,
    this.tipoDanio,
    this.calleNumero,
    this.colonia,
    this.cp,
    this.alcaldiaMunicipio,
    this.estado,
    this.statusCaso,
    this.fechaReportado,
    this.fechaEvaluado,
    this.idCuestionario,
    this.lat,
    this.lng,
    this.imagenes,
  });

  int idCaso;
  dynamic prioridad;
  dynamic tipoDanio;
  String calleNumero;
  String colonia;
  dynamic cp;
  String alcaldiaMunicipio;
  String estado;
  int statusCaso;
  DateTime fechaReportado;
  dynamic fechaEvaluado;
  dynamic idCuestionario;
  String lat;
  String lng;
  List<Imagene> imagenes;

  factory InformacionCasoBrigadistaModel.fromJson(Map<String, dynamic> json) =>
      InformacionCasoBrigadistaModel(
        idCaso: json["idCaso"],
        prioridad: json["prioridad"],
        tipoDanio: json["tipo_danio"],
        calleNumero: json["calle_numero"],
        colonia: json["colonia"],
        cp: json["cp"],
        alcaldiaMunicipio: json["alcaldia_municipio"],
        estado: json["estado"],
        statusCaso: json["status_caso"],
        fechaReportado: DateTime.parse(json["fecha_reportado"]),
        fechaEvaluado: json["fecha_evaluado"],
        idCuestionario: json["idCuestionario"],
        lat: json["lat"],
        lng: json["lng"],
        imagenes: List<Imagene>.from(
            json["imagenes"].map((x) => Imagene.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "idCaso": idCaso,
        "prioridad": prioridad,
        "tipo_danio": tipoDanio,
        "calle_numero": calleNumero,
        "colonia": colonia,
        "cp": cp,
        "alcaldia_municipio": alcaldiaMunicipio,
        "estado": estado,
        "status_caso": statusCaso,
        "fecha_reportado": fechaReportado.toIso8601String(),
        "fecha_evaluado": fechaEvaluado,
        "idCuestionario": idCuestionario,
        "lat": lat,
        "lng": lng,
        "imagenes": List<dynamic>.from(imagenes.map((x) => x.toJson())),
      };
}

class Imagene {
  Imagene({
    this.idImagen,
    this.nombreImagen,
    this.bytes,
    this.idCaso,
  });

  int idImagen;
  String nombreImagen;
  String bytes;
  int idCaso;

  factory Imagene.fromJson(Map<String, dynamic> json) => Imagene(
        idImagen: json["idImagen"],
        nombreImagen: json["nombreImagen"],
        bytes: json["bytes"],
        idCaso: json["idCaso"],
      );

  Map<String, dynamic> toJson() => {
        "idImagen": idImagen,
        "nombreImagen": nombreImagen,
        "bytes": bytes,
        "idCaso": idCaso,
      };
}
