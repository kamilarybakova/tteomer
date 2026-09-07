import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tteomer/core/utils/app_config.dart';
import 'package:tteomer/core/widgets/app_toast.dart';
import 'package:tteomer/features/documents/data/model/teacher_document_model.dart';
import 'package:tteomer/features/documents/presentation/pages/document_webview_page.dart';
import 'package:tteomer/features/documents/presentation/pages/teacher_documents_screen.dart';
import 'package:tteomer/features/documents/presentation/provider/teacher_documents_provider.dart';
import 'package:tteomer/features/teacher/data/models/group_student_model.dart';
import 'package:tteomer/features/teacher/data/models/teacher_homework_model.dart';
import 'package:tteomer/features/teacher/data/models/pending_student_model.dart';
import 'package:tteomer/features/teacher/data/models/teacher_group_model.dart';
import 'package:tteomer/features/teacher/presentation/providers/teacher_homework_provider.dart';
import 'package:tteomer/features/teacher/presentation/providers/teacher_providers.dart';
import 'package:tteomer/features/teacher/presentation/widgets/add_homework_sheet.dart';
import 'package:tteomer/l10n/app_localizations.dart';

class PendingStudentsScreen extends ConsumerStatefulWidget {
  final TeacherGroupModel group;

  const PendingStudentsScreen({super.key, required this.group});

  @override
  ConsumerState<PendingStudentsScreen> createState() =>
      _PendingStudentsScreenState();
}

class _PendingStudentsScreenState extends ConsumerState<PendingStudentsScreen> {
  final Set<int> _processingStudents = <int>{};

  Future<void> _editHomework(
    TeacherHomeworkModel homework,
    List<GroupStudentModel> students,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddHomeworkSheet(
        groupId: widget.group.id,
        groupName: widget.group.name,
        students: students,
        initialHomework: homework,
      ),
    );

