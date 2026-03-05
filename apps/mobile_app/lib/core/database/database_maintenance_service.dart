import 'dart:async';
import 'package:kora_chat/core/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kora_chat/core/utils/logger.dart';

part 'database_maintenance_service.g.dart';

@Riverpod(keepAlive: true)
class DatabaseMaintenanceService extends _$DatabaseMaintenanceService {
  Timer? _maintenanceTimer;

  @override
  void build() {
    // Maintenance is triggered once on app start
    Future.microtask(() => performMaintenance());

    // And then every 24 hours if the app stays alive
    _maintenanceTimer = Timer.periodic(const Duration(hours: 24), (_) {
      performMaintenance();
    });

    ref.onDispose(() {
      _maintenanceTimer?.cancel();
    });
  }

  /// Performs a full maintenance sweep of the local database.
  Future<void> performMaintenance() async {
    final logger = ref.read(appLoggerProvider);
    final db = ref.read(appDatabaseProvider);

    try {
      logger.i('Starting database maintenance sweep...');
      final startTime = DateTime.now();

      // 1. Delete messages older than 30 days
      final deletedCount = await db.deleteOldMessages(const Duration(days: 30));
      if (deletedCount > 0) {
        logger.d('Maintenance: Deleted $deletedCount expired messages.');
      }

      // 2. Prune chats: keep only last 1000 messages for each chat
      // This prevents any single chat from growing too large locally.
      final chats = await db.getChats();
      for (final chat in chats) {
        await db.pruneChatMessages(chat.id, 1000);
      }

      // 3. Compact the database file
      await db.vacuum();

      final duration = DateTime.now().difference(startTime);
      logger.i(
        'Database maintenance completed successfully in ${duration.inMilliseconds}ms.',
      );
    } catch (e, stack) {
      logger.e('Database maintenance failed', error: e, stackTrace: stack);
    }
  }
}
