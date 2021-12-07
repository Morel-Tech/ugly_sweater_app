import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://navaaudglwywbbgmiqtz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzODg0NTQ5MSwiZXhwIjoxOTU0NDIxNDkxfQ.evhVTZa6yXKHxLlmIvMqd2EdHLGQAL5zF2xlG5gUMqY',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CameraPage(),
    );
  }
}
