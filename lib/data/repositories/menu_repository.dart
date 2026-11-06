import '../../models/dish.dart';

/// Контракт репозитория меню.
/// Остальное приложение знает только про этот интерфейс,
/// но не знает, откуда берутся данные (память, база, сервер).
abstract class MenuRepository {
  Future<List<Dish>> getMenu();
}
