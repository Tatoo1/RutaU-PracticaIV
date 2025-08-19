import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/usuario.dart';
import '../Models/ruta.dart';
import '../Models/viaje.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Colecciones
  static const String coleccionUsuarios = 'usuarios';
  static const String coleccionRutas = 'rutas';
  static const String coleccionViajes = 'viajes';

  /// Obtener usuario autenticado actual de Firebase Auth
  static User? get usuarioActual => _auth.currentUser;

  /// Cerrar sesión
  static Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  // ======================
  // FUNCIONES USUARIO
  // ======================

  /// Crea o actualiza un usuario en Firestore
  static Future<bool> guardarUsuario(Usuario usuario) async {
    try {
      await _firestore
          .collection(coleccionUsuarios)
          .doc(usuario.id)
          .set(usuario.toJson(), SetOptions(merge: true));
      return true;
    } catch (e) {
      print('Error guardando usuario: $e');
      return false;
    }
  }

  /// Obtiene un usuario por ID
  static Future<Usuario?> obtenerUsuario(String idUsuario) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(coleccionUsuarios).doc(idUsuario).get();
      if (!doc.exists) return null;
      return Usuario.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error obteniendo usuario: $e');
      return null;
    }
  }

  /// Verifica si un correo ya está registrado
  static Future<bool> verificarCorreoExistente(String correo) async {
    try {
      QuerySnapshot query = await _firestore.collection(coleccionUsuarios)
          .where('correo_institucional', isEqualTo: correo)
          .limit(1)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      print('Error verificando correo: $e');
      return false;
    }
  }

  // ======================
  // FUNCIONES RUTA
  // ======================

  /// Crea una nueva ruta
  static Future<bool> crearRuta(Ruta ruta) async {
    try {
      await _firestore.collection(coleccionRutas).doc(ruta.id).set(ruta.toJson());
      return true;
    } catch (e) {
      print('Error creando ruta: $e');
      return false;
    }
  }

  /// Obtiene rutas activas
  static Future<List<Ruta>> obtenerRutasActivas() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(coleccionRutas)
          .where('estado', isEqualTo: 'activa')
          .get();

      return snapshot.docs
          .map((doc) => Ruta.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error obteniendo rutas activas: $e');
      return [];
    }
  }

  // ======================
  // FUNCIONES VIAJE
  // ======================

  /// Crea solicitud de viaje
  static Future<bool> crearSolicitudViaje(Viaje viaje) async {
    try {
      await _firestore.collection(coleccionViajes).doc(viaje.id).set(viaje.toJson());
      return true;
    } catch (e) {
      print('Error creando solicitud de viaje: $e');
      return false;
    }
  }

  /// Obtiene viajes de un pasajero
  static Future<List<Viaje>> obtenerViajesPorPasajero(String idPasajero) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(coleccionViajes)
          .where('id_pasajero', isEqualTo: idPasajero)
          .get();

      return snapshot.docs
          .map((doc) => Viaje.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error obteniendo viajes: $e');
      return [];
    }
  }
  static Future<List<Ruta>> buscarRutasActivas({DateTime? fechaMinima}) async {
    try {
      Query query = _firestore
          .collection(coleccionRutas)
          .where('estado', isEqualTo: 'activa');

      if (fechaMinima != null) {
        query = query.where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(fechaMinima));
      }

      QuerySnapshot snapshot = await query.get();

      return snapshot.docs
          .map((doc) => Ruta.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error buscando rutas activas: $e');
      return [];
    }
  }
  /// Actualiza estado de un viaje
  static Future<bool> actualizarEstadoViaje(String idViaje, String nuevoEstado) async {
    try {
      await _firestore
          .collection(coleccionViajes)
          .doc(idViaje)
          .update({'estado': nuevoEstado});
      return true;
    } catch (e) {
      print('Error actualizando estado viaje: $e');
      return false;
    }
  }
}
