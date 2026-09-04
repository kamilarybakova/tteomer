import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tteomer/core/widgets/app_toast.dart';
import 'package:tteomer/features/documents/data/model/teacher_document_model.dart';
import 'package:tteomer/features/documents/presentation/pages/document_webview_page.dart';
import 'package:tteomer/features/documents/presentation/provider/teacher_documents_provider.dart';
import 'package:tteomer/features/teacher/data/models/teacher_group_model.dart';
import 'package:tteomer/features/teacher/presentation/providers/teacher_providers.dart';
import 'package:tteomer/l10n/app_localizations.dart';

class TeacherDocumentsScreen extends ConsumerWidget {
  const TeacherDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final documentsAsync = ref.watch(teacherDocumentsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          l10n.tabDocs,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddTeacherDocumentSheet(),
          );
        },
        backgroundColor: const Color(0xFF4C63D2),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.upload_file_rounded),
        label: Text(l10n.addMaterialButton),
      ),
      body: TeacherDocumentsListSection(
        documentsAsync: documentsAsync,
        compactEmptyState: false,
      ),
    );
  }
}

class TeacherDocumentsListSection extends ConsumerWidget {
  final AsyncValue<List<TeacherDocumentModel>> documentsAsync;
  final bool compactEmptyState;

  const TeacherDocumentsListSection({
    super.key,
    required this.documentsAsync,
    this.compactEmptyState = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return documentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _TeacherDocumentsError(
        message: error.toString(),
        onRetry: () => ref.invalidate(teacherDocumentsProvider),
      ),
      data: (documents) {
        if (documents.isEmpty) {
          return compactEmptyState
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: _TeacherDocumentsEmptyCard(
                    title: l10n.noTeacherDocumentsTitle,
                    subtitle: l10n.noTeacherDocumentsSubtitle,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async =>
                      ref.refresh(teacherDocumentsProvider.future),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    children: [
                      const SizedBox(height: 100),
                      const Icon(
                        Icons.folder_open_rounded,
                        size: 60,
                        color: Color(0xFF4C63D2),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.noTeacherDocumentsTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.noTeacherDocumentsSubtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.45,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                l10n.addedMaterialsTitle,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF171923),
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: documents.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final document = documents[index];
                return _TeacherDocumentCard(document: document);
              },
            ),
          ],
        );
      },
    );
  }
}

class _TeacherDocumentsEmptyCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _TeacherDocumentsEmptyCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.folder_open_rounded,
            size: 42,
            color: Color(0xFF4C63D2),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6B7280), height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _TeacherDocumentCard extends StatelessWidget {
  final TeacherDocumentModel document;

  const _TeacherDocumentCard({required this.document});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
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
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF171923),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        document.groupName,
                        style: const TextStyle(
                          color: Color(0xFF4C63D2),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: document.isVisibleToStudents
                        ? const Color(0xFF12B76A).withValues(alpha: 0.12)
                        : const Color(0xFFEF4444).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    document.isVisibleToStudents
                        ? l10n.visibleToStudentsLabel
                        : l10n.hiddenFromStudentsLabel,
                    style: TextStyle(
                      color: document.isVisibleToStudents
                          ? const Color(0xFF12B76A)
                          : const Color(0xFFEF4444),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (document.description.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                document.description,
                style: const TextStyle(color: Color(0xFF6B7280), height: 1.45),
              ),
            ],
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _DocChip(
                  icon: Icons.attach_file_rounded,
                  label: document.fileSizeMb == '0'
                      ? '${document.fileSize} B'
                      : '${document.fileSizeMb} MB',
                ),
                if (document.createdAt != null)
                  _DocChip(
                    icon: Icons.schedule_rounded,
                    label: DateFormat('dd.MM.yyyy').format(document.createdAt!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DocChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DocChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF4C63D2).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
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

class _TeacherDocumentsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _TeacherDocumentsError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 52,
              color: Color(0xFF4C63D2),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.teacherDocumentsErrorTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280), height: 1.4),
            ),
            const SizedBox(height: 18),
            ElevatedButton(onPressed: onRetry, child: Text(l10n.checkAgain)),
          ],
        ),
      ),
    );
  }
}

class AddTeacherDocumentSheet extends ConsumerStatefulWidget {
  final int? initialGroupId;
  final String? initialGroupName;
  final TeacherDocumentModel? initialDocument;

  const AddTeacherDocumentSheet({
    super.key,
    this.initialGroupId,
    this.initialGroupName,
    this.initialDocument,
  });

