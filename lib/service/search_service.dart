import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/repositories/repository/post_repository.dart';
import 'package:baton/models/repositories/repository/search_repository.dart';
import 'package:baton/models/repositories/repository/user_repository.dart';

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
    await searchRepository.updateSearchRecord(uid, keyword);
    return await postRepository.getPostBySearch(keyword);
  }
}
