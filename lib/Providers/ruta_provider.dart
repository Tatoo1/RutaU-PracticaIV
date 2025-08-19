import 'package:flutter/material.dart';
import 'package:ruta_u/Models/ruta.dart';


class RutaProvider with ChangeNotifier {
  Ruta? usuarioActual;

  void setUsuario(Ruta ruta) {
    usuarioActual = ruta;
    notifyListeners();
  }
}
