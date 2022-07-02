extension Titled on String? {
  String get titled {
    final text = this;
    if (text == null) return '';
    return text
        .split(' ')
        .where((s) => s.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ')
        .split('-')
        .where((s) => s.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join('-');
  }
}
