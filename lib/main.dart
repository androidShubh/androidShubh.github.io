import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (e) {
              return Container(
                constraints: const BoxConstraints(minWidth: 48),
                height: 48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.primaries[e.hashCode % Colors.primaries.length],
                ),
                child: Center(child: Icon(e, color: Colors.white)),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T extends Object> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T extends Object> extends State<Dock<T>>
    with SingleTickerProviderStateMixin {
  /// [T] items being manipulated.
  late List<T> _items = widget.items.toList();

  /// Tracks the currently dragged item.
  T? _draggingItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _items.map((item) {
          return LongPressDraggable<T>(
            data: item,
            onDragStarted: () {
              setState(() {
                _draggingItem = item;
              });
            },
            onDragEnd: (_) {
              setState(() {
                _draggingItem = null;
              });
            },
            feedback: AnimatedBuilder(
              animation: AlwaysStoppedAnimation<double>(1.0),
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.2, // Slight zoom effect during drag
                  child: Material(
                    color: Colors.transparent,
                    child: widget.builder(item),
                  ),
                );
              },
            ),
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: widget.builder(item),
            ),
            child: DragTarget<T>(
              onWillAccept: (data) => data != item,
              onAccept: (data) {
                setState(() {
                  final oldIndex = _items.indexOf(data);
                  final newIndex = _items.indexOf(item);

                  _items.removeAt(oldIndex);
                  _items.insert(newIndex, data);
                });
              },
              builder: (context, candidateData, rejectedData) {
                return widget.builder(item);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
