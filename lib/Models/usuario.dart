enum TipoUsuario { pasajero, conductor, ambos }

class Usuario {
  final String id;
  final String nombres;
  final String apellidos;
  final String correoInstitucional;
  final String numeroMatricula;
  final TipoUsuario tipoUsuario;

  Usuario({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.correoInstitucional,
    required this.numeroMatricula,
    required this.tipoUsuario,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json['id'],
    nombres: json['nombres'],
    apellidos: json['apellidos'],
    correoInstitucional: json['correo_institucional'],
    numeroMatricula: json['numero_matricula'],
    tipoUsuario: TipoUsuario.values.firstWhere(
      (e) => e.toString().split('.').last == json['tipo_usuario'],
      orElse: () => TipoUsuario.pasajero,
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombres': nombres,
    'apellidos': apellidos,
    'correo_institucional': correoInstitucional,
    'numero_matricula': numeroMatricula,
    'tipo_usuario': tipoUsuario.toString().split('.').last,
  };
}
