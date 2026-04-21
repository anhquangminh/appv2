
import 'package:ducanherp/logic/bloc/notification/notification_reponsitory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

   NotificationBloc({required this.repository}) : super(NotificationInitial()) {
    // Xử lý sự kiện gửi thông báo
    on<SendNotificationEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final message = await repository.sendNotification(
          userIds: event.userIds,
          title: event.title,
          body: event.body,
        );
        emit(NotificationSuccess(message));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    // Xử lý sự kiện đăng ký token
    on<RegisterTokenEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final message = await repository.registerToken(
          token: event.token,
          groupId: event.groupId,
          userId: event.userId,
        );
        emit(NotificationSuccess(message));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    // Xử lý sự kiện hủy đăng ký token
    on<UnregisterTokenEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final message = await repository.unregisterToken(
          token: event.token,
          groupId: event.groupId,
          userId: event.userId,
        );
        emit(NotificationSuccess(message));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<UpdateNotificationEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        await repository.updateNotification(notifi: event.notifi);
        emit(NotificationSuccess("Cập nhật ok"));
        
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<GetAllNotiByUserEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final message = await repository.getAllNotiByUserId(
          event.currentPage,
          event.pageSize,
        );
        emit(GetAllNotiByUserSuccessSate(message));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<GetUnreadNotiByUserIdEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final countNotifi = await repository.getUnreadNotiByUserId();
        emit(GetUnreadNotiByUserIdSuccessSate(countNotifi));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
    //fire base
    on<GetAllNotiFireBaseByUserIdEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final message = await repository.getAllNotiFireBaseByUserId(
          event.currentPage,
          event.pageSize,
        );
        emit(
          GetAllNotiFireBaseByUserIdSuccessSate(
            message
          ),
        );
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<GetReadFireBaseIdEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final countNotifi = await repository.getUnreadNotiFireBaseByUserId();
        emit(GetReadFireBaseIdSuccessSate(countNotifi));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<IsReadFireBaseIdEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        await repository.isReadFireBaseId(
          id:event.id,
        );
        emit(UpdateFireBaseSuccesState());
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
  }
}
