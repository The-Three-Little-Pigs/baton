import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/di/repository/search_provider.dart';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/hot_keyword.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/repositories/repository/post_repository.dart';
import 'package:baton/models/repositories/repository/search_repository.dart';
import 'package:baton/models/repositories/repository/user_repository.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchService {
  final UserRepository userRepository;
  final SearchRepository searchRepository;
  final PostRepository postRepository;

  SearchService({
    required this.userRepository,
    required this.searchRepository,
    required this.postRepository,
  });

  Future<Result<List<Post>, Failure>> search(String uid, String keyword) async {
    await searchRepository.updateKeyword(keyword);
    await userRepository.addRecentlySearch(uid, keyword);

    return await postRepository.getPostBySearch(keyword);
  }
}
