import 'package:FRIDA/src/providers/menu_provider.dart';
import 'package:FRIDA/src/utils/icono_string_util.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FRIDA'),
      ),
      body: _lista(),
    );
  }

  Widget _lista() {
    /*menuProvider.cargarData().then((opciones){
      print('_lista');
      print(opciones);
    });
    return ListView(
      children: _listaItems(),   
    );*/

    return FutureBuilder(
      future: menuProvider.cargarData(),
      initialData: [],
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        return ListView(
          children: _listaItems(snapshot.data, context),
        );
      },
    );
  }

  List<Widget> _listaItems(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];
    Widget widgetTemp = ListTile(
      title: Text('Login ciudadano'),
      leading: getIcon('add_alert'),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.pushNamed(context, 'login');
      },
    );
    opciones..add(widgetTemp)..add(Divider());
    widgetTemp = ListTile(
      title: Text('Login brigadista'),
      leading: getIcon('person_outline'),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.pushNamed(context, 'login_brigadista');
      },
    );
    opciones..add(widgetTemp)..add(Divider());
    /*data.forEach((opt) {
      final widgetTemp = ListTile(
        title: Text(opt['texto']),
        leading: getIcon(opt['icon']),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          /*final route = MaterialPageRoute(
            builder: (context) => AlertPage()
          );
          Navigator.push(context, route);*/

          //Las rutas deben de estar definidas en el main.dart
          Navigator.pushNamed(context, opt['ruta']);
        },
      );
      opciones..add(widgetTemp)..add(Divider());
    });*/
    return opciones;
  }
}
