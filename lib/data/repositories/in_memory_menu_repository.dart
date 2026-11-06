import 'package:flutter/material.dart';

import '../../models/dish.dart';
import 'menu_repository.dart';

/// Реализация меню: данные лежат прямо в коде.
/// Позже её можно заменить на реализацию, которая берёт меню с сервера.
class InMemoryMenuRepository implements MenuRepository {
  InMemoryMenuRepository({this.delay = const Duration(milliseconds: 400)});

  /// Имитация задержки сети (в тестах ставим Duration.zero).
  final Duration delay;

  static const List<Dish> _dishes = [
    Dish(
      id: 1,
      name: 'Бургер',
      description: 'Говяжья котлета, сыр, овощи',
      price: 350,
      category: 'Основное',
      icon: Icons.lunch_dining,
    ),
    Dish(
      id: 2,
      name: 'Пицца',
      description: 'Пепперони, 30 см',
      price: 520,
      category: 'Основное',
      icon: Icons.local_pizza,
    ),
    Dish(
      id: 3,
      name: 'Шаурма',
      description: 'Курица, овощи, соус',
      price: 250,
      category: 'Основное',
      icon: Icons.restaurant,
    ),
    Dish(
      id: 4,
      name: 'Картошка фри',
      description: 'Большая порция',
      price: 150,
      category: 'Закуски',
      icon: Icons.fastfood,
    ),
    Dish(
      id: 5,
      name: 'Кофе',
      description: 'Американо 300 мл',
      price: 120,
      category: 'Напитки',
      icon: Icons.coffee,
    ),
    Dish(
      id: 6,
      name: 'Чай',
      description: 'Чёрный или зелёный',
      price: 80,
      category: 'Напитки',
      icon: Icons.emoji_food_beverage,
    ),
    Dish(
      id: 7,
      name: 'Чизкейк',
      description: 'Классический',
      price: 200,
      category: 'Десерты',
      icon: Icons.cake,
    ),
  ];

  @override
  Future<List<Dish>> getMenu() async {
    await Future.delayed(delay);
    return _dishes;
  }
}