    ref.invalidate(teacherHomeworkProvider);
  }

  Future<void> _deleteHomework(TeacherHomeworkModel homework) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteHomeworkTitle),
        content: Text(l10n.deleteHomeworkMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) return;

    try {
      await ref
          .read(teacherHomeworkRemoteDataSourceProvider)
          .deleteTeacherHomework(homework.id);
      ref.invalidate(teacherHomeworkProvider);
      if (mounted) {
        AppToast.show(context, l10n.homeworkDeletedSuccess);
      }
    } catch (error) {
      if (mounted) {
        AppToast.show(context, _extractError(error));
      }
    }
  }

  Future<void> _editDocument(TeacherDocumentModel document) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTeacherDocumentSheet(
        initialGroupId: widget.group.id,
        initialGroupName: widget.group.name,
        initialDocument: document,
      ),
    );

    ref.invalidate(teacherDocumentsProvider);
  }

  Future<void> _deleteDocument(TeacherDocumentModel document) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteMaterialTitle),
        content: Text(l10n.deleteMaterialMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) return;

    try {
      await ref
          .read(teacherDocumentsRemoteDataSourceProvider)
          .deleteTeacherDocument(document.id);
      ref.invalidate(teacherDocumentsProvider);
      if (mounted) {
        AppToast.show(context, l10n.materialDeletedSuccess);
      }
    } catch (error) {
      if (mounted) {
        AppToast.show(context, _extractError(error));
      }
    }
  }

  Future<void> _handleDecision({
    required PendingStudentModel student,
    required bool approve,
  }) async {
    if (_processingStudents.contains(student.studentId)) return;

    setState(() => _processingStudents.add(student.studentId));

    try {
      final datasource = ref.read(teacherRemoteDataSourceProvider);
      if (approve) {
        await datasource.approveStudent(
          groupId: widget.group.id,
          studentId: student.studentId,
        );
        if (mounted) {
          AppToast.show(context, AppLocalizations.of(context)!.studentApproved);
        }
      } else {
        await datasource.rejectStudent(
          groupId: widget.group.id,
          studentId: student.studentId,
        );
        if (mounted) {
          AppToast.show(context, AppLocalizations.of(context)!.studentRejected);
        }
      }

      ref.invalidate(teacherPendingStudentsProvider(widget.group.id));
      ref.invalidate(teacherGroupStudentsProvider(widget.group.id));
      ref.invalidate(teacherGroupsProvider);
    } catch (error) {
      if (mounted) {
        AppToast.show(context, _extractError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _processingStudents.remove(student.studentId));
      }
    }
  }

  String _extractError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      final errors = data?['errors'];
      if (errors is Map && errors['detail'] != null) {
        return errors['detail'].toString();
      }
      if (data is Map && data['detail'] != null) {
        return data['detail'].toString();
      }
    }

    return error.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pendingAsync = ref.watch(
      teacherPendingStudentsProvider(widget.group.id),
    );
    final activeAsync = ref.watch(
      teacherGroupStudentsProvider(widget.group.id),
    );
    final activeStudents = activeAsync.valueOrNull ?? const <GroupStudentModel>[];
    final documentsAsync = ref.watch(teacherDocumentsProvider);
    final homeworkAsync = ref.watch(teacherHomeworkProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        title: Text(
          widget.group.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(teacherPendingStudentsProvider(widget.group.id));
          ref.invalidate(teacherGroupStudentsProvider(widget.group.id));
          ref.invalidate(teacherGroupsProvider);
          await Future.wait([
            ref.read(teacherPendingStudentsProvider(widget.group.id).future),
            ref.read(teacherGroupStudentsProvider(widget.group.id).future),
            ref.read(teacherDocumentsProvider.future),
            ref.read(teacherHomeworkProvider.future),
          ]);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.group.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _GroupMetaChip(
                        icon: Icons.school_outlined,
                        label: widget.group.level,
                      ),
                      _GroupMetaChip(
                        icon: Icons.people_alt_outlined,
                        label: l10n.groupStudentsCount(
                          widget.group.currentStudents,
                          widget.group.maxStudents,
                        ),
                      ),
                      _GroupMetaChip(
                        icon: Icons.schedule_rounded,
                        label: widget.group.lessonTime.isEmpty
                            ? l10n.groupTimeUnknown
                            : widget.group.lessonTime,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            pendingAsync.when(
              loading: () => const _SectionLoader(),
              error: (error, _) => _SectionError(message: error.toString()),
              data: (pendingStudents) {
                if (pendingStudents.isEmpty) {
                  return const SizedBox.shrink();
                }

                return _SectionCard(
                  title: l10n.pendingStudentsTitle,
                  child: Column(
                    children: [
                      for (var i = 0; i < pendingStudents.length; i++) ...[
                        _PendingStudentCard(
                          student: pendingStudents[i],
                          isProcessing: _processingStudents.contains(
                            pendingStudents[i].studentId,
                          ),
                          onApprove: () => _handleDecision(
                            student: pendingStudents[i],
                            approve: true,
                          ),
                          onReject: () => _handleDecision(
                            student: pendingStudents[i],
                            approve: false,
                          ),
                        ),
                        if (i != pendingStudents.length - 1)
                          const SizedBox(height: 12),
                      ],
                    ],
                  ),
                );
              },
            ),
            if (pendingAsync.valueOrNull?.isNotEmpty == true)
              const SizedBox(height: 18),
            activeAsync.when(
              loading: () => const _SectionLoader(),
              error: (error, _) => _SectionError(message: error.toString()),
              data: (students) {
                return _SectionCard(
                  title: l10n.groupStudentsSectionTitle,
                  child: students.isEmpty
                      ? _SectionEmpty(
                          title: l10n.noGroupStudentsTitle,
                          subtitle: l10n.noGroupStudentsSubtitle,
                        )
                      : Column(
                          children: [
                            for (var i = 0; i < students.length; i++) ...[
                              _GroupStudentCard(student: students[i]),
                              if (i != students.length - 1)
                                const SizedBox(height: 12),
                            ],
                          ],
                        ),
                );
              },
            ),
            const SizedBox(height: 18),
            homeworkAsync.when(
              loading: () => const _SectionLoader(),
              error: (error, _) => _SectionError(message: error.toString()),
              data: (homework) {
                final groupHomework = homework
                    .where((item) => item.groupId == widget.group.id)
                    .toList()
                  ..sort((a, b) {
                    final left = a.dueDate ?? DateTime.fromMillisecondsSinceEpoch(0);
                    final right =
                        b.dueDate ?? DateTime.fromMillisecondsSinceEpoch(0);
                    return right.compareTo(left);
                  });

                return _SectionCard(
                  title: l10n.groupHomeworkTitle,
                  headerAction: TextButton.icon(
                    onPressed: () async {
                      await showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => AddHomeworkSheet(
                          groupId: widget.group.id,
                          groupName: widget.group.name,
                          students: activeStudents,
                        ),
                      );
                      ref.invalidate(teacherHomeworkProvider);
                    },
                    icon: const Icon(Icons.assignment_outlined),
                    label: Text(l10n.addHomeworkButton),
                  ),
                  child: groupHomework.isEmpty
                      ? _SectionEmpty(
                          title: l10n.noGroupHomeworkTitle,
                          subtitle: l10n.noGroupHomeworkSubtitle,
                        )
                      : Column(
                          children: [
                            for (var i = 0; i < groupHomework.length; i++) ...[
                              _GroupHomeworkCard(
                                homework: groupHomework[i],
                                onEdit: () => _editHomework(
                                  groupHomework[i],
                                  activeStudents,
                                ),
                                onDelete: () => _deleteHomework(
                                  groupHomework[i],
                                ),
                              ),
                              if (i != groupHomework.length - 1)
                                const SizedBox(height: 12),
                            ],
                          ],
                        ),
                );
              },
            ),
            const SizedBox(height: 18),
            documentsAsync.when(
              loading: () => const _SectionLoader(),
              error: (error, _) => _SectionError(message: error.toString()),
              data: (documents) {
                final groupDocuments = documents
                    .where((document) => document.groupId == widget.group.id)
                    .toList();

                return _SectionCard(
                  title: l10n.groupMaterialsTitle,
                  headerAction: TextButton.icon(
                    onPressed: () async {
                      await showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => AddTeacherDocumentSheet(
                          initialGroupId: widget.group.id,
                          initialGroupName: widget.group.name,
                        ),
                      );
                      ref.invalidate(teacherDocumentsProvider);
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.addMaterialButton),
                  ),
                  child: groupDocuments.isEmpty
                      ? _SectionEmpty(
                          title: l10n.noGroupMaterialsTitle,
                          subtitle: l10n.noGroupMaterialsSubtitle,
                        )
                      : Column(
                          children: [
                            for (var i = 0; i < groupDocuments.length; i++) ...[
                              _GroupDocumentCard(
                                document: groupDocuments[i],
                                onEdit: () => _editDocument(groupDocuments[i]),
                                onDelete: () =>
                                    _deleteDocument(groupDocuments[i]),
                              ),
                              if (i != groupDocuments.length - 1)
                                const SizedBox(height: 12),
                            ],
                          ],
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget? headerAction;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
    this.headerAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ?headerAction,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SectionLoader extends StatelessWidget {
  const _SectionLoader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _SectionError extends StatelessWidget {
  final String message;

  const _SectionError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xFF6B7280)),
      ),
    );
  }
}

class _SectionEmpty extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionEmpty({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          const Icon(
            Icons.people_outline_rounded,
            size: 44,
            color: Color(0xFF4C63D2),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupMetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _GroupMetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF4C63D2).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF4C63D2)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF171923),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingStudentCard extends StatelessWidget {
  final PendingStudentModel student;
  final bool isProcessing;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _PendingStudentCard({
    required this.student,
    required this.isProcessing,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FD),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StudentAvatar(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName.isEmpty ? student.email : student.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF171923),
                  ),
                ),
                if (student.fullName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    student.email,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  '${l10n.requestedAtLabel}: ${_formatRequestedAt(student.requestedAt)}',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              _DecisionButton(
                icon: Icons.check_rounded,
                color: const Color(0xFF12B76A),
                onTap: isProcessing ? null : onApprove,
                tooltip: l10n.approveStudent,
              ),
              const SizedBox(height: 10),
              _DecisionButton(
                icon: Icons.close_rounded,
                color: const Color(0xFFEF4444),
                onTap: isProcessing ? null : onReject,
                tooltip: l10n.rejectStudent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GroupStudentCard extends StatelessWidget {
  final GroupStudentModel student;

  const _GroupStudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FD),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const _StudentAvatar(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName.isEmpty ? student.email : student.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF171923),
                  ),
                ),
                if (student.fullName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    student.email,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (student.level.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF4C63D2).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                student.level,
                style: const TextStyle(
                  color: Color(0xFF4C63D2),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GroupDocumentCard extends StatelessWidget {
  final TeacherDocumentModel document;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GroupDocumentCard({
    required this.document,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: document.file.isEmpty
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DocumentWebViewPage(
                    url: document.file,
                    title: document.title,
                  ),
                ),
              );
            },
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FD),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF4C63D2).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: Color(0xFF4C63D2),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF171923),
                    ),
                  ),
                  if (document.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      document.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    document.isVisibleToStudents
                        ? l10n.visibleToStudentsLabel
                        : l10n.hiddenFromStudentsLabel,
                    style: TextStyle(
                      color: document.isVisibleToStudents
                          ? const Color(0xFF12B76A)
                          : const Color(0xFFEF4444),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                _DecisionButton(
                  icon: Icons.edit_outlined,
                  color: const Color(0xFF4C63D2),
                  onTap: onEdit,
                  tooltip: l10n.editMaterialButton,
                ),
                const SizedBox(height: 8),
                _DecisionButton(
                  icon: Icons.delete_outline_rounded,
                  color: const Color(0xFFEF4444),
                  onTap: onDelete,
                  tooltip: l10n.delete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupHomeworkCard extends StatelessWidget {
  final TeacherHomeworkModel homework;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GroupHomeworkCard({
    required this.homework,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canOpenFile = homework.file != null && homework.file!.isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: !canOpenFile
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DocumentWebViewPage(
                    url: _resolveFileUrl(homework.file!),
                    title: homework.title,
                  ),
                ),
              );
            },
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FD),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF4C63D2).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                color: Color(0xFF4C63D2),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    homework.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF171923),
                    ),
                  ),
                  if (homework.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      homework.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _HomeworkChip(
                        icon: Icons.schedule_rounded,
                        label: homework.dueDate == null
                            ? '-'
                            : DateFormat(
                                'dd.MM.yyyy HH:mm',
                              ).format(homework.dueDate!.toLocal()),
                      ),
                      _HomeworkChip(
                        icon: homework.isIndividual
                            ? Icons.person_outline_rounded
                            : Icons.groups_rounded,
                        label: homework.isIndividual
                            ? l10n.homeworkForStudentsLabel(
                                homework.assignedStudentIds.length,
                              )
                            : l10n.homeworkForGroupLabel,
                      ),
                      if (canOpenFile)
                        _HomeworkChip(
                          icon: Icons.attach_file_rounded,
                          label: homework.fileSizeMb != null
                              ? '${homework.fileSizeMb} MB'
                              : l10n.materialFileLabel,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                _DecisionButton(
                  icon: Icons.edit_outlined,
                  color: const Color(0xFF4C63D2),
                  onTap: onEdit,
                  tooltip: l10n.editHomeworkButton,
                ),
                const SizedBox(height: 8),
                _DecisionButton(
                  icon: Icons.delete_outline_rounded,
                  color: const Color(0xFFEF4444),
                  onTap: onDelete,
                  tooltip: l10n.delete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeworkChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HomeworkChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF4C63D2).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF4C63D2)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF171923),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentAvatar extends StatelessWidget {
  const _StudentAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF4C63D2).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.person_outline, color: Color(0xFF4C63D2)),
    );
  }
}

class _DecisionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final String tooltip;

  const _DecisionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: onTap == null ? 0.08 : 0.14),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color),
        ),
      ),
    );
  }
}

String _formatRequestedAt(String raw) {
  if (raw.isEmpty) return raw;

  try {
    final date = DateTime.parse(raw).toLocal();
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  } catch (_) {
    return raw;
  }
}

String _resolveFileUrl(String file) {
  if (file.startsWith('http://') || file.startsWith('https://')) {
    return file;
  }

  return '${AppConfig.apiBaseUrl}$file';
}
