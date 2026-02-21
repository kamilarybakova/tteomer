List<String> extractWords(String text) {
  return text
      .toLowerCase()
      .replaceAll(RegExp(r'[^\p{L}\s]', unicode: true), '')
      .split(RegExp(r'\s+'))
      .where((w) => w.length > 1)
      .toSet()
      .toList();
}
