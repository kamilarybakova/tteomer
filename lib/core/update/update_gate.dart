import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import 'update_info.dart';
import 'update_service.dart';

class UpdateGate extends StatefulWidget {
  final Widget child;

  const UpdateGate({super.key, required this.child});

  @override
  State<UpdateGate> createState() => _UpdateGateState();
}

class _UpdateGateState extends State<UpdateGate> {
  final UpdateService _updateService = UpdateService();
  bool _checked = false;
  bool _sheetVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_checked) return;
    _checked = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForUpdate());
  }

  Future<void> _checkForUpdate() async {
    debugPrint('🔄 [UpdateGate] Checking whether update sheet should be shown');
    final info = await _updateService.getUpdateInfo();
    if (!mounted) {
      debugPrint('⚪ [UpdateGate] Widget is not mounted anymore, skipping');
      return;
    }
    if (!info.shouldUpdate) {
      debugPrint('✅ [UpdateGate] No update required, sheet will not be shown');
      return;
    }
    if (_sheetVisible) {
      debugPrint('⚪ [UpdateGate] Update sheet is already visible');
      return;
    }

    debugPrint(
      '🚨 [UpdateGate] Showing update sheet | forceUpdate: ${info.forceUpdate} | current: ${info.currentVersion} | latest: ${info.latestVersion}',
    );
    _sheetVisible = true;

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: !info.forceUpdate,
      enableDrag: !info.forceUpdate,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PopScope(
        canPop: !info.forceUpdate,
        child: _UpdateBottomSheet(info: info, onUpdateTap: _openStore),
      ),
    );

    debugPrint('✅ [UpdateGate] Update sheet closed');
    _sheetVisible = false;
  }

  Future<void> _openStore() async {
    final primaryUri = _updateService.getStoreUri();
    final fallbackUri = _updateService.getStoreFallbackUri();
    debugPrint('🔗 [UpdateGate] Trying primary store URL: $primaryUri');
    if (await canLaunchUrl(primaryUri)) {
      debugPrint('✅ [UpdateGate] Opening primary store URL');
      await launchUrl(primaryUri, mode: LaunchMode.externalApplication);
      return;
    }
    debugPrint(
      '⚠️ [UpdateGate] Primary store URL unavailable, trying fallback: $fallbackUri',
    );
    if (await canLaunchUrl(fallbackUri)) {
      debugPrint('✅ [UpdateGate] Opening fallback store URL');
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      return;
    }
    debugPrint('🔴 [UpdateGate] Could not open any store URL');
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _UpdateBottomSheet extends StatelessWidget {
  final UpdateInfo info;
  final Future<void> Function() onUpdateTap;

  const _UpdateBottomSheet({required this.info, required this.onUpdateTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!info.forceUpdate)
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              if (!info.forceUpdate) const SizedBox(height: 20),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.system_update_alt_rounded,
                  color: Color(0xFF4C63D2),
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                info.forceUpdate
                    ? l10n.forceUpdateTitle
                    : l10n.optionalUpdateTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.updateMessage(info.currentVersion, info.latestVersion),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6B7280),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onUpdateTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C63D2),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: Text(l10n.updateNow),
                ),
              ),
              if (!info.forceUpdate) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF6B7280),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(l10n.later),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
