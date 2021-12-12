import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ugly_sweater_app/home/view/view.dart';
import 'package:ugly_sweater_app/login/login.dart';
import 'package:ugly_sweater_app/main/cubit/main_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://navaaudglwywbbgmiqtz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzODg0NTQ5MSwiZXhwIjoxOTU0NDIxNDkxfQ.evhVTZa6yXKHxLlmIvMqd2EdHLGQAL5zF2xlG5gUMqY',
    authCallbackUrlHostname: 'login-callback',
    debug: true,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit()..init(),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFFBB2528)),
          ),
        ),
        colorScheme: const ColorScheme(
          primary: Color(0xFF165B33),
          primaryVariant: Color(0xFF146B3A),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFFBB2528),
          secondaryVariant: Color(0xFFEA4630),
          onSecondary: Color(0xFFFFFFFF),
          surface: Color(0xFF424242),
          onSurface: Color(0xFFFAFAFA),
          background: Color(0xFF000000),
          onBackground: Color(0xFFFFFFFF),
          error: Color(0xFFf44336),
          onError: Color(0xFF000000),
          brightness: Brightness.light,
        ),
      ),
      home: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          if (state.session == null) {
            return const LoginPage();
          }
          return const ExperimentalHomePage();
        },
      ),
    );
  }
}
