import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/core/storage/secure_storage_provider.dart';
import 'package:tteomer/features/auth/data/model/learning_status_model.dart';
import 'package:tteomer/features/auth/presentation/pages/auth_screen.dart';
import 'package:tteomer/features/auth/presentation/provider/providers.dart';
import 'package:tteomer/l10n/app_localizations.dart';
import 'package:tteomer/main_navigation_screen.dart';

enum _GateRoute {
  auth,
  main,
  pending,
  rejected,
  noGroup,
  cohortEnded,
  noActiveCohort,
  error,
}

class _GateDecision {
  final _GateRoute route;
  final LearningStatusModel? status;
  final String? errorMessage;

  const _GateDecision({required this.route, this.status, this.errorMessage});
}

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  late Future<_GateDecision> _decisionFuture;

  @override
  void initState() {
    super.initState();
    _decisionFuture = _resolveGateDecision();
  }

  Future<_GateDecision> _resolveGateDecision() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: 'access_token');

    if (token == null || token.isEmpty) {
      return const _GateDecision(route: _GateRoute.auth);
    }

    final role = (await storage.read(key: 'user_role'))?.trim().toUpperCase();
    if (role != null && role.isNotEmpty && role != 'STUDENT') {
      return const _GateDecision(route: _GateRoute.main);
    }

    try {
      final status = await ref
          .read(authRemoteDataSourceProvider)
          .getLearningStatus();
      await _syncUserLevel(status);

      switch (status.state) {
        case StudentLearningState.active:
          return _GateDecision(route: _GateRoute.main, status: status);
        case StudentLearningState.pendingApproval:
          return _GateDecision(route: _GateRoute.pending, status: status);
        case StudentLearningState.rejected:
          return _GateDecision(route: _GateRoute.rejected, status: status);
        case StudentLearningState.noGroup:
          return _GateDecision(route: _GateRoute.noGroup, status: status);
        case StudentLearningState.cohortEnded:
          return _GateDecision(route: _GateRoute.cohortEnded, status: status);
        case StudentLearningState.noActiveCohort:
          return _GateDecision(
            route: _GateRoute.noActiveCohort,
            status: status,
          );
        case StudentLearningState.unknown:
          return _GateDecision(
            route: _GateRoute.error,
            status: status,
            errorMessage: 'Unknown learning status.',
          );
      }
    } catch (error) {
      return _GateDecision(
        route: _GateRoute.error,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> _syncUserLevel(LearningStatusModel status) async {
    final storage = ref.read(secureStorageProvider);
    final groupLevel = status.group?.level.trim().toUpperCase();

    if (groupLevel != null && groupLevel.isNotEmpty) {
      await storage.write(key: 'user_level', value: groupLevel);
      return;
    }

    if (status.state != StudentLearningState.active) {
      await storage.delete(key: 'user_level');
    }
  }

  void _refreshDecision() {
    if (!mounted) return;
    setState(() {
      _decisionFuture = _resolveGateDecision();
    });
  }

  Future<void> _logout() async {
    await ref.read(authNotifierProvider.notifier).logout();
    _refreshDecision();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_GateDecision>(
      future: _decisionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _Splash();
        }

        final decision =
            snapshot.data ??
            _GateDecision(
              route: _GateRoute.error,
              errorMessage: snapshot.error?.toString(),
            );

        switch (decision.route) {
          case _GateRoute.auth:
            return const AuthScreen();
          case _GateRoute.main:
            return const MainNavigationScreen();
          case _GateRoute.pending:
          case _GateRoute.rejected:
          case _GateRoute.noGroup:
          case _GateRoute.cohortEnded:
          case _GateRoute.noActiveCohort:
          case _GateRoute.error:
            return _StudentAccessStatusScreen(
              decision: decision,
              onRefresh: _refreshDecision,
              onLogout: _logout,
            );
        }
      },
    );
  }
}

class _StudentAccessStatusScreen extends StatefulWidget {
  final _GateDecision decision;
  final VoidCallback onRefresh;
  final Future<void> Function() onLogout;

  const _StudentAccessStatusScreen({
    required this.decision,
    required this.onRefresh,
    required this.onLogout,
  });

  @override
  State<_StudentAccessStatusScreen> createState() =>
      _StudentAccessStatusScreenState();
}

