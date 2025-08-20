import 'package:firebase_auth/firebase_auth.dart';

/// Resultado estándar para operaciones de autenticación.
class ResultadoAuth {
  final bool exitoso;
  final String? uid;
  final String? mensajeError;

  const ResultadoAuth({
    required this.exitoso,
    this.uid,
    this.mensajeError,
  });
}

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Registrar usuario con email y contraseña.
  static Future<ResultadoAuth> registrarConEmail({
    required String correo,
    required String contrasena,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: correo.trim(),
        password: contrasena,
      );
      return ResultadoAuth(exitoso: true, uid: cred.user?.uid);
    } on FirebaseAuthException catch (e) {
      return ResultadoAuth(exitoso: false, mensajeError: _mensajeDesdeCodigo(e.code));
    } catch (e) {
      return ResultadoAuth(
        exitoso: false,
        mensajeError: 'Error inesperado al registrar: ${e.toString()}',
      );
    }
  }

  /// Iniciar sesión con email y contraseña.
  static Future<ResultadoAuth> iniciarSesionConEmail({
    required String correo,
    required String contrasena,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: correo.trim(),
        password: contrasena,
      );
      return ResultadoAuth(exitoso: true, uid: cred.user?.uid);
    } on FirebaseAuthException catch (e) {
      return ResultadoAuth(exitoso: false, mensajeError: _mensajeDesdeCodigo(e.code));
    } catch (e) {
      return ResultadoAuth(
        exitoso: false,
        mensajeError: 'Error inesperado al iniciar sesión: ${e.toString()}',
      );
    }
  }

  /// Cerrar sesión.
  static Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  /// Usuario autenticado actual (puede ser null).
  static User? get usuarioActual => _auth.currentUser;

  /// Traducción de códigos de error de Firebase Auth a mensajes en español.
  static String _mensajeDesdeCodigo(String code) {
    switch (code) {
      case 'invalid-email':
        return 'El correo electrónico no tiene un formato válido.';
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'operation-not-allowed':
        return 'Operación no permitida. Contacte al administrador.';
      case 'weak-password':
        return 'La contraseña es demasiado débil (mínimo 6 caracteres).';
      case 'user-disabled':
        return 'La cuenta ha sido deshabilitada.';
      case 'user-not-found':
        return 'No existe un usuario con este correo.';
      case 'wrong-password':
        return 'La contraseña es incorrecta.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Intenta más tarde.';
      case 'network-request-failed':
        return 'Error de red. Verifique su conexión a Internet.';
      default:
        return 'Ocurrió un error de autenticación. Código: $code';
    }
  }
}
