part of 'team_bloc.dart';

abstract class TeamState extends Equatable {
  const TeamState();

  @override
  List<Object> get props => [];
}

class TeamStateEmpty extends TeamState {}

class TeamStateLoading extends TeamState {}

class TeamStateSuccess extends TeamState {
  const TeamStateSuccess(this.teams);

  final List<Team> teams;

  @override
  List<Object> get props => [teams];

  @override
  String toString() => 'TeamStateSuccess { teams: ${teams.length}}';
}

class TeamStateError extends TeamState {
  const TeamStateError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
