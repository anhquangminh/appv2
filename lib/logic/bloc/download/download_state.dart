abstract class DownloadState {
  const DownloadState();
}

class DownloadInitial extends DownloadState {
  const DownloadInitial();
}

class DownloadInProgress extends DownloadState {
  /// Tiến độ từ 0.0 đến 1.0
  final double progress;
  const DownloadInProgress({this.progress = 0.0});
}

class DownloadSuccess extends DownloadState {
  /// Đường dẫn tuyệt đối tới file đã lưu
  final String path;
  const DownloadSuccess(this.path);
}

class DownloadFailure extends DownloadState {
  /// Thông báo lỗi
  final String error;
  const DownloadFailure(this.error);
}
