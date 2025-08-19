import 'package:flutter/material.dart';
import '../Models/usuario.dart';

class UsuarioProvider with ChangeNotifier {
  Usuario? usuarioActual;

  void setUsuario(Usuario usuario) {
    usuarioActual = usuario;
    notifyListeners();
  }
}
