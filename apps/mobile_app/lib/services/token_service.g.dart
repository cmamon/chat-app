// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tokenService)
final tokenServiceProvider = TokenServiceProvider._();

final class TokenServiceProvider
    extends $FunctionalProvider<TokenService, TokenService, TokenService>
    with $Provider<TokenService> {
  TokenServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenServiceHash();

  @$internal
  @override
  $ProviderElement<TokenService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenService create(Ref ref) {
    return tokenService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenService>(value),
    );
  }
}

String _$tokenServiceHash() => r'aa344406a3825ce8db34a87b9b85ab7e0a4e583e';
