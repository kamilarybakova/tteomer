import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/features/teacher/data/models/teacher_group_model.dart';
import 'package:tteomer/features/teacher/presentation/pages/pending_students_screen.dart';
import 'package:tteomer/features/teacher/presentation/providers/teacher_providers.dart';
import 'package:tteomer/l10n/app_localizations.dart';

class TeacherGroupsScreen extends ConsumerWidget {
  const TeacherGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final groupsAsync = ref.watch(teacherGroupsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          l10n.tabGroups,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: groupsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _TeacherErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(teacherGroupsProvider),
        ),
        data: (groups) {
          if (groups.isEmpty) {
            return _TeacherEmptyState(
              title: l10n.noTeacherGroupsTitle,
              subtitle: l10n.noTeacherGroupsSubtitle,
              icon: Icons.groups_outlined,
              onRefresh: () async => ref.refresh(teacherGroupsProvider.future),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(teacherGroupsProvider.future),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              itemCount: groups.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final group = groups[index];
                return _TeacherGroupCard(group: group);
              },
            ),
          );
        },
      ),
    );
  }
}

class _TeacherGroupCard extends StatelessWidget {
  final TeacherGroupModel group;

  const _TeacherGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PendingStudentsScreen(group: group),
          ),
        );
      },
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF18233F), Color(0xFF314FA5), Color(0xFF5E54F7)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4C63D2).withValues(alpha: 0.18),
              blurRadius: 22,
              offset: const Offset(0, 10),
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
                    group.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    group.level,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _TeacherChip(
                  icon: Icons.schedule_rounded,
                  label: group.lessonTime.isEmpty
                      ? l10n.groupTimeUnknown
                      : group.lessonTime,
                ),
                _TeacherChip(
                  icon: Icons.people_alt_outlined,
                  label: l10n.groupStudentsCount(
                    group.currentStudents,
                    group.maxStudents,
                  ),
                ),
              ],
            ),
            if (group.teacherName.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                '${l10n.groupTeacherLabel}: ${group.teacherName}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (group.note.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                group.note,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                Text(
                  l10n.openPendingStudents,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TeacherChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TeacherChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeacherEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Future<void> Function() onRefresh;

  const _TeacherEmptyState({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 80),
          Icon(icon, size: 58, color: const Color(0xFF4C63D2)),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
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
}

class _TeacherErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _TeacherErrorState({required this.message, required this.onRetry});

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
              size: 48,
              color: Color(0xFF4C63D2),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.teacherGroupsErrorTitle,
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
