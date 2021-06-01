import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:morphosis_flutter_demo/home/model/team.dart';
import 'package:morphosis_flutter_demo/home/repo/team_repo.dart';
import 'package:rxdart/rxdart.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  TeamBloc({required this.teamRepo}) : super(TeamStateEmpty());

  final TeamRepo teamRepo;

  @override
  Stream<Transition<TeamEvent, TeamState>> transformEvents(
    Stream<TeamEvent> events,
    Stream<Transition<TeamEvent, TeamState>> Function(
      TeamEvent event,
    )
        transitionFn,
  ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<TeamState> mapEventToState(
    TeamEvent event,
  ) async* {
    if (event is Fetch) {
      yield await _mapFetchToState(event);
    }
  }

  Future<TeamState> _mapFetchToState(Fetch state) async {
    TeamStateLoading();
    try {
      final teams = await teamRepo.getTeam(state.text);
      return TeamStateSuccess(teams);
    } on Exception {
      return TeamStateError('Error');
    }
  }
}
