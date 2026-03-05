class AppRoute {
  final String path;
  final String name;

  const AppRoute(this.path, this.name);
}

class AppRoutes {
  static const landing = AppRoute('/', 'landing');
  static const login = AppRoute('/login', 'login');
  static const register = AppRoute('/register', 'register');
  static const home = AppRoute('/home', 'home');
  static const profile = AppRoute('/profile', 'profile');
  static const search = AppRoute('/search', 'search');

  // Dynamic routes
  static const chat = AppRoute('/chat/:id', 'chat');
  static String chatPath(String id) => '/chat/$id';
}
