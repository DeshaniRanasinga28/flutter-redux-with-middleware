import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:redux_ex/model/model.dart';
import 'package:redux_ex/redux/actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppState>> appStateMiddleware(
    [AppState state = const AppState(items: [])]) {
  final loadItem = _loadFromPrefs(state);
  final saveItem = _saveToPrefs(state);

  return [
    TypedMiddleware<AppState, AddItemAction>(saveItem),
    TypedMiddleware<AppState, RemoveItemAction>(saveItem),
    TypedMiddleware<AppState, RemoveItemsAction>(saveItem),
    TypedMiddleware<AppState, GetItemsAction>(loadItem),
  ];
}

Middleware<AppState> _loadFromPrefs(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);
    loadFromPrefs()
        .then((value) => store.dispatch(LoadedItemsAction(value.items)));
  };
}

Middleware<AppState> _saveToPrefs(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);
    saveToPrefs(store.state);
  };
}

void saveToPrefs(AppState state) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var string = json.encode(state.toJson());
  await preferences.setString('itemsState', string);
}

Future<AppState> loadFromPrefs() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var string = preferences.getString('itemsState');
  if (string != null) {
    Map map = json.decode(string);
    return AppState.fromJson(map);
  }

  return AppState.initialState();
}
