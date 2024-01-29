import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_ex/model/model.dart';
import 'package:redux_ex/redux/actions.dart';
import 'package:redux_ex/redux/middleware.dart';
import 'package:redux_ex/redux/reducers.dart';
import 'package:redux_ex/ui/home_screen.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final DevToolsStore<AppState> store = DevToolsStore<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: appStateMiddleware(),
    );

    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: StoreBuilder<AppState>(
              onInit: (store) => store.dispatch(GetItemsAction()),
              builder: (BuildContext context, Store<AppState> store) =>
                  HomeScreen(store)),
          //const HomeScreen(),
        ));
  }
}
