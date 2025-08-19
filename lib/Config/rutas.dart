import 'package:flutter/material.dart';
import '../Pantallas/Autenticacion/login_auth.dart';
import '../Pantallas/Autenticacion/registro_usuario.dart';
import '../Pantallas/Inicio/pantalla_inicio.dart';
import '../Pantallas/Inicio/pantalla_perfil.dart';
import '../Pantallas/Conductor/gestionar_vehiculos.dart';
import '../Pantallas/Conductor/publicar_ruta.dart';
import '../Pantallas/Pasajero/buscar_ruta.dart';

class AppRoutes {
  static const String login = '/login';
  static const String registro = '/registro';
  static const String inicio = '/inicio';
  static const String perfil = '/perfil';
  static const String publicarRuta = '/publicar-ruta';
  static const String gestionarVehiculos = '/gestionar-vehiculos';
  static const String buscarRuta = '/buscar-ruta';

  static Map<String, WidgetBuilder> rutas = {
    login: (context) => const LoginAuth(),
    registro: (context) => const RegistroUsuario(),
    inicio: (context) => const PantallaInicio(),
    perfil: (context) => const PantallaPerfil(),
    publicarRuta: (context) => const PublicarRuta(),
    gestionarVehiculos: (context) => const GestionarVehiculos(),
    buscarRuta: (context) => const BuscarRuta(),
  };
}
