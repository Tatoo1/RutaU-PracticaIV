class Ruta {
  final String id;
  final String idConductor;
  final String idVehiculo;
  final PuntoGeografico puntoOrigen;
  final PuntoGeografico puntoDestino;
  final List<PuntoGeografico>? puntosIntermedios;
  final DateTime fechaHoraSalida;
  final int plazasDisponibles;
  final double? costoEstimado;
  final String? descripcionAdicional;
  final bool esRutaRecurrente;
  final List<DiaSemana>? diasRecurrencia; // Solo si es recurrente
  final EstadoRuta estado;
  final DateTime fechaCreacion;

  Ruta({
    required this.id,
    required this.idConductor,
    required this.idVehiculo,
    required this.puntoOrigen,
    required this.puntoDestino,
    this.puntosIntermedios,
    required this.fechaHoraSalida,
    required this.plazasDisponibles,
    this.costoEstimado,
    this.descripcionAdicional,
    this.esRutaRecurrente = false,
    this.diasRecurrencia,
    this.estado = EstadoRuta.activa,
    required this.fechaCreacion,
  });

  factory Ruta.fromJson(Map<String, dynamic> json) {
    return Ruta(
      id: json['id'] ?? '',
      idConductor: json['id_conductor'] ?? '',
      idVehiculo: json['id_vehiculo'] ?? '',
      puntoOrigen: PuntoGeografico.fromJson(json['punto_origen']),
      puntoDestino: PuntoGeografico.fromJson(json['punto_destino']),
      puntosIntermedios: json['puntos_intermedios'] != null
          ? (json['puntos_intermedios'] as List)
              .map((punto) => PuntoGeografico.fromJson(punto))
              .toList()
          : null,
      fechaHoraSalida: DateTime.parse(json['fecha_hora_salida']),
      plazasDisponibles: json['plazas_disponibles'] ?? 1,
      costoEstimado: json['costo_estimado']?.toDouble(),
      descripcionAdicional: json['descripcion_adicional'],
      esRutaRecurrente: json['es_ruta_recurrente'] ?? false,
      diasRecurrencia: json['dias_recurrencia'] != null
          ? (json['dias_recurrencia'] as List)
              .map((dia) => DiaSemana.values.firstWhere(
                    (d) => d.toString().split('.').last == dia,
                  ))
              .toList()
          : null,
      estado: EstadoRuta.values.firstWhere(
        (estado) => estado.toString().split('.').last == json['estado'],
        orElse: () => EstadoRuta.activa,
      ),
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_conductor': idConductor,
      'id_vehiculo': idVehiculo,
      'punto_origen': puntoOrigen.toJson(),
      'punto_destino': puntoDestino.toJson(),
      'puntos_intermedios': puntosIntermedios?.map((p) => p.toJson()).toList(),
      'fecha_hora_salida': fechaHoraSalida.toIso8601String(),
      'plazas_disponibles': plazasDisponibles,
      'costo_estimado': costoEstimado,
      'descripcion_adicional': descripcionAdicional,
      'es_ruta_recurrente': esRutaRecurrente,
      'dias_recurrencia': diasRecurrencia?.map((d) => d.toString().split('.').last).toList(),
      'estado': estado.toString().split('.').last,
      'fecha_creacion': fechaCreacion.toIso8601String(),
    };
  }
}

// Clase para representar puntos geográficos
class PuntoGeografico {
  final double latitud;
  final double longitud;
  final String? direccion;
  final String? nombreLugar;

  PuntoGeografico({
    required this.latitud,
    required this.longitud,
    this.direccion,
    this.nombreLugar,
  });

  factory PuntoGeografico.fromJson(Map<String, dynamic> json) {
    return PuntoGeografico(
      latitud: json['latitud']?.toDouble() ?? 0.0,
      longitud: json['longitud']?.toDouble() ?? 0.0,
      direccion: json['direccion'],
      nombreLugar: json['nombre_lugar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitud': latitud,
      'longitud': longitud,
      'direccion': direccion,
      'nombre_lugar': nombreLugar,
    };
  }
}

// Enums para la ruta
enum EstadoRuta {
  activa,
  inactiva,
  completada,
  cancelada,
}

enum DiaSemana {
  lunes,
  martes,
  miercoles,
  jueves,
  viernes,
  sabado,
  domingo,
}
