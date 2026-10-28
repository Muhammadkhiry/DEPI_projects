abstract class TimeHelpers {
  static String clock(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    return '${h.toString().padLeft(2, '0')}:$m ${t.hour >= 12 ? 'PM' : 'AM'}';
  }

  static String timeLeft(DateTime expiresAt, {DateTime? now}) {
    final diff = expiresAt.difference(now ?? DateTime.now());
    if (diff.inMinutes <= 0) return 'Expired';
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  static String ago(DateTime t, {DateTime? now}) {
    final diff = (now ?? DateTime.now()).difference(t);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
