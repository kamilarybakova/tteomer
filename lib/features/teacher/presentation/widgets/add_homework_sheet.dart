import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tteomer/core/widgets/app_toast.dart';
import 'package:tteomer/features/teacher/data/models/group_student_model.dart';
import 'package:tteomer/features/teacher/data/models/teacher_homework_model.dart';
import 'package:tteomer/features/teacher/presentation/providers/teacher_homework_provider.dart';
import 'package:tteomer/l10n/app_localizations.dart';

class AddHomeworkSheet extends ConsumerStatefulWidget {
  final int groupId;
  final String groupName;
  final List<GroupStudentModel> students;
  final TeacherHomeworkModel? initialHomework;

  const AddHomeworkSheet({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.students,
    this.initialHomework,
  });

  @override
  ConsumerState<AddHomeworkSheet> createState() => _AddHomeworkSheetState();
}

class _AddHomeworkSheetState extends ConsumerState<AddHomeworkSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<int> _selectedStudentIds = <int>{};

  String? _selectedFilePath;
  String? _selectedFileName;
  String _targetType = 'GROUP';
  bool _isActive = true;
  bool _isSubmitting = false;
  late DateTime _dueDate;

  bool get _isIndividual => _targetType == 'INDIVIDUAL';
  bool get _isEditing => widget.initialHomework != null;

  @override
  void initState() {
    super.initState();
    final initialHomework = widget.initialHomework;
    if (initialHomework != null) {
      _titleController.text = initialHomework.title;
      _descriptionController.text = initialHomework.description;
      _selectedFileName = initialHomework.file?.split('/').last;
      _targetType = initialHomework.targetType.toUpperCase();
      _isActive = initialHomework.isActive;
      _selectedStudentIds.addAll(initialHomework.assignedStudentIds);
      _dueDate = initialHomework.dueDate?.toLocal() ?? DateTime.now();
      return;
    }

    final now = DateTime.now();
    _dueDate = DateTime(now.year, now.month, now.day + 1, 18);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(withData: false);
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.path == null) return;

    setState(() {
      _selectedFilePath = file.path;
      _selectedFileName = file.name;
    });
  }

  Future<void> _pickDueDate() async {
    final today = DateTime.now();
    final firstDate = DateTime(today.year, today.month, today.day);
    final initialDate = _dueDate.isBefore(firstDate) ? firstDate : _dueDate;
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate),
    );
    if (time == null) return;

    setState(() {
      _dueDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;
    if (_isIndividual && _selectedStudentIds.isEmpty) {
      AppToast.show(context, l10n.homeworkStudentsValidation);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final datasource = ref.read(teacherHomeworkRemoteDataSourceProvider);
      final selectedStudentIds = _isIndividual
          ? _selectedStudentIds.toList()
          : const <int>[];

      if (_isEditing) {
        await datasource.updateTeacherHomework(
          homeworkId: widget.initialHomework!.id,
          groupId: widget.groupId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          filePath: _selectedFilePath,
          dueDate: _dueDate,
          targetType: _targetType,
          assignedStudentIds: selectedStudentIds,
          isActive: _isActive,
        );
      } else {
        await datasource.createTeacherHomework(
          groupId: widget.groupId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          filePath: _selectedFilePath,
          dueDate: _dueDate,
          targetType: _targetType,
          assignedStudentIds: selectedStudentIds,
          isActive: _isActive,
        );
      }

      ref.invalidate(teacherHomeworkProvider);

      if (mounted) {
        AppToast.show(
          context,
          _isEditing
              ? l10n.homeworkUpdatedSuccess
              : l10n.homeworkCreatedSuccess,
        );
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        AppToast.show(context, _extractError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final sheetHeight = MediaQuery.sizeOf(context).height * 0.7;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF6F7FB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: sheetHeight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _isEditing
                        ? l10n.editHomeworkButton
                        : l10n.addHomeworkButton,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _LockedValueField(
                            label: l10n.selectGroupLabel,
                            value: widget.groupName,
                          ),
                          const SizedBox(height: 14),
                          _TeacherField(
                            controller: _titleController,
                            label: l10n.materialTitleLabel,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.materialTitleValidation;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          _TeacherField(
                            controller: _descriptionController,
                            label: l10n.materialDescriptionLabel,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 14),
                          _ActionTile(
                            icon: Icons.event_outlined,
                            title: l10n.homeworkDueDateLabel,
                            subtitle: DateFormat(
                              'dd.MM.yyyy HH:mm',
                            ).format(_dueDate),
                            onTap: _pickDueDate,
                          ),
                          const SizedBox(height: 14),
                          _ActionTile(
                            icon: Icons.attach_file_rounded,
                            title: _isEditing
                                ? l10n.currentFileLabel
                                : l10n.materialFileLabel,
                            subtitle: _selectedFileName ??
                                l10n.homeworkFileOptionalHint,
                            onTap: _pickFile,
                          ),
                          const SizedBox(height: 14),
                          _TargetTypeSelector(
                            targetType: _targetType,
                            onChanged: (value) {
                              setState(() {
                                _targetType = value;
                                if (value == 'GROUP') {
                                  _selectedStudentIds.clear();
                                }
                              });
                            },
                          ),
                          if (_isIndividual) ...[
                            const SizedBox(height: 14),
                            _StudentsSelector(
                              students: widget.students,
                              selectedStudentIds: _selectedStudentIds,
                              onToggle: (studentId) {
                                setState(() {
                                  if (_selectedStudentIds.contains(studentId)) {
                                    _selectedStudentIds.remove(studentId);
                                  } else {
                                    _selectedStudentIds.add(studentId);
                                  }
                                });
                              },
                            ),
                          ],
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.homeworkActiveLabel,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        l10n.homeworkActiveHint,
                                        style: const TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: _isActive,
                                  onChanged: (value) {
                                    setState(() => _isActive = value);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4C63D2),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                _isSubmitting
                                    ? l10n.loadingLabel
                                    : _isEditing
                                    ? l10n.save
                                    : l10n.createHomeworkButton,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TeacherField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final String? Function(String?)? validator;

  const _TeacherField({
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF4C63D2)),
        ),
      ),
    );
  }
}

class _LockedValueField extends StatelessWidget {
  final String label;
  final String value;

  const _LockedValueField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Color(0xFF171923),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF4C63D2).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF4C63D2)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF171923),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}

