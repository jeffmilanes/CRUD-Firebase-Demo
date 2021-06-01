import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morphosis_flutter_demo/home/bloc/team_bloc.dart';
import 'package:morphosis_flutter_demo/home/widget/list_tile_item.dart';
import 'package:morphosis_flutter_demo/main/widget/error.dart';

class TeamList extends StatefulWidget {
  @override
  _TeamListState createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  late TeamBloc _teamBloc;

  @override
  void initState() {
    super.initState();
    _teamBloc = context.read<TeamBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoSearchTextField(
              /// Assigning color to textfield due to cupertino bug on dark mode https://github.com/flutter/flutter/issues/48438
              style: TextStyle(color: Colors.white),
              onChanged: (text) => _teamBloc.add(Fetch(text: text)),
            ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: BlocBuilder<TeamBloc, TeamState>(
                builder: (context, state) {
                  if (state is TeamStateSuccess) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return ListTileItem(team: state.teams[index]);
                      },
                      itemCount: state.teams.length,
                    );
                  }

                  if (state is TeamStateError) {
                    return ErrorMessage(
                      message: 'Data cannot fetch',
                      buttonTitle: 'Refresh',
                      onTap: () => context.read<TeamBloc>()..add(Fetch()),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
