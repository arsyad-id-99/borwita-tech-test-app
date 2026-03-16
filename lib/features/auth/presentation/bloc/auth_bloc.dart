import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/login_usecase.dart';

// --- Events ---
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;

  LoginSubmitted({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

// --- States ---
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// --- BLoC ---
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        await loginUseCase(event.username, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
