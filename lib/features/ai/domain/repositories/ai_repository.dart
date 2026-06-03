import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class AiRepository {
  Future<Either<Failure, Map<String, dynamic>>> predictQuality({
    required String biomassaType,
    required double suhuPirolisis,
    required double waktuPembakaran,
    required double beratInput,
  });
  Future<Either<Failure, String>> askChatbot(String question);
}
