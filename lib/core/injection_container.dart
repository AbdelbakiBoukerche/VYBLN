import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vybln/common/services/rsa_service.dart';
import 'package:vybln/common/services/user_cache.dart';

import '../common/repositories/user_repository.dart';
import '../features/auth/blocs/auth/auth_bloc.dart';
import '../features/auth/repositories/auth_repository.dart';
import '../features/chat/repositories/chat_repository.dart';
import '../features/search/repositories/search_repository.dart';
import '../utils/v_image_cropper.dart';
import '../utils/v_image_picker.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepository());

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      firebaseAuth: auth.FirebaseAuth.instance,
      userRepository: sl(),
    ),
  );

  sl.registerLazySingleton<SearchRepository>(() => SearchRepository());
  sl.registerLazySingleton<ChatRepository>(() => ChatRepository());

  // Cache
  sl.registerLazySingleton<UserCache>(() => UserCache());

  // Services
  sl.registerLazySingleton<RSAService>(() => RSAService());
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Wrappers
  sl.registerLazySingleton<VImagePicker>(
    () => VImagePicker(imagePicker: ImagePicker()),
  );
  sl.registerLazySingleton<VImageCropper>(
    () => VImageCropper(imageCropper: ImageCropper()),
  );

  // BLoCs
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(authRepository: sl()));
}
