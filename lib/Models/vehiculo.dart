class Vehiculo {
  final String id;
  final String idConductor;
  final String marca;
  final String modelo;
  final String placa;
  final String color;
  final int anio;
  final int capacidadPasajeros;
  final String? fotoVehiculo;
  final bool tieneAireAcondicionado;
  final bool permiteMascotas;
  final bool permiteFumar;
  final bool estaActivo;
  final DateTime fechaRegistro;

  Vehiculo({
    required this.id,
    required this.idConductor,
    required this.marca,
    required this.modelo,
    required this.placa,
    required this.color,
    required this.anio,
    required this.capacidadPasajeros,
    this.fotoVehiculo,
    this.tieneAireAcondicionado = false,
    this.permiteMascotas = false,
    this.permiteFumar = false,
    this.estaActivo = true,
    required this.fechaRegistro,
  });

  factory Vehiculo.fromJson(Map<String, dynamic> json) {
    return Vehiculo(
      id: json['id'] ?? '',
      idConductor: json['id_conductor'] ?? '',
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      placa: json['placa'] ?? '',
      color: json['color'] ?? '',
      anio: json['anio'] ?? 0,
      capacidadPasajeros: json['capacidad_pasajeros'] ?? 1,
      fotoVehiculo: json['foto_vehiculo'],
      tieneAireAcondicionado: json['tiene_aire_acondicionado'] ?? false,
      permiteMascotas: json['permite_mascotas'] ?? false,
      permiteFumar: json['permite_fumar'] ?? false,
      estaActivo: json['esta_activo'] ?? true,
      fechaRegistro: DateTime.parse(json['fecha_registro']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_conductor': idConductor,
      'marca': marca,
      'modelo': modelo,
      'placa': placa,
      'color': color,
      'anio': anio,
      'capacidad_pasajeros': capacidadPasajeros,
      'foto_vehiculo': fotoVehiculo,
      'tiene_aire_acondicionado': tieneAireAcondicionado,
      'permite_mascotas': permiteMascotas,
      'permite_fumar': permiteFumar,
      'esta_activo': estaActivo,
      'fecha_registro': fechaRegistro.toIso8601String(),
    };
  }

  // Descripción completa del vehículo
  String get descripcionCompleta => '$marca $modelo $anio - $placa';
}
