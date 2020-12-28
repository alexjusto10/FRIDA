import 'package:FRIDA/src/pages/centroAcopio_brigadista.dart';
import 'package:FRIDA/src/pages/centroAcopio_ciudadano.dart';
import 'package:FRIDA/src/pages/cuestionario.dart';
import 'package:FRIDA/src/pages/login_brigadista.dart';
import 'package:FRIDA/src/pages/mensaje.dart';
import 'package:FRIDA/src/pages/notificar_danio.dart';
import 'package:FRIDA/src/pages/perfil_ciudadano.dart';
import 'package:FRIDA/src/pages/registro.dart';
import 'package:FRIDA/src/pages/home_brigadista.dart';
import 'package:FRIDA/src/pages/login.dart';
import 'package:FRIDA/src/pages/home_ciudadano.dart';
import 'package:FRIDA/src/pages/home_page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'registro': (BuildContext context) => Registro(),
    'home_brigadista': (BuildContext context) => HomeBrigadista(),
    'login': (BuildContext context) => Login(),
    'home_ciudadano': (BuildContext context) => HomeCiudadano(),
    'cuestionario': (BuildContext context) => Cuestionario(),
    'perfil': (BuildContext context) => PerfilCiudadano(),
    'mensaje': (BuildContext context) => ModificarMensaje(),
    'notificar': (BuildContext context) => NotificarDanio(),
    'login_brigadista': (BuildContext context) => LoginBrigadista(),
    'centro_acopio_ciudadano': (BuildContext context) =>
        CentroAcopioCiudadano(),
    'centro_acopio_brigadista': (BuildContext context) =>
        CentroAcopioBrigadista(),
  };
}
