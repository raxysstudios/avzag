import 'package:flutter/material.dart';

class EditorController<T> with ChangeNotifier {
  EditorController();

  T? _object;
  T? get object => _object;

  String? _id;
  String? get id => _id;

  bool get editing => object != null;

  T startEditing(T object, [String? id]) {
    _object = object;
    _id = id;
    notifyListeners();
    return object;
  }

  ValueSetter<V>? edit<V>(ValueSetter<V> action) {
    if (!editing) return null;
    return (V v) {
      action(v);
      notifyListeners();
    };
  }

  void stopEditing() {
    _object = null;
    _id = null;
    notifyListeners();
  }
}
