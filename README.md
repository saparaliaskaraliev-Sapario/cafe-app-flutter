Аскаралиев Сапар

# Кафе — мобильное приложение для заказа

## Суть приложения
Мобильное приложение для кафе. Пользователь просматривает меню по категориям,
добавляет блюда в корзину, меняет количество, видит итоговую сумму,
оформляет заказ и смотрит историю заказов.

## Технологический стек
- Язык: Dart
- Фреймворк: Flutter (Material 3)
- Управление состоянием: ChangeNotifier + ListenableBuilder (без сторонних пакетов)
- Архитектура: слои models / data (репозитории) / state / screens / widgets
- Тесты: flutter_test
- IDE: Visual Studio Code
- Контроль версий: Git, GitHub

## Структура проекта
```
lib/
  main.dart                       точка входа, сборка зависимостей
  models/                         модели данных
    dish.dart                     блюдо
    cart_item.dart                строка корзины (блюдо + количество)
    order.dart                    оформленный заказ
  data/repositories/              слой данных (репозитории)
    menu_repository.dart          интерфейс репозитория меню
    in_memory_menu_repository.dart    реализация: меню в памяти
    order_repository.dart         интерфейс репозитория заказов
    in_memory_order_repository.dart   реализация: заказы в памяти
  state/
    cart_controller.dart          логика корзины (ChangeNotifier)
  screens/
    menu_screen.dart              меню
    cart_screen.dart              корзина и оформление
    orders_screen.dart            история заказов
  widgets/
    dish_tile.dart                строка блюда с кнопками +/-
test/
  cart_controller_test.dart       unit-тесты корзины
```

## Как это работает (объяснение)

**Репозиторий** — это класс, который отвечает за получение и хранение данных.
Экраны не знают, откуда берутся блюда и куда сохраняются заказы, они просто
вызывают методы репозитория (`getMenu()`, `placeOrder()`, `getOrders()`).

В проекте два репозитория:
- `MenuRepository` — отдаёт список блюд;
- `OrderRepository` — сохраняет заказы и отдаёт историю.

У каждого есть **интерфейс** (абстрактный класс) и **реализация** `InMemory...`,
которая хранит данные в памяти. Если потом нужно брать меню с сервера или
хранить заказы в базе данных, пишется новая реализация того же интерфейса, а
экраны и логика корзины не меняются.

**Поток данных:**
1. В `main.dart` создаются репозитории и `CartController`, и передаются на экраны через конструкторы.
2. `MenuScreen` запрашивает меню у `MenuRepository`, пока данные грузятся, показывает индикатор (`FutureBuilder`).
3. Нажатие «+» вызывает `cart.add(dish)`. Контроллер меняет данные и вызывает `notifyListeners()`.
4. `ListenableBuilder` слушает контроллер и перерисовывает кнопку корзины и счётчики.
5. «Оформить заказ» вызывает `cart.checkout()`, контроллер отдаёт корзину в `OrderRepository.placeOrder()`, получает заказ с номером и очищает корзину.
6. `OrdersScreen` берёт историю из `OrderRepository.getOrders()`.

**Зачем так делать:** логика отделена от интерфейса, её можно тестировать без
экранов (см. `test/cart_controller_test.dart`), а источник данных легко заменить.

## Запуск
```
flutter create --platforms=android .
flutter pub get
flutter run
```

## Тесты
```
flutter test
```

## Сборка APK для Android
```
flutter build apk
```
Готовый файл: `build/app/outputs/flutter-apk/app-release.apk`
