import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/home/model/team.dart';

class ListTileItem extends StatelessWidget {
  final Team team;
  const ListTileItem({required this.team});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        team.logoUrl ??
            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/330px-No-Image-Placeholder.svg.png',
        width: 45.0,
        height: 45.0,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 45.0,
            width: 45.0,
            child: Center(
                child: Text(
              'No Image',
              textAlign: TextAlign.center,
            )),
          );
        },
        loadingBuilder: (context, loading, loadingProgress) {
          if (loadingProgress != null) return CircularProgressIndicator();
          return loading;
        },
      ),
      title: Text('${team.name}'),
      isThreeLine: true,
      subtitle: Text('${team.tag}'),
      trailing: RichText(
        text: TextSpan(style: DefaultTextStyle.of(context).style, children: [
          TextSpan(text: 'W: ', style: TextStyle(color: Colors.green)),
          TextSpan(text: '${team.wins} '),
          TextSpan(text: 'L: ', style: TextStyle(color: Colors.red)),
          TextSpan(text: '${team.losses}')
        ]),
      ),
      dense: true,
    );
  }
}
