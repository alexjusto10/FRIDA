import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.token,
    this.bearer,
    this.nombreUsuario,
    this.authorities,
  });

  String token;
  String bearer;
  String nombreUsuario;
  List<Authority> authorities;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        token: json["token"],
        bearer: json["bearer"],
        nombreUsuario: json["nombreUsuario"],
        authorities: List<Authority>.from(
            json["authorities"].map((x) => Authority.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "bearer": bearer,
        "nombreUsuario": nombreUsuario,
        "authorities": List<dynamic>.from(authorities.map((x) => x.toJson())),
      };
}

class Authority {
  Authority({
    this.authority,
  });

  String authority;

  factory Authority.fromJson(Map<String, dynamic> json) => Authority(
        authority: json["authority"],
      );

  Map<String, dynamic> toJson() => {
        "authority": authority,
      };
}
