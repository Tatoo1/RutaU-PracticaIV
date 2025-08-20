import 'package:flutter/material.dart';
import '../Models/viaje.dart';
import '../Services/firebase_service.dart';

class ViajeProvider with ChangeNotifier {
  List<Viaje> _viajes = [];
  bool _cargando = false;
  String? _error;

  List<Viaje> get viajes => _viajes;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargarViajesPorPasajero(String idPasajero) async {
    _cargando = true;
    notifyListeners();

    try {
      _viajes = await FirebaseService.obtenerViajesPorPasajero(idPasajero);
      _error = null;
    } catch (e) {
      _error = 'Error cargando viajes: ${e.toString()}';
      _viajes = [];
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<bool> crearSolicitudViaje(Viaje viaje) async {
    final exito = await FirebaseService.crearSolicitudViaje(viaje);
    if (exito) {
      _viajes.add(viaje);
      notifyListeners();
    }
    return exito;
  }

  Future<bool> actualizarEstadoViaje(String idViaje, EstadoViaje nuevoEstado) async {
    final exito = await FirebaseService.actualizarEstadoViaje(
      idViaje: idViaje,
      nuevoEstado: nuevoEstado.toString().split('.').last,
    );

    if (exito) {
      int index = _viajes.indexWhere((v) => v.id == idViaje);
      if (index != -1) {
        _viajes[index] = _viajes[index].copyWith(estado: nuevoEstado);
        notifyListeners();
      }
    }
    return exito;
  }
}
      