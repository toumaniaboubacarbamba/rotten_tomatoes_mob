import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Initialisation au démarrage de l'app
  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher', // icône de l'app
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(initSettings);
  }

  // Notification simple
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'rotten_tomatoes_channel',
      'Rotten Tomatoes',
      channelDescription: 'Notifications de Rotten Tomatoes',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(required id, title, body, details);
  }

  // Notification ajout favori
  Future<void> showFavoriteNotification(String movieTitle) async {
    await showNotification(
      id: 1,
      title: 'Favori ajouté ',
      body: '$movieTitle a été ajouté à tes favoris !',
    );
  }

  // Notification retrait favori
  Future<void> showUnfavoriteNotification(String movieTitle) async {
    await showNotification(
      id: 2,
      title: 'Favori retiré',
      body: '$movieTitle a été retiré de tes favoris.',
    );
  }

  // Notification de bienvenue
  Future<void> showWelcomeNotification(String userName) async {
    await showNotification(
      id: 3,
      title: 'Bon retour ! ',
      body: 'Content de te revoir $userName !',
    );
  }
}
