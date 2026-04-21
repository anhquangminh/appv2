import 'dart:async';
import 'dart:io';

Never handleNetworkException(Object e) {
  if (e is TimeoutException) {
    throw Exception('Kết nối tới máy chủ quá lâu. Vui lòng kiểm tra mạng và thử lại.');
  } else if (e is SocketException) {
    throw Exception('Không thể kết nối mạng. Vui lòng kiểm tra kết nối Internet.');
  } 
  throw Exception(e);
}