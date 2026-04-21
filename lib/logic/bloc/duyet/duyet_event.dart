import 'package:ducanherp/data/models/duyet_model.dart';
import 'package:equatable/equatable.dart';

abstract class EventDuyet extends Equatable {
  const EventDuyet();

  @override
  List<Object> get props => [];
}

class EventDuyetRequest extends EventDuyet {
  final String id;
  final String userName;

  const EventDuyetRequest({required this.id, required this.userName});

  @override
  List<Object> get props => [id, userName];
}

class EventHuyDuyetRequest extends EventDuyet {
  final String id;
  final String userName;

  const EventHuyDuyetRequest({required this.id, required this.userName});

  @override
  List<Object> get props => [id, userName];
}

class EventGetAwaitingApprovalTasks extends EventDuyet {
  final String groupId;
  final String userId;
  final int currentPage;
  final int pageSize;
  final String parentMajorId;
  final String majorId;

  const EventGetAwaitingApprovalTasks({
    required this.groupId,
    required this.userId,
    this.currentPage = 0,
    this.pageSize = 20,
    this.parentMajorId = "",
    this.majorId = "",
  });

  @override
  List<Object> get props => [groupId, userId, currentPage, pageSize, parentMajorId, majorId];
}

class EventGetApprovalByUserIdTasks extends EventDuyet {
  final String groupId;
  final String userId;
  final int currentPage;
  final int pageSize;
  final String parentMajorId;
  final String majorId;

  const EventGetApprovalByUserIdTasks({
    required this.groupId,
    required this.userId,
    this.currentPage = 0,
    this.pageSize = 20,
    this.parentMajorId = "",
    this.majorId = "",
  });

  @override
  List<Object> get props => [groupId, userId, currentPage, pageSize, parentMajorId, majorId];
}


class EventGetDuyetByVM extends EventDuyet {
  final String groupId;
  final DuyetModel filter;
  final int currentPage;
  final int pageSize;

  const EventGetDuyetByVM({
    required this.groupId,
    required this.filter,
    this.currentPage = 0, 
    this.pageSize = 20,
  });

  @override
  List<Object> get props => [groupId, filter, currentPage, pageSize];
}

class EventGetAllParentMajors extends EventDuyet {
  final String groupId;

  const EventGetAllParentMajors({
    required this.groupId,
  });

  @override
  List<Object> get props => [groupId];
}

class EventGetAllMajorByParentId extends EventDuyet {
  final String groupId;
  final String parentId;

  const EventGetAllMajorByParentId({
    required this.groupId,
    required this.parentId,
  });

  @override
  List<Object> get props => [groupId, parentId];
}