import 'package:cafe_app/data/repositories/in_memory_menu_repository.dart';
import 'package:cafe_app/data/repositories/in_memory_order_repository.dart';
import 'package:cafe_app/models/dish.dart';
import 'package:cafe_app/state/cart_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryOrderRepository orders;
  late CartController cart;
  late List<Dish> menu;

  setUp(() async {
    orders = InMemoryOrderRepository();
    cart = CartController(orders);
    menu = await InMemoryMenuRepository(delay: Duration.zero).getMenu();
  });

  test('добавление блюд считает количество и сумму', () {
    final burger = menu[0]; // 350 ₽
    final coffee = menu[4]; // 120 ₽
    cart.add(burger);
    cart.add(burger);
    cart.add(coffee);

    expect(cart.totalCount, 3);
    expect(cart.totalPrice, 820);
    expect(cart.quantityOf(burger), 2);
  });

  test('удаление блюда уменьшает количество и убирает строку на нуле', () {
    final burger = menu[0];
    cart.add(burger);
    cart.add(burger);

    cart.remove(burger);
    expect(cart.quantityOf(burger), 1);

    cart.remove(burger);
    expect(cart.isEmpty, true);
  });

  test('оформление заказа сохраняет его в репозитории и очищает корзину',
      () async {
    cart.add(menu[0]);
    cart.add(menu[0]);
    cart.add(menu[4]);

    final order = await cart.checkout();

    expect(order.number, 1);
    expect(order.total, 820);
    expect(cart.isEmpty, true);
    expect((await orders.getOrders()).length, 1);
  });

  test('оформление пустой корзины даёт ошибку', () {
    expect(cart.checkout(), throwsStateError);
  });
}
