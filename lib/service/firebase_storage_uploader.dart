// lib/service/firebase_storage_uploader.dart
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
        final file = File(imagePath);

        // 파일 존재 여부를 먼저 확인 (iOS 임시 경로 방어)
        if (!file.existsSync()) {
          return Error(
            ServerFailure('이미지 파일을 찾을 수 없습니다. 다시 선택해 주세요.'),
          );
        }

        // putData()로 bytes 직접 업로드: iOS 임시 경로 만료 문제 방어
        final bytes = await file.readAsBytes();
        final metadata = SettableMetadata(contentType: 'image/jpeg');
        await ref.putData(bytes, metadata);

        final url = await ref.getDownloadURL();
        urls.add(url);
      } on FirebaseException catch (e) {
        return Error(FirebaseErrorMapper.toFailure(e));
      } on FileSystemException catch (e) {
        return Error(
          ServerFailure('이미지 파일 읽기에 실패했습니다: ${e.message}'),
        );
      } catch (e) {
        return Error(ServerFailure('이미지 업로드 중 알 수 없는 오류가 발생했습니다: $e'));
      }
    }
    return Success(urls);
  }
}
