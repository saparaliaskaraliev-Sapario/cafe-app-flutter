import 'package:flutter/material.dart';

import 'data/repositories/in_memory_menu_repository.dart';
import 'data/repositories/in_memory_order_repository.dart';
import 'data/repositories/menu_repository.dart';
import 'data/repositories/order_repository.dart';
import 'screens/menu_screen.dart';
import 'state/cart_controller.dart';

void main() {
  // Здесь выбираем конкретные реализации репозиториев и передаём их вглубь.
  // Чтобы перейти, например, на сервер, достаточно заменить эти две строки.
  final MenuRepository menuRepository = InMemoryMenuRepository();
  final OrderRepository orderRepository = InMemoryOrderRepository();
  final cart = CartController(orderRepository);

  runApp(CafeApp(
    menuRepository: menuRepository,
    orderRepository: orderRepository,
    cart: cart,
  ));
}

class CafeApp extends StatelessWidget {
  const CafeApp({
    super.key,
    required this.menuRepository,
    required this.orderRepository,
    required this.cart,
  });

  final MenuRepository menuRepository;
  final OrderRepository orderRepository;
  final CartController cart;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кафе',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: MenuScreen(
        menuRepository: menuRepository,
        orderRepository: orderRepository,
        cart: cart,
      ),
    );
  }
}
