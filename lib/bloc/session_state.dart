part of 'session_bloc.dart';

@immutable
abstract class SessionState {
  final bool existPokemons;
  final SessionModel? currentSession;

  const SessionState({this.existPokemons = false, this.currentSession});
}

class SessionInitial extends SessionState {
  const SessionInitial() : super(existPokemons: false, currentSession: null);
}

class StartSession extends SessionState {
  final SessionModel setCurrentSession;
  const StartSession(this.setCurrentSession)
      : super(existPokemons: true, currentSession: setCurrentSession);
}

class Searching extends SessionState {
  final SessionModel setCurrentSession;
  const Searching(this.setCurrentSession)
      : super(existPokemons: false, currentSession: setCurrentSession);
}
