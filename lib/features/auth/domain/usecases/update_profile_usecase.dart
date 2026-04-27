import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase implements UseCase<User, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String firstName;
  final String lastName;
  final String? email;

  const UpdateProfileParams({
    required this.firstName,
    required this.lastName,
    this.email,
  });

  @override
  List<Object?> get props => [firstName, lastName, email];
}
