import 'dart:io';

import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageUploader {
  Future<Result<List<String>, Failure>> getDownloadUrls(
    List<String> imagePaths,
  ) async {
    final storageRef = FirebaseStorage.instance;
    final List<String> urls = [];
    const uuid = Uuid();

    for (final imagePath in imagePaths) {
      final fileName = "${uuid.v4()}.jpg";

      final ref = storageRef.ref().child("images/$fileName");
      try {
        await ref.putFile(File(imagePath));
        final url = await ref.getDownloadURL();
        urls.add(url);
      } on FirebaseException catch (e) {
        return Error(FirebaseErrorMapper.toFailure(e));
      } catch (e) {
        return Error(ServerFailure('이미지 업로드 중 알 수 없는 오류가 발생했습니다: $e'));
      }
    }
    return Success(urls);
  }
}
