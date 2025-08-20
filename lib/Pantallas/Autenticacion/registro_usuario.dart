import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/usuario_provider.dart';
import '../../Models/usuario.dart';
import '../../Config/rutas.dart';

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _matriculaCtrl = TextEditingController();
  final _claveCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();

  TipoUsuario _tipo = TipoUsuario.pasajero;
  bool _ocultarClave = true;
  bool _ocultarConfirmar = true;

  @override
  void dispose() {
    _nombresCtrl.dispose();
    _apellidosCtrl.dispose();
    _correoCtrl.dispose();
    _matriculaCtrl.dispose();
    _claveCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  String? _validaRequerido(String? v, String campo) {
    if (v == null || v.trim().isEmpty) return 'Ingrese $campo';
    return null;
  }

  String? _validaCorreo(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingrese correo institucional';
    final re = RegExp(r'^[\w\.\-]+@ucentral\.edu\.co$', caseSensitive: false);
    if (!re.hasMatch(v.trim())) return 'Debe ser un correo @ucentral.edu.co';
    return null;
  }

  String? _validaContrasena(String? v) {
    if (v == null || v.length < 6) return 'Contraseña min. 6 caracteres';
    return null;
  }

  String? _validaConfirmacion(String? v) {
    if (v != _claveCtrl.text) return 'Las contraseñas no coinciden';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userProv = context.watch<UsuarioProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nombresCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombres',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => _validaRequerido(v, 'nombres'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _apellidosCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Apellidos',
                      prefixIcon: Icon(Icons.person_2_outlined),
                    ),
                    validator: (v) => _validaRequerido(v, 'apellidos'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _correoCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo institucional',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: _validaCorreo,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _matriculaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Número de matrícula',
                      prefixIcon: Icon(Icons.confirmation_number_outlined),
                    ),
                    validator: (v) => _validaRequerido(v, 'número de matrícula'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<TipoUsuario>(
                    value: _tipo,
                    items: TipoUsuario.values.map((t) {
                      final nombre = t.name; // Con Flutter 2.17+
                      return DropdownMenuItem(value: t, child: Text(nombre));
                    }).toList(),
                    onChanged: (v) => setState(() => _tipo = v ?? TipoUsuario.pasajero),
                    decoration: const InputDecoration(
                      labelText: 'Tipo de usuario',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _claveCtrl,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_ocultarClave ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _ocultarClave = !_ocultarClave),
                      ),
                    ),
                    obscureText: _ocultarClave,
                    validator: _validaContrasena,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmarCtrl,
                    decoration: InputDecoration(
                      labelText: 'Confirmar contraseña',
                      prefixIcon: const Icon(Icons.lock_person_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(_ocultarConfirmar ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _ocultarConfirmar = !_ocultarConfirmar),
                      ),
                    ),
                    obscureText: _ocultarConfirmar,
                    validator: _validaConfirmacion,
                  ),
                  const SizedBox(height: 20),
                  userProv.cargando
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;
                            FocusScope.of(context).unfocus();

                            final ok = await userProv.registrarUsuario(
                              nombres: _nombresCtrl.text.trim(),
                              apellidos: _apellidosCtrl.text.trim(),
                              correoInstitucional: _correoCtrl.text.trim(),
                              numeroMatricula: _matriculaCtrl.text.trim(),
                              contrasena: _claveCtrl.text,
                              tipoUsuario: _tipo,
                            );

                            if (ok) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, AppRoutes.inicio, (route) => false);
                            } else {
                              final msg = userProv.error ?? 'No se pudo crear la cuenta';
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(msg)));
                            }
                          },
                          child: const Text('Crear cuenta'),
                        ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ya tengo cuenta, iniciar sesión'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
