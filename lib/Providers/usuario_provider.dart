import 'package:flutter/material.dart';
import '../Models/usuario.dart';
import '../Services/auth_service.dart';
import '../Services/firebase_service.dart';

class UsuarioProvider with ChangeNotifier {
  Usuario? _usuarioActual;
  bool _cargando = false;
  String? _error;

  Usuario? get usuarioActual => _usuarioActual;
  bool get cargando => _cargando;
  String? get error => _error;
  bool get estaAutenticado => _usuarioActual != null;
  bool get esConductor =>
      _usuarioActual != null &&
      (_usuarioActual!.tipoUsuario == TipoUsuario.conductor || _usuarioActual!.tipoUsuario == TipoUsuario.ambos);

  /// Inicializa usuario desde Firebase Auth y Firestore.
  Future<void> inicializarUsuario() async {
    _cargando = true;
    notifyListeners();

    try {
      final authUser = FirebaseService.usuarioActual;
      if (authUser != null) {
        _usuarioActual = await FirebaseService.obtenerUsuario(authUser.uid);
      } else {
        _usuarioActual = null;
      }
      _error = null;
    } catch (e) {
      _error = 'Error al inicializar usuario: ${e.toString()}';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  /// Método para iniciar sesión.
  Future<bool> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final resultado = await AuthService.iniciarSesionConEmail(
        correo: correo,
        contrasena: contrasena,
      );
      if (!resultado.exitoso || resultado.uid == null) {
        _error = resultado.mensajeError ?? 'No se pudo iniciar sesión';
        return false;
      }

      final usuario = await FirebaseService.obtenerUsuario(resultado.uid!);
      if (usuario == null) {
        _error = 'No se encontraron datos del usuario.';
        return false;
      }

      _usuarioActual = usuario;
      return true;
    } catch (e) {
      _error = 'Error al iniciar sesión: ${e.toString()}';
      return false;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  /// Método para registrar un nuevo usuario.
  Future<bool> registrarUsuario({
    required String nombres,
    required String apellidos,
    required String correoInstitucional,
    required String numeroMatricula,
    required String contrasena,
    required TipoUsuario tipoUsuario,
  }) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      // Validación de dominio específico
      final dominioValido = RegExp(r'^[\w\.\-]+@ucentral\.edu\.co$', caseSensitive: false)
          .hasMatch(correoInstitucional.trim());
      if (!dominioValido) {
        _error = 'Debe usar un correo institucional @ucentral.edu.co';
        return false;
      }

      // Verificar si el correo ya existe en Firestore
      final existe = await FirebaseService.existeCorreoInstitucional(correoInstitucional.trim());
      if (existe) {
        _error = 'El correo institucional ya está registrado';
        return false;
      }

      // Crear cuenta en Firebase Auth
      final registro = await AuthService.registrarConEmail(
        correo: correoInstitucional.trim(),
        contrasena: contrasena,
      );
      if (!registro.exitoso || registro.uid == null) {
        _error = registro.mensajeError ?? 'Error al crear la cuenta';
        return false;
      }

      // Crear objeto Usuario para Firestore
      final nuevoUsuario = Usuario(
        id: registro.uid!,
        nombres: nombres,
        apellidos: apellidos,
        correoInstitucional: correoInstitucional.trim(),
        numeroMatricula: numeroMatricula.trim(),
        tipoUsuario: tipoUsuario,
      );

      final exitoso = await FirebaseService.guardarUsuario(nuevoUsuario);
      if (!exitoso) {
        _error = 'Error guardando la información del usuario.';
        return false;
      }

      _usuarioActual = nuevoUsuario;
      return true;
    } catch (e) {
      _error = 'Error registrando usuario: ${e.toString()}';
      return false;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  /// Cierra sesión y limpia estado
  Future<void> cerrarSesion() async {
    await FirebaseService.cerrarSesion();
    _usuarioActual = null;
    _error = null;
    notifyListeners();
  }

  /// Limpia el error actual
  void limpiarError() {
    _error = null;
    notifyListeners();
  }
}