  @override
  ConsumerState<AddTeacherDocumentSheet> createState() =>
      _AddTeacherDocumentSheetState();
}

class _AddTeacherDocumentSheetState
    extends ConsumerState<AddTeacherDocumentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  int? _selectedGroupId;
  String? _selectedFilePath;
  String? _selectedFileName;
  bool _isVisibleToStudents = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.initialGroupId ?? widget.initialDocument?.groupId;
    _titleController.text = widget.initialDocument?.title ?? '';
    _descriptionController.text = widget.initialDocument?.description ?? '';
    _selectedFileName = widget.initialDocument?.file.split('/').last;
    _isVisibleToStudents =
        widget.initialDocument?.isVisibleToStudents ?? true;
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

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    final isEditing = widget.initialDocument != null;

    if (!_formKey.currentState!.validate()) return;
    if (_selectedGroupId == null) {
      AppToast.show(context, l10n.selectGroupValidation);
      return;
    }
    if (!isEditing && (_selectedFilePath == null || _selectedFilePath!.isEmpty)) {
      AppToast.show(context, l10n.selectFileValidation);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      if (isEditing) {
        await ref
            .read(teacherDocumentsRemoteDataSourceProvider)
            .updateTeacherDocument(
              documentId: widget.initialDocument!.id,
              groupId: _selectedGroupId!,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              filePath: _selectedFilePath,
              isVisibleToStudents: _isVisibleToStudents,
            );
      } else {
        await ref
            .read(teacherDocumentsRemoteDataSourceProvider)
            .createTeacherDocument(
              groupId: _selectedGroupId!,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              filePath: _selectedFilePath!,
              isVisibleToStudents: _isVisibleToStudents,
            );
      }

      ref.invalidate(teacherDocumentsProvider);

      if (mounted) {
        AppToast.show(
          context,
          isEditing ? l10n.materialUpdatedSuccess : l10n.materialUploadedSuccess,
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
    final groupsAsync = ref.watch(teacherGroupsProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isEditing = widget.initialDocument != null;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF6F7FB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
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
                  isEditing ? l10n.editMaterialButton : l10n.addMaterialButton,
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
                        if (widget.initialGroupId != null)
                          _LockedGroupField(
                            label: l10n.selectGroupLabel,
                            value:
                                widget.initialGroupName ??
                                widget.initialGroupId.toString(),
                          )
                        else
                          groupsAsync.when(
                            loading: () => const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, _) => Text(
                              error.toString(),
                              style: const TextStyle(color: Color(0xFF6B7280)),
                            ),
                            data: (groups) => _GroupDropdownField(
                              groups: groups,
                              selectedGroupId: _selectedGroupId,
                              onChanged: (value) {
                                setState(() => _selectedGroupId = value);
                              },
                            ),
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            isEditing
                                ? l10n.currentFileLabel
                                : l10n.materialFileLabel,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF171923),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: _pickFile,
                          child: Ink(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(
                                  0xFF4C63D2,
                                ).withValues(alpha: 0.18),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF4C63D2,
                                    ).withValues(alpha: 0.10),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.attach_file_rounded,
                                    color: Color(0xFF4C63D2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _selectedFileName ??
                                        (isEditing
                                            ? l10n.replaceFileButton
                                            : l10n.selectFileButton),
                                    style: TextStyle(
                                      color: _selectedFileName == null
                                          ? const Color(0xFF6B7280)
                                          : const Color(0xFF171923),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.visibleToStudentsLabel,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.visibleToStudentsHint,
                                      style: const TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _isVisibleToStudents,
                                onChanged: (value) {
                                  setState(() => _isVisibleToStudents = value);
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
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              _isSubmitting
                                  ? l10n.loadingLabel
                                  : isEditing
                                  ? l10n.save
                                  : l10n.uploadMaterialButton,
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

class _GroupDropdownField extends StatelessWidget {
  final List<TeacherGroupModel> groups;
  final int? selectedGroupId;
  final ValueChanged<int?> onChanged;

  const _GroupDropdownField({
    required this.groups,
    required this.selectedGroupId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DropdownButtonFormField<int>(
      initialValue: selectedGroupId,
      decoration: InputDecoration(
        labelText: l10n.selectGroupLabel,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      items: groups
          .map(
            (group) => DropdownMenuItem<int>(
              value: group.id,
              child: Text('${group.name} • ${group.level}'),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _LockedGroupField extends StatelessWidget {
  final String label;
  final String value;

  const _LockedGroupField({required this.label, required this.value});

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
