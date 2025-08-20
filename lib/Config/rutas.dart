import 'package:flutter/material.dart';
import '../pantallas/autenticacion/login_auth.dart';
import '../pantallas/autenticacion/registro_usuario.dart';

class AppRoutes {
  static const String login = '/login';
  static const String registro = '/registro';
  static const String inicio = '/inicio';

  static Map<String, WidgetBuilder> rutas = {
    login: (BuildContext context) => const LoginAuth(),
    registro: (BuildContext context) => const RegistroUsuario(),
    inicio: (BuildContext context) => const Scaffold(
          body: Center(child: Text('Pantalla de Inicio')),
        ),
  };
}
