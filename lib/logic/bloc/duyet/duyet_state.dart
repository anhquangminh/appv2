import 'package:ducanherp/data/models/duyet_model.dart';
import 'package:equatable/equatable.dart';

abstract class StateDuyet extends Equatable {
  const StateDuyet();

  @override
  List<Object> get props => [];
}

class StateDuyetInitial extends StateDuyet {}

class StateDuyetLoading extends StateDuyet {}

// class StateDuyetSuccess extends StateDuyet {
//   final String message;
//   const StateDuyetSuccess(this.message);

//   @override
//   List<Object> get props => [message];
// }

class StateDuyetSuccess extends StateDuyet {
  final String message;
  final String id;
  final bool isApprove;

  const StateDuyetSuccess({
    required this.message,
    required this.id,
    required this.isApprove,
  });
}

class StateDuyetError extends StateDuyet {
  final String message;
  final DateTime errorTime;

  const StateDuyetError(this.message, {required this.errorTime});

  @override
  List<Object> get props => [message, errorTime];
}

class StateAwaitingApprovalTasksLoaded extends StateDuyet {
  final List<DuyetModel> tasks;
  final int totalCount;

  const StateAwaitingApprovalTasksLoaded({
    required this.tasks,
    required this.totalCount,
  });

  @override
  List<Object> get props => [tasks, totalCount];
}

class StateApprovalByUserIdTasksLoaded extends StateDuyet {
  final List<DuyetModel> tasks;
  final int totalCount;

  const StateApprovalByUserIdTasksLoaded({
    required this.tasks,
    required this.totalCount,
  });

  @override
  List<Object> get props => [tasks, totalCount];
}


class StateDuyetByVMLoaded extends StateDuyet {
  final List<DuyetModel> duyets;
  final String groupId;

  const StateDuyetByVMLoaded({required this.duyets, required this.groupId});

  @override
  List<Object> get props => [duyets, groupId];
}
class StateParentMajorsLoaded extends StateDuyet {
  final List<String> parentMajors;

  const StateParentMajorsLoaded({required this.parentMajors});

  @override
  List<Object> get props => [parentMajors];
}

class StateMajorsByParentLoaded extends StateDuyet {
  final List<String> majors;
  final String parentId;

  const StateMajorsByParentLoaded({
    required this.majors,
    required this.parentId,
  });

  @override
  List<Object> get props => [majors, parentId];
}