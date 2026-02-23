import 'dart:math';

import 'ids.dart';

class UuidIdGenerator implements IdGenerator {
  UuidIdGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const _maxRandomValue = 4294967296; // 2^32

  @override
  String next() {
    final ts = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
    final rand = _random
        .nextInt(_maxRandomValue)
        .toRadixString(16)
        .padLeft(8, '0');
    return 'task-$ts-$rand';
  }
}