class _TargetTypeSelector extends StatelessWidget {
  final String targetType;
  final ValueChanged<String> onChanged;

  const _TargetTypeSelector({
    required this.targetType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TargetTypeButton(
              isSelected: targetType == 'GROUP',
              title: l10n.homeworkTargetGroupOption,
              icon: Icons.groups_rounded,
              onTap: () => onChanged('GROUP'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TargetTypeButton(
              isSelected: targetType == 'INDIVIDUAL',
              title: l10n.homeworkTargetIndividualOption,
              icon: Icons.person_outline_rounded,
              onTap: () => onChanged('INDIVIDUAL'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetTypeButton extends StatelessWidget {
  final bool isSelected;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _TargetTypeButton({
    required this.isSelected,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4C63D2).withValues(alpha: 0.12)
              : const Color(0xFFF8F9FD),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4C63D2)
                : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF4C63D2)),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF171923),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentsSelector extends StatelessWidget {
  final List<GroupStudentModel> students;
  final Set<int> selectedStudentIds;
  final ValueChanged<int> onToggle;

  const _StudentsSelector({
    required this.students,
    required this.selectedStudentIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeworkAssignedStudentsLabel,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF171923),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.homeworkAssignedStudentsHint,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
          ),
          const SizedBox(height: 12),
          if (students.isEmpty)
            Text(
              l10n.noGroupStudentsTitle,
              style: const TextStyle(color: Color(0xFF6B7280)),
            )
          else
            ...students.map(
              (student) => CheckboxListTile(
                value: selectedStudentIds.contains(student.studentId),
                contentPadding: EdgeInsets.zero,
                activeColor: const Color(0xFF4C63D2),
                title: Text(
                  student.fullName.isEmpty ? student.email : student.fullName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: student.fullName.isEmpty
                    ? null
                    : Text(student.email),
                onChanged: (_) => onToggle(student.studentId),
              ),
            ),
        ],
      ),
    );
  }
}
