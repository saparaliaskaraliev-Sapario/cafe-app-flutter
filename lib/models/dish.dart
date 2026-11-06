import 'package:flutter/material.dart';

/// Блюдо из меню. Объект неизменяемый (все поля final).
class Dish {
  const Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.icon,
  });

  final int id;
  final String name;
  final String description;
  final int price; // цена в рублях
  final String category;
  final IconData icon;

  // Два блюда считаются одинаковыми, если совпадает id.
  @override
  bool operator ==(Object other) => other is Dish && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
