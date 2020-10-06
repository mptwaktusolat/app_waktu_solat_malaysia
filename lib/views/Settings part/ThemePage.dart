import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waktusolatmalaysia/blocs/change_theme_bloc.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/change_theme_state.dart';

//partly adapted from https://gist.github.com/bimsina/a04ac08358b4d1553ef2498d9155c9c1#file-awesome_widget-dart

class ThemesPage extends StatefulWidget {
  @override
  _ThemesPageState createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Themes'),
      ),
      body: Container(
        child: ThemesOptions(),
      ),
    );
  }
}

class ThemesOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeThemeBloc, ChangeThemeState>(
      builder: (context, state) {
        return ListView(
          children: [
            RadioListTile(
                value: 'null',
                groupValue: 'null',
                onChanged: (_) {
                  changeThemeBloc.onLightThemeChange();
                }),
            RadioListTile(
                value: 'null',
                groupValue: 'null',
                onChanged: (_) {
                  print('Hello world');
                }),
          ],
        );
      },
    );
  }
}