class _StudentAccessStatusScreenState extends State<_StudentAccessStatusScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _pollingTimer;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _configurePolling();
  }

  @override
  void didUpdateWidget(covariant _StudentAccessStatusScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.decision.route != widget.decision.route) {
      _configurePolling();
    }
  }

  void _configurePolling() {
    _pollingTimer?.cancel();
    if (widget.decision.route == _GateRoute.pending) {
      _pollingTimer = Timer.periodic(const Duration(seconds: 15), (_) {
        widget.onRefresh();
      });
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;
    setState(() => _isLoggingOut = true);
    await widget.onLogout();
    if (mounted) {
      setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = _resolveContent(l10n, widget.decision);
    final group = widget.decision.status?.group;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.decision.route == _GateRoute.pending)
                  _AnimatedApprovalLoader(controller: _controller)
                else
                  _StatusBadge(icon: content.icon),
                const SizedBox(height: 28),
                Text(
                  content.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF171923),
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF6B7280),
                  ),
                ),
                if (group != null) ...[
                  const SizedBox(height: 24),
                  _GroupInfoCard(group: group),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onRefresh,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C63D2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      content.primaryActionLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _isLoggingOut ? null : _handleLogout,
                  child: Text(
                    _isLoggingOut ? l10n.loadingLabel : l10n.logout,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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

  _StatusContent _resolveContent(
    AppLocalizations l10n,
    _GateDecision decision,
  ) {
    switch (decision.route) {
      case _GateRoute.pending:
        return _StatusContent(
          title: l10n.pendingApprovalTitle,
          subtitle: l10n.pendingApprovalSubtitle,
          primaryActionLabel: l10n.checkAgain,
          icon: Icons.hourglass_top_rounded,
        );
      case _GateRoute.rejected:
        return _StatusContent(
          title: l10n.rejectedAccessTitle,
          subtitle: l10n.rejectedAccessSubtitle,
          primaryActionLabel: l10n.checkAgain,
          icon: Icons.block_rounded,
        );
      case _GateRoute.noGroup:
        return _StatusContent(
          title: l10n.noGroupTitle,
          subtitle: l10n.noGroupSubtitle,
          primaryActionLabel: l10n.checkAgain,
          icon: Icons.groups_outlined,
        );
      case _GateRoute.cohortEnded:
        return _StatusContent(
          title: l10n.cohortEndedTitle,
          subtitle: l10n.cohortEndedSubtitle,
          primaryActionLabel: l10n.checkAgain,
          icon: Icons.event_busy_rounded,
        );
      case _GateRoute.noActiveCohort:
        return _StatusContent(
          title: l10n.noActiveCohortTitle,
          subtitle: l10n.noActiveCohortSubtitle,
          primaryActionLabel: l10n.checkAgain,
          icon: Icons.calendar_month_outlined,
        );
      case _GateRoute.error:
        return _StatusContent(
          title: l10n.accessStatusErrorTitle,
          subtitle: l10n.accessStatusErrorSubtitle,
          primaryActionLabel: l10n.checkAgain,
          icon: Icons.error_outline_rounded,
        );
      case _GateRoute.auth:
      case _GateRoute.main:
        return _StatusContent(
          title: '',
          subtitle: '',
          primaryActionLabel: l10n.checkAgain,
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

class _StatusContent {
  final String title;
  final String subtitle;
  final String primaryActionLabel;
  final IconData icon;

  const _StatusContent({
    required this.title,
    required this.subtitle,
    required this.primaryActionLabel,
    required this.icon,
  });
}

class _AnimatedApprovalLoader extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedApprovalLoader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 148,
      height: 148,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final outerScale = 0.92 + (controller.value * 0.12);
          final innerScale = 0.98 + (controller.value * 0.08);

          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: outerScale,
                child: Container(
                  width: 148,
                  height: 148,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF4C63D2).withValues(alpha: 0.10),
                  ),
                ),
              ),
              Transform.scale(
                scale: innerScale,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6C63FF), Color(0xFF4C63D2)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4C63D2).withValues(alpha: 0.26),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.hourglass_top_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final IconData icon;

  const _StatusBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF4C63D2).withValues(alpha: 0.10),
      ),
      child: Icon(icon, size: 44, color: const Color(0xFF4C63D2)),
    );
  }
}

class _GroupInfoCard extends StatelessWidget {
  final LearningGroupModel group;

  const _GroupInfoCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      if (group.name.isNotEmpty) (l10n.groupNameLabel, group.name),
      if (group.level.isNotEmpty) (l10n.groupLevelLabel, group.level),
      if (group.teacher.isNotEmpty) (l10n.groupTeacherLabel, group.teacher),
      if (group.lessonTime.isNotEmpty)
        (l10n.groupLessonTimeLabel, group.lessonTime),
      if (group.note.isNotEmpty) (l10n.groupNoteLabel, group.note),
    ];

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.groupInfoTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    item.$1,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    item.$2,
                    style: const TextStyle(
                      color: Color(0xFF171923),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
