import 'package:flutter/material.dart';

typedef EditorCallback = ValueSetter<V> Function<V>(ValueSetter<V> action);

EditorCallback getEditor(ValueSetter<VoidCallback> setState) =>
    <V>(ValueSetter<V> f) => (V v) => setState(() => f(v));
