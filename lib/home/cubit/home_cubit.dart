import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  Future<void> init() async {
    final response = await Supabase.instance.client
        .from('photos')
        .select('id,photohash')
        .execute();

    final pictureList = <Uint8List>[];
    final pictureIdList = <String>[];

    for (final photo in response.data) {
      final image = await Supabase.instance.client.storage
          .from('photos')
          .download('84d2c909-216c-401d-b35f-985b9b2ba17f.png');
      if (image.data != null) {
        pictureList.add(image.data!);
      }
    }

    emit(
      state.copyWith(
        pictureList: pictureList,
      ),
    );
  }

  Future<void> onSwipe(String userId, String rating) async {
    final response = Supabase.instance.client.from('ratings').insert(
      {
        'user_id': userId,
        'rating': rating,
      },
    );
  }
}
