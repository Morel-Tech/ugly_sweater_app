// ignore_for_file: avoid_dynamic_calls

import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  Future<void> init() async {
    emit(state.copyWith(pictureStatus: LoadingStatus.loading));

    try {
      final response = await Supabase.instance.client
          .from('photos')
          .select('id,photohash')
          .execute();

      final pictures = <Picture>[];

      for (final photo in response.data) {
        final image = await Supabase.instance.client.storage
            .from('photos')
            .download('${photo['id']}.png');
        if (image.data != null) {
          final photoId = photo['id'].toString();
          pictures.add(
            Picture(
              id: photoId,
              image: image.data!,
            ),
          );
        }
      }

      emit(
        state.copyWith(
          pictures: pictures,
          pictureStatus: LoadingStatus.success,
          pictureError: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          pictureError: 'Failed to load the pictures.'
              ' Please try again later. Thanks!',
        ),
      );
    }
  }

  void onSwipe({
    required String rating,
    required String pictureId,
  }) {
    emit(
      state.copyWith(
          pictures: state.pictures..removeWhere((pic) => pic.id == pictureId)),
    );
    Supabase.instance.client.from('ratings').insert(
      {
        'photoId': pictureId,
        'userId': Supabase.instance.client.auth.currentUser!.id,
        'rating': rating,
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
