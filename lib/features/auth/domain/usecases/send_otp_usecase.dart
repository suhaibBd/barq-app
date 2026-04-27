import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SendOtpUseCase implements UseCase<String, SendOtpParams> {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SendOtpParams params) async {
    return await repository.sendOtp(params.phone);
  }
}

class SendOtpParams extends Equatable {
  final String phone;
  const SendOtpParams({required this.phone});

  @override
  List<Object?> get props => [phone];
}
