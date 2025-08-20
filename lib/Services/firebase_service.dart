import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/usuario.dart';
import '../Models/ruta.dart';
import '../Models/viaje.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Nombres de colecciones
  static const String _colUsuarios = 'usuarios';
  static const String _colRutas = 'rutas';
  static const String _colViajes = 'viajes';

  /// Usuario autenticado actual (Auth)
  static User? get usuarioActual => _auth.currentUser;

  /// Cerrar sesión (Auth)
  static Future<void> cerrarSesion() async => _auth.signOut();

  // ======================
  // USUARIOS
  // ======================

  /// Crear o actualizar un usuario en Firestore (id == uid de Auth).
  static Future<bool> guardarUsuario(Usuario usuario) async {
    try {
      await _firestore
          .collection(_colUsuarios)
          .doc(usuario.id)
          .set(usuario.toJson(), SetOptions(merge: true));
      return true;
    } catch (e) {
      // Registra si usas Crashlytics
      // FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      // prints solo en desarrollo
      // ignore: avoid_print
      print('Error guardando usuario: $e');
      return false;
    }
  }

  /// Obtener usuario por id (uid de Auth).
  static Future<Usuario?> obtenerUsuario(String idUsuario) async {
    try {
      final doc = await _firestore.collection(_colUsuarios).doc(idUsuario).get();
      if (!doc.exists) return null;
      return Usuario.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      // ignore: avoid_print
      print('Error obteniendo usuario: $e');
      return null;
    }
  }

  /// Verificar si correo institucional ya está registrado en usuarios.
  static Future<bool> existeCorreoInstitucional(String correoInstitucional) async {
    try {
      final snap = await _firestore
          .collection(_colUsuarios)
          .where('correo_institucional', isEqualTo: correoInstitucional.trim())
          .limit(1)
          .get();
      return snap.docs.isNotEmpty;
    } catch (e) {
      // ignore: avoid_print
      print('Error verificando correo institucional: $e');
      return false;
    }
  }

  // ======================
  // RUTAS
  // ======================

  /// Crear ruta (el id debe venir generado en el modelo).
  static Future<bool> crearRuta(Ruta ruta) async {
    try {
      await _firestore.collection(_colRutas).doc(ruta.id).set(ruta.toJson());
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error creando ruta: $e');
      return false;
    }
  
  }

  /// Obtener rutas activas (estado == 'activa').
  static Future<List<Ruta>> obtenerRutasActivas() async {
    try {
      final snap = await _firestore
          .collection(_colRutas)
          .where('estado', isEqualTo: _enumToStringEstadoRuta(EstadoRuta.activa))
          .get();

      return snap.docs
          .map((d) => Ruta.fromJson(d.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error obteniendo rutas activas: $e');
      return [];
    }
  }

  /// Buscar rutas activas con filtro opcional por fecha de salida mínima.
  /// Asegúrate que el campo se llame 'fecha_hora_salida' y sea Timestamp.
  static Future<List<Ruta>> buscarRutasActivas({DateTime? fechaMinima}) async {
    try {
      Query q = _firestore
          .collection(_colRutas)
          .where('estado', isEqualTo: _enumToStringEstadoRuta(EstadoRuta.activa));

      if (fechaMinima != null) {
        q = q.where('fecha_hora_salida', isGreaterThanOrEqualTo: Timestamp.fromDate(fechaMinima));
      }

      final snap = await q.get();
      return snap.docs.map((d) => Ruta.fromJson(d.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error buscando rutas activas: $e');
      return [];
    }
  }

  /// Actualizar estado de una ruta.
  static Future<bool> actualizarEstadoRuta({
    required String idRuta,
    required EstadoRuta nuevoEstado,
  }) async {
    try {
      await _firestore.collection(_colRutas).doc(idRuta).update({
        'estado': _enumToStringEstadoRuta(nuevoEstado),
      });
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error actualizando estado de ruta: $e');
      return false;
    }
  }

  // ======================
  // VIAJES
  // ======================

  /// Crear solicitud de viaje.
  static Future<bool> crearSolicitudViaje(Viaje viaje) async {
    try {
      await _firestore.collection(_colViajes).doc(viaje.id).set(viaje.toJson());
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error creando solicitud de viaje: $e');
      return false;
    }
  }

  /// Obtener viajes por pasajero.
  static Future<List<Viaje>> obtenerViajesPorPasajero(String idPasajero) async {
    try {
      final snap = await _firestore
          .collection(_colViajes)
          .where('id_pasajero', isEqualTo: idPasajero)
          .get();

      return snap.docs
          .map((d) => Viaje.fromJson(d.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('Error obteniendo viajes por pasajero: $e');
      return [];
    }
  }

  /// Actualizar estado de viaje (usa string para no acoplar a un enum aquí).
  /// Si en tu modelo usas enum, convierte antes a string (v.toString().split('.').last).
  static Future<bool> actualizarEstadoViaje({
    required String idViaje,
    required String nuevoEstado,
  }) async {
    try {
      await _firestore.collection(_colViajes).doc(idViaje).update({'estado': nuevoEstado});
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error actualizando estado de viaje: $e');
      return false;
    }
  }

  // ======================
  // HELPERS PRIVADOS
  // ======================

  /// Convierte enum EstadoRuta a string tal como se guarda en Firestore.
  static String _enumToStringEstadoRuta(EstadoRuta estado) {
    // Resultado: 'activa', 'inactiva', etc.
    return estado.toString().split('.').last;
  }
}
