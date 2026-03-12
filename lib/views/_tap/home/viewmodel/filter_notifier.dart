import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_notifier.g.dart';

class FilterState {
  final bool isOpen;

  FilterState({
    this.isOpen = false,
  });

  FilterState copyWith({
    bool? isOpen,
  }) {
    return FilterState(
      isOpen: isOpen ?? this.isOpen,
    );
  }
}

@riverpod
class FilterNotifier extends _$FilterNotifier {
  @override
  FilterState build() {
    return FilterState();
  }

  void toggle() {
    state = state.copyWith(
      isOpen: !state.isOpen,
    );
  }

  void close() {
    state = state.copyWith(isOpen: false);
  }
}
