import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux_ex/model/model.dart';
import 'package:redux_ex/redux/actions.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

class HomeScreen extends StatelessWidget {
  final DevToolsStore<AppState> store;

  const HomeScreen(this.store, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Redux Items"),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => Column(
          children: <Widget>[
            AddItemWidget(viewModel),
            Expanded(child: ItemListWidget(viewModel)),
            RemoveItemButton(viewModel)
          ],
        ),
      ),
      drawer: ReduxDevTools(store),
    );
  }
}

class AddItemWidget extends StatefulWidget {
  final _ViewModel model;

  const AddItemWidget(this.model);

  @override
  State<AddItemWidget> createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(hintText: 'Add an Item'),
      onSubmitted: (String s) {
        widget.model.onAddItem(s);
        controller.text = "";
      },
    );
  }
}

class ItemListWidget extends StatelessWidget {
  final _ViewModel model;

  const ItemListWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: model.items
            .map(
              (Item item) => ListTile(
                title: Text(item.body),
                leading: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => model.onRemoveItem(item),
                ),
                trailing: Checkbox(
                  value: item.completed,
                  onChanged: (b) {
                    model.onCompleted(item);
                  },
                ),
              ),
            )
            .toList());
  }
}

class RemoveItemButton extends StatelessWidget {
  final _ViewModel model;

  const RemoveItemButton(this.model);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => model.onRemoveItems(),
        child: const Text("Delete All Item"));
  }
}

class _ViewModel {
  final List<Item> items;
  final Function(Item) onCompleted;
  final Function(String) onAddItem;
  final Function(Item) onRemoveItem;
  final Function() onRemoveItems;

  _ViewModel({
    required this.items,
    required this.onCompleted,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onRemoveItems,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onAddItem(String body) {
      store.dispatch(AddItemAction(body));
    }

    _onRemoveItem(Item item) {
      store.dispatch(RemoveItemAction(item));
    }

    _onRemoveItems() {
      store.dispatch(RemoveItemsAction());
    }

    _onCompleted(Item item) {
      store.dispatch(ItemCompletedAction(item));
    }

    return _ViewModel(
      items: store.state.items,
      onCompleted: _onCompleted,
      onAddItem: _onAddItem,
      onRemoveItem: _onRemoveItem,
      onRemoveItems: _onRemoveItems,
    );
  }
}
