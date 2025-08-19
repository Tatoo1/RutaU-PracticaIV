import 'package:flutter/foundation.dart';

enum EstadoViaje {
  solicitado,
  pendiente,
  aprobado,
  enCurso,
  completado,
  cancelado,
}

/// Modelo de viaje para Ruta U
class Viaje {
  final String id;
  final String idRuta;
  final String idConductor;
  final String idPasajero;
  final DateTime fechaSolicitud;
  final EstadoViaje estado;
  final double? costoFinal;
  final DateTime fechaCreacion;

  Viaje({
    required this.id,
    required this.idRuta,
    required this.idConductor,
    required this.idPasajero,
    required this.fechaSolicitud,
    this.estado = EstadoViaje.solicitado,
    this.costoFinal,
    required this.fechaCreacion,
  });

  /// Constructor para crear instancia desde JSON (Firestore, API, etc.)
  factory Viaje.fromJson(Map<String, dynamic> json) {
    return Viaje(
      id: json['id'] ?? '',
      idRuta: json['id_ruta'] ?? '',
      idConductor: json['id_conductor'] ?? '',
      idPasajero: json['id_pasajero'] ?? '',
      fechaSolicitud: DateTime.parse(json['fecha_solicitud']),
      estado: _estadoDesdeString(json['estado'] ?? 'solicitado'),
      costoFinal: (json['costo_final'] != null) ? (json['costo_final'] as num).toDouble() : null,
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
    );
  }

  /// Serializa el objeto a JSON para guardar en base de datos o enviar por API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_ruta': idRuta,
      'id_conductor': idConductor,
      'id_pasajero': idPasajero,
      'fecha_solicitud': fechaSolicitud.toIso8601String(),
      'estado': estado.toString().split('.').last,
      'costo_final': costoFinal,
      'fecha_creacion': fechaCreacion.toIso8601String(),
    };
  }

  /// Método para crear copia con modificacones (útil para actualizar estado)
  Viaje copyWith({
    String? id,
    String? idRuta,
    String? idConductor,
    String? idPasajero,
    DateTime? fechaSolicitud,
    EstadoViaje? estado,
    double? costoFinal,
    DateTime? fechaCreacion,
  }) {
    return Viaje(
      id: id ?? this.id,
      idRuta: idRuta ?? this.idRuta,
      idConductor: idConductor ?? this.idConductor,
      idPasajero: idPasajero ?? this.idPasajero,
      fechaSolicitud: fechaSolicitud ?? this.fechaSolicitud,
      estado: estado ?? this.estado,
      costoFinal: costoFinal ?? this.costoFinal,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  /// Convierte string a EstadoViaje
  static EstadoViaje _estadoDesdeString(String estadoStr) {
    switch (estadoStr.toLowerCase()) {
      case 'solicitado':
        return EstadoViaje.solicitado;
      case 'pendiente':
        return EstadoViaje.pendiente;
      case 'aprobado':
        return EstadoViaje.aprobado;
      case 'encurso':
        return EstadoViaje.enCurso;
      case 'completado':
        return EstadoViaje.completado;
      case 'cancelado':
        return EstadoViaje.cancelado;
      default:
        return EstadoViaje.solicitado;
    }
  }

  @override
  String toString() {
    return 'Viaje(id: $id, ruta: $idRuta, conductor: $idConductor, pasajero: $idPasajero, estado: $estado)';
  }
}
