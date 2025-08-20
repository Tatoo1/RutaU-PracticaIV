enum EstadoViaje {
  solicitado,
  pendiente,
  aprobado,
  enCurso,
  completado,
  cancelado,
}

class Viaje {
  final String id;
  final EstadoViaje estado;
  final DateTime fechaSolicitud;
  final String idRuta;
  final String idConductor;
  final String idPasajero;
  final double? costoFinal;
  final DateTime fechaCreacion;

  Viaje({
    required this.id,
    required this.estado,
    required this.fechaSolicitud,
    required this.idRuta,
    required this.idConductor,
    required this.idPasajero,
    this.costoFinal,
    required this.fechaCreacion,
  });

  Viaje copyWith({
    String? id,
    EstadoViaje? estado,
    DateTime? fechaSolicitud,
    String? idRuta,
    String? idConductor,
    String? idPasajero,
    double? costoFinal,
    DateTime? fechaCreacion,
  }) {
    return Viaje(
      id: id ?? this.id,
      estado: estado ?? this.estado,
      fechaSolicitud: fechaSolicitud ?? this.fechaSolicitud,
      idRuta: idRuta ?? this.idRuta,
      idConductor: idConductor ?? this.idConductor,
      idPasajero: idPasajero ?? this.idPasajero,
      costoFinal: costoFinal ?? this.costoFinal,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  factory Viaje.fromJson(Map<String, dynamic> json) {
    return Viaje(
      id: json['id'] ?? '',
      estado: _estadoDesdeString(json['estado'] ?? 'solicitado'),
      fechaSolicitud: DateTime.parse(json['fechaSolicitud']),
      idRuta: json['idRuta'] ?? '',
      idConductor: json['idConductor'] ?? '',
      idPasajero: json['idPasajero'] ?? '',
      costoFinal: json['costoFinal'] != null ? (json['costoFinal'] as num).toDouble() : null,
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'estado': estado.toString().split('.').last,
      'fechaSolicitud': fechaSolicitud.toIso8601String(),
      'idRuta': idRuta,
      'idConductor': idConductor,
      'idPasajero': idPasajero,
      'costoFinal': costoFinal,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

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
}
