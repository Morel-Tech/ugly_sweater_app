import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ugly_sweater_app/home/home.dart';
import 'package:ugly_sweater_app/login/login.dart';
import 'package:ugly_sweater_app/main/cubit/main_cubit.dart';

import '../../camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://navaaudglwywbbgmiqtz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzODg0NTQ5MSwiZXhwIjoxOTU0NDIxNDkxfQ.evhVTZa6yXKHxLlmIvMqd2EdHLGQAL5zF2xlG5gUMqY',
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          // if (state.session == null) {
          //   return const LoginPage();
          // }
          return const HomePage();
        },
      ),
    );
  }
}
