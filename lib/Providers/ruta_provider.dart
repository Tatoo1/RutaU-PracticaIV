import 'package:flutter/material.dart';
import '../Models/ruta.dart';
import '../Services/firebase_service.dart';

class RutaProvider with ChangeNotifier {
  List<Ruta> _rutas = [];
  bool _cargando = false;
  String? _error;

  List<Ruta> get rutas => _rutas;
  bool get cargando => _cargando;
  String? get error => _error;

  /// Carga rutas activas desde Firestore, opcional filtro por fecha mínima.
  Future<void> cargarRutas({DateTime? fechaMinima}) async {
    _cargando = true;
    notifyListeners();

    try {
      _rutas = await FirebaseService.buscarRutasActivas(fechaMinima: fechaMinima);
      _error = null;
    } catch (e) {
      _rutas = [];
      _error = 'Error cargando rutas: ${e.toString()}';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  /// Publicar una nueva ruta y actualizar lista local
  Future<bool> publicarRuta(Ruta ruta) async {
    final exito = await FirebaseService.crearRuta(ruta);
    if (exito) {
      _rutas.add(ruta);
      notifyListeners();
    }
    return exito;
  }

  /// Actualizar estado de ruta (ejemplo: activa, cancelada)
  Future<bool> actualizarEstadoRuta(String idRuta, EstadoRuta nuevoEstado) async {
    final exito = await FirebaseService.actualizarEstadoRuta(
      idRuta: idRuta,
      nuevoEstado: nuevoEstado,
    );
    if (exito) {
      int idx = _rutas.indexWhere((r) => r.id == idRuta);
      if (idx != -1) {
        _rutas[idx] = _rutas[idx].copyWith(estado: nuevoEstado);
        notifyListeners();
      }
    }
    return exito;
  }

  /// Limpia errores
  void limpiarError() {
    _error = null;
    notifyListeners();
  }
}
