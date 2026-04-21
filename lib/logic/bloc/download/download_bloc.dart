import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ducanherp/logic/bloc/download/download_event.dart';
import 'package:ducanherp/logic/bloc/download/download_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc() : super(const DownloadInitial()) {
    on<StartDownload>(_onDownload);
  }

  Future<void> _onDownload(
    StartDownload event,
    Emitter<DownloadState> emit,
  ) async {
    emit(const DownloadInProgress(progress: 0));

    try {
      Directory dir;

      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final originalName = event.fileName;
      final extension =
          originalName.contains('.') ? '.${originalName.split('.').last}' : '';

      final shortName = originalName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');

      final uniqueName =
          '${DateTime.now().millisecondsSinceEpoch}_$shortName$extension';

      final String savePath = '${dir.path}/$uniqueName';

      final dio = Dio();

      await dio.download(
        event.url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            emit(DownloadInProgress(progress: received / total));
          }
        },
      );

      emit(DownloadSuccess(savePath));
    } catch (e) {
      emit(DownloadFailure(e.toString()));
    }
  }
}
