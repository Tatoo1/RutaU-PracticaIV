import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Config/rutas.dart';
import 'Config/theme.dart';
import 'providers/usuario_provider.dart';
import 'providers/ruta_provider.dart';
import 'providers/viaje_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp();
  
  runApp(RutaUApp());
}

class RutaUApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       // ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        //ChangeNotifierProvider(create: (_) => RutaProvider()),
        // ChangeNotifierProvider(create: (_) => ViajeProvider()),
      ],
      child: MaterialApp(
        title: 'Ruta U',
        theme: AppTheme.temaClaro,
        darkTheme: AppTheme.temaOscuro,
        initialRoute: '/login',
        routes: AppRoutes.rutas,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
