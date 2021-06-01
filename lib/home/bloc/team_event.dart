part of 'team_bloc.dart';

@immutable
abstract class TeamEvent extends Equatable {
  const TeamEvent();
}

class Fetch extends TeamEvent {
  const Fetch({this.text});

  final String? text;

  @override
  List<Object?> get props => [text];

  @override
  String toString() => 'Fetch {text: $text}';
}
