import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  Future<void> init() async {
    emit(state.copyWith(pictureStatus: LoadingStatus.loading));

    try {
      final response = await Supabase.instance.client
          .from('photos')
          .select('id,photohash')
          .execute();

      final pictureList = <Uint8List>[];
      final pictureIdList = <String>[];

      for (final photo in response.data) {
        final image = await Supabase.instance.client.storage
            .from('photos')
            .download('${photo['id']}.png');
        if (image.data != null) {
          final photoId = photo['id'].toString();
          pictureList.add(image.data!);
          pictureIdList.add(photoId);
        }
      }

      emit(
        state.copyWith(
          pictureList: pictureList,
          pictureIdList: pictureIdList,
          pictureStatus: LoadingStatus.success,
          pictureError: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
            pictureError: 'Failed to load the pictures.'
                ' Please try again later. Thanks!'),
      );
    }
  }

  Future<void> onSwipe({
    required String userId,
    required DismissDirection rating,
  }) async {
    final String direction;
    if (rating == DismissDirection.startToEnd) {
      direction = 'nice';
    } else {
      direction = 'naughty';
    }

    final response = await Supabase.instance.client.from('ratings').insert(
      {
        'photoId': state.pictureIdList[0],
        'userId': userId,
        'rating': direction,
      },
    ).execute();

    // emit(
    //   state.copyWith(
    //     pictureList: state.pictureList.removeAt(1),
    //     pictureIdList: state.pictureIdList.sublist(1),
    //     pictureStatus: LoadingStatus.success,
    //     pictureError: '',
    //   ),
    // );
  }
}
