class UpdateInfo {
  final bool shouldUpdate;
  final bool forceUpdate;
  final String latestVersion;
  final String currentVersion;

  const UpdateInfo({
    required this.shouldUpdate,
    required this.forceUpdate,
    required this.latestVersion,
    required this.currentVersion,
  });

  static const disabled = UpdateInfo(
    shouldUpdate: false,
    forceUpdate: false,
    latestVersion: '',
    currentVersion: '',
  );
}
