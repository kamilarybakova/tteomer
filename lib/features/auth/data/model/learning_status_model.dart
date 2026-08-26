enum StudentLearningState {
  active,
  pendingApproval,
  rejected,
  cohortEnded,
  noActiveCohort,
  noGroup,
  unknown,
}

class LearningGroupModel {
  final int id;
  final String name;
  final String level;
  final String teacher;
  final String lessonTime;
  final String note;

  const LearningGroupModel({
    required this.id,
    required this.name,
    required this.level,
    required this.teacher,
    required this.lessonTime,
    required this.note,
  });

  factory LearningGroupModel.fromJson(Map<String, dynamic> json) {
    return LearningGroupModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      level: json['level'] as String? ?? '',
      teacher: json['teacher'] as String? ?? '',
      lessonTime: json['lesson_time'] as String? ?? '',
      note: json['note'] as String? ?? '',
    );
  }
}

class LearningStatusModel {
  final bool success;
  final StudentLearningState state;
  final LearningGroupModel? group;

  const LearningStatusModel({
    required this.success,
    required this.state,
    required this.group,
  });

  bool get isActive => state == StudentLearningState.active;

  factory LearningStatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? const {};
    final groupJson = data['group'] as Map<String, dynamic>?;

    return LearningStatusModel(
      success: json['success'] as bool? ?? false,
      state: _parseState(data['state'] as String?),
      group: groupJson == null ? null : LearningGroupModel.fromJson(groupJson),
    );
  }

  static StudentLearningState _parseState(String? value) {
    switch (value?.trim().toUpperCase()) {
      case 'ACTIVE':
        return StudentLearningState.active;
      case 'PENDING_APPROVAL':
        return StudentLearningState.pendingApproval;
      case 'REJECTED':
        return StudentLearningState.rejected;
      case 'COHORT_ENDED':
        return StudentLearningState.cohortEnded;
      case 'NO_ACTIVE_COHORT':
        return StudentLearningState.noActiveCohort;
      case 'NO_GROUP':
        return StudentLearningState.noGroup;
      default:
        return StudentLearningState.unknown;
    }
  }
}
