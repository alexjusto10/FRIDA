import 'package:FRIDA/models/informacion_caso_brigadista_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomeBrigadista extends StatefulWidget {
  @override
  _HomeBrigadistaState createState() => _HomeBrigadistaState();
}

class _HomeBrigadistaState extends State<HomeBrigadista> {
  String _sesionActivaPrefs = "sesionActiva",
      _usuarioActivoPrefs = "usuarioActivo",
      _usuarioActivo;
  bool _cargando = true, _casoAsignado = false;
  InformacionCasoBrigadistaModel _informacion;
  CameraPosition _initialPosition;

  @override
  void initState() {
    super.initState();
    _revisarSesionActiva().then((valor) {
      if (valor) {
        _recuperarCaso().then((informacion) {
          setState(() {
            if (informacion) {
              _casoAsignado = true;
              _initialPosition = CameraPosition(
                  target: LatLng(double.parse(_informacion.lat),
                      double.parse(_informacion.lng)),
                  zoom: 15.0);
            } else {
              _casoAsignado = false;
            }
            _cargando = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              leading: Container(),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add_location),
                  onPressed: () {
                    Navigator.pushNamed(context, 'centro_acopio_brigadista');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: () {
                    _dialogCerrarSesion();
                  },
                ),
              ],
            ),
            body: _cargando == true
                ? _cargarDatos()
                : _mostrarInformacionCaso()));
  }

  Widget _mostrarInformacionCaso() {
    return _casoAsignado == true ? _informacionCaso() : _sinIformacionCaso();
  }

  Widget _sinIformacionCaso() {
    return Center(
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        height: 140,
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.error,
                  color: Colors.grey,
                  size: 50.0,
                ),
                title: Text(
                  'Sin caso asignado',
                  style: TextStyle(fontSize: 30.0),
                ),
                subtitle: Text(
                  'No se tiene ningún caso asignado.',
                  style: TextStyle(fontSize: 19.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _informacionCaso() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      children: <Widget>[
        _cardTipo1(),
        SizedBox(
          height: 5.0,
        ),
        _mapas(),
        SizedBox(
          height: 20.0,
        ),
        Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Text('Fotos del inmueble',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left),
                  _cardTipo2(),
                ],
              )),
        ),
        SizedBox(
          height: 30.0,
        ),
        ButtonTheme(
          height: 45.0,
          child: RaisedButton(
            elevation: 5.0,
            child: Text(
              'Confirmar evaluación',
              style: TextStyle(fontSize: 17),
            ),
            color: Color(0xffffd54f),
            textColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            onPressed: _dialogConfirmarEvaluacion,
          ),
        ),
      ],
    );
  }

  Widget _cargarDatos() {
    return Center(
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        height: 140,
        child: Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                leading: CircularProgressIndicator(),
                title: Text(
                  'Cargando datos...',
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardTipo1() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: _simboloPrioridad(),
              title: Text(
                'Daño de prioridad ' + _definirPrioridad(),
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _informacion.calleNumero.toString() +
                    ', ' +
                    _informacion.colonia.toString() +
                    ', ' +
                    _informacion.alcaldiaMunicipio.toString() +
                    ', ' +
                    _informacion.cp.toString() +
                    ', ' +
                    _informacion.estado.toString(),
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _definirPrioridad() {
    if (_informacion.prioridad == 1) {
      return "alta";
    } else if (_informacion.prioridad == 2) {
      return "media";
    } else {
      return "baja";
    }
  }

  Icon _simboloPrioridad() {
    if (_informacion.prioridad == 1) {
      return Icon(
        Icons.error,
        color: Colors.red,
        size: 40.0,
      );
    } else if (_informacion.prioridad == 2) {
      return Icon(
        Icons.error,
        color: Colors.amber[900],
        size: 40.0,
      );
    } else {
      return Icon(
        Icons.error,
        color: Colors.amber,
        size: 40.0,
      );
    }
  }

  Widget _cardTipo2() {
    return Container(
        height: 300,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        alignment: Alignment.topCenter,
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _informacion.imagenes.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Container(
                          width: 200.0,
                          child: FlatButton(
                              padding: EdgeInsets.all(0.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.memory(convert.base64Decode(
                                      _informacion.imagenes[index].bytes)),
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        title: Text('Imagen del inmueble'),
                                        content: Container(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.memory(convert
                                                .base64Decode(_informacion
                                                    .imagenes[index].bytes)),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          ButtonTheme(
                                              height: 45.0,
                                              child: RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                color: Color(0xffffd54f),
                                                child: Text('Salir'),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              )),
                                        ],
                                      );
                                    });
                              })));
                })));
  }

  final Set<Marker> _markers = Set();
  void _onMapCreated(GoogleMapController controller) {
    double lat = double.parse(_informacion.lat),
        lng = double.parse(_informacion.lng);
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('Caso encontrado'),
          position: LatLng(lat, lng),
        ),
      );
    });
  }

  Widget _mapas() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.transparent,
          ),
          height: 250.0,
          alignment: Alignment.center,
          child: ClipRRect(
            child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: <Widget>[
                    GoogleMap(
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: _initialPosition,
                      markers: _markers,
                      gestureRecognizers: Set()
                        ..add(Factory<PanGestureRecognizer>(
                            () => PanGestureRecognizer())),
                    ),
                  ],
                )),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ],
    );
  }

  void _dialogConfirmarEvaluacion() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Caso evaluado'),
            content: Container(
              child: Text(
                '¿Desea cerrar este caso y marcarlo como evaluado?',
                style: TextStyle(
                  fontSize: 17,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            actions: <Widget>[
              ButtonTheme(
                  height: 45.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xffd8a500),
                    child: Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              ButtonTheme(
                  height: 45.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xffffd54f),
                    child: Text('Confirmar'),
                    onPressed: () {
                      setState(() {
                        _casoAsignado = false;
                        Navigator.of(context).pop();
                        _casoEvaluado().then((value) {
                          if (value)
                            _showToast('Caso evaluado con éxito');
                          else
                            _showToast('Error al confirmar la evaluación');
                        });
                      });
                    },
                  )),
            ],
          );
        });
  }

  Future<bool> _casoEvaluado() async {
    var url = 'http://13.84.215.39:8080/confirmar/caso/' + _usuarioActivo;
    var response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  void _showToast(String mensaje) {
    Fluttertoast.showToast(
        msg: mensaje,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  void _dialogCerrarSesion() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Cerrar sesión'),
            content: Container(
              child: Text(
                '¿Desea cerrar sesión?',
                style: TextStyle(
                  fontSize: 17,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            actions: <Widget>[
              ButtonTheme(
                  height: 45.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xffd8a500),
                    child: Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              ButtonTheme(
                  height: 45.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xffffd54f),
                    child: Text('Cerrar sesión'),
                    onPressed: () {
                      _cerrarSesion().then((valor) {
                        Navigator.pushNamed(context, 'login_brigadista');
                      });
                    },
                  )),
            ],
          );
        });
  }

  Future<bool> _cerrarSesion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_sesionActivaPrefs, null);
    return true;
  }

  Future<bool> _revisarSesionActiva() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _usuarioActivo = prefs.getString(_usuarioActivoPrefs);
    return true;
  }

  Future<bool> _recuperarCaso() async {
    var url =
        'http://13.84.215.39:8080/listar/casoXNombreUsuario/' + _usuarioActivo;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      if (convert.jsonDecode(response.body)['idCaso'] != null) {
        _informacion = informacionCasoBrigadistaModelFromJson(response.body);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Cerrar la aplicación'),
            content: Container(
              child: Text(
                '¿Desea salir de la aplicación?',
                style: TextStyle(
                  fontSize: 17,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            actions: <Widget>[
              ButtonTheme(
                height: 45.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Color(0xffd8a500),
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              ButtonTheme(
                  height: 45.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xffffd54f),
                    child: Text('Salir'),
                    onPressed: () => SystemNavigator.pop(),
                  )),
            ],
          );
        });
  }
}
