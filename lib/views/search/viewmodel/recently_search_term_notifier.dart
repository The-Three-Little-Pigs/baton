import 'package:baton/notifier/user/user_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentlySearchTermNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return ref.read(userProvider).value?.recentlySearch.toList() ?? [];
  }

  void add(String term) {
    state = [term, ...state];
  }

  void remove(String term) {
    state = state.where((e) => e != term).toList();
  }

  void clear() {
    state = [];
  }
}
