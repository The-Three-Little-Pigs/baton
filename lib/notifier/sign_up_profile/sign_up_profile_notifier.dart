import 'dart:io';

class SignUpProfileState {
  final File? selectedImage;
  final bool isLoading;

  SignUpProfileState({this.selectedImage, this.isLoading = false});

  SignUpProfileState copyWith({File? selectedImage, bool? isLoading}) {
    return SignUpProfileState(
      selectedImage: selectedImage ?? this.selectedImage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
