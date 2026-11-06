import 'package:flutter/material.dart';

import '../models/dish.dart';

/// Строка блюда в меню с кнопками + и -.
class DishTile extends StatelessWidget {
  const DishTile({
    super.key,
    required this.dish,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  final Dish dish;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(dish.icon)),
      title: Text(dish.name),
      subtitle: Text('${dish.description}\n${dish.price} ₽'),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (quantity > 0) ...[
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: onRemove,
            ),
            Text('$quantity', style: const TextStyle(fontSize: 16)),
          ],
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}
