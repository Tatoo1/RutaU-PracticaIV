import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/usuario_provider.dart';
import '../../Config/rutas.dart';

class LoginAuth extends StatefulWidget {
  const LoginAuth({super.key});

  @override
  State<LoginAuth> createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {
  final _formKey = GlobalKey<FormState>();
  final _correoCtrl = TextEditingController();
  final _contrasenaCtrl = TextEditingController();
  bool _ocultar = true;

  @override
  void dispose() {
    _correoCtrl.dispose();
    _contrasenaCtrl.dispose();
    super.dispose();
  }

  String? _validarCorreo(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingrese su correo institucional';
    final re = RegExp(r'^[\w\.\-]+@ucentral\.edu\.co$', caseSensitive: false);
    if (!re.hasMatch(v.trim())) return 'Debe ser un correo @ucentral.edu.co';
    return null;
  }

  String? _validarContrasena(String? v) {
    if (v == null || v.isEmpty) return 'Ingrese su contraseña';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userProv = context.watch<UsuarioProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _correoCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo institucional',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: _validarCorreo,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contrasenaCtrl,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_ocultar ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _ocultar = !_ocultar),
                      ),
                    ),
                    obscureText: _ocultar,
                    validator: _validarContrasena,
                  ),
                  const SizedBox(height: 24),
                  userProv.cargando
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;

                            FocusScope.of(context).unfocus();

                            final exitoso = await userProv.iniciarSesion(
                              correo: _correoCtrl.text.trim(),
                              contrasena: _contrasenaCtrl.text,
                            );

                            if (exitoso) {
                              Navigator.pushReplacementNamed(context, AppRoutes.inicio);
                            } else {
                              final msg = userProv.error ?? 'Error desconocido';
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(msg)),
                              );
                            }
                          },
                          child: const Text('Ingresar'),
                        ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.registro),
                    child: const Text('Crear cuenta'),
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
