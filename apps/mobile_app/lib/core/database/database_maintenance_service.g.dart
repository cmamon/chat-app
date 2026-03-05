// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_maintenance_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DatabaseMaintenanceService)
final databaseMaintenanceServiceProvider =
    DatabaseMaintenanceServiceProvider._();

final class DatabaseMaintenanceServiceProvider
    extends $NotifierProvider<DatabaseMaintenanceService, void> {
  DatabaseMaintenanceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseMaintenanceServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseMaintenanceServiceHash();

  @$internal
  @override
  DatabaseMaintenanceService create() => DatabaseMaintenanceService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$databaseMaintenanceServiceHash() =>
    r'ecb54f6bf1a82de2bcc1ea3610aeab4a1d721eb6';

abstract class _$DatabaseMaintenanceService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
