import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

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
      child: ReorderableWrap(
        scrollDirection: Axis.horizontal,
        spacing: 4.0,
        needsLongPressDraggable: false,
        runSpacing: 4.0,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            final item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
          });
        },
        buildDraggableFeedback: (context, constraints, child) {
          return Material(
            color: Colors.transparent,
            child: child,
          );
        },
        children: List.generate(_items.length, (index) {
          return AnimatedContainer(
            key: ValueKey(_items[index]),
            transform:  Matrix4.identity()..scale(1.05),
            duration: const Duration(milliseconds: 300),  // Animation duration
            curve: Curves.bounceInOut,
            child: widget.builder(_items[index])
          );
        }),
      ),

    );
  }
}


