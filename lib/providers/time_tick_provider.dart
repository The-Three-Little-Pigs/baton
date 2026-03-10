import 'package:flutter_riverpod/flutter_riverpod.dart';

final timeTickProvider = StreamProvider((ref) {
  return Stream.periodic(
    const Duration(minutes: 1),
    (computationCount) => DateTime.now(),
  );
});
