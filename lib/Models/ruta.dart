import 'viaje.dart'; // si necesitas importar enums

enum EstadoRuta {
  activa,
  cancelada,
  finalizada,
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


class Ruta {
  final String id;
  final EstadoRuta estado;
  // Si tu modelo usa días de recurrencia:
  final List<DiaSemana>? diasRecurrencia;

  Ruta({
    required this.id,
    required this.estado,
    this.diasRecurrencia,
  });

  Ruta copyWith({
    String? id,
    EstadoRuta? estado,
    List<DiaSemana>? diasRecurrencia,
  }) {
    return Ruta(
      id: id ?? this.id,
      estado: estado ?? this.estado,
      diasRecurrencia: diasRecurrencia ?? this.diasRecurrencia,
    );
  }

  factory Ruta.fromJson(Map<String, dynamic> json) {
    return Ruta(
      id: json['id'] ?? '',
      estado: _estadoDesdeString(json['estado'] ?? 'activa'),
      diasRecurrencia: json['diasRecurrencia'] != null
          ? List<String>.from(json['diasRecurrencia'])
              .map((dia) => DiaSemana.values.firstWhere(
                  (e) => e.toString().split('.').last == dia))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'estado': estado.toString().split('.').last,
      'diasRecurrencia': diasRecurrencia
          ?.map((e) => e.toString().split('.').last)
          .toList(),
    };
  }

  static EstadoRuta _estadoDesdeString(String estadoStr) {
    switch (estadoStr.toLowerCase()) {
      case 'activa':
        return EstadoRuta.activa;
      case 'cancelada':
        return EstadoRuta.cancelada;
      case 'finalizada':
        return EstadoRuta.finalizada;
      default:
        return EstadoRuta.activa;
    }
  }
}
