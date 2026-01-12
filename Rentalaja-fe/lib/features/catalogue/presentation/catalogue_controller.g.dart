// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalogue_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminTransactionsHash() => r'a5aec8f044b6c68ac902b0bbaa40fe54f2d555ad';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [adminTransactions].
@ProviderFor(adminTransactions)
const adminTransactionsProvider = AdminTransactionsFamily();

/// See also [adminTransactions].
class AdminTransactionsFamily extends Family<AsyncValue<List<Transaction>>> {
  /// See also [adminTransactions].
  const AdminTransactionsFamily();

  /// See also [adminTransactions].
  AdminTransactionsProvider call(String token) {
    return AdminTransactionsProvider(token);
  }

  @override
  AdminTransactionsProvider getProviderOverride(
    covariant AdminTransactionsProvider provider,
  ) {
    return call(provider.token);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'adminTransactionsProvider';
}

/// See also [adminTransactions].
class AdminTransactionsProvider
    extends AutoDisposeFutureProvider<List<Transaction>> {
  /// See also [adminTransactions].
  AdminTransactionsProvider(String token)
    : this._internal(
        (ref) => adminTransactions(ref as AdminTransactionsRef, token),
        from: adminTransactionsProvider,
        name: r'adminTransactionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$adminTransactionsHash,
        dependencies: AdminTransactionsFamily._dependencies,
        allTransitiveDependencies:
            AdminTransactionsFamily._allTransitiveDependencies,
        token: token,
      );

  AdminTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token,
  }) : super.internal();

  final String token;

  @override
  Override overrideWith(
    FutureOr<List<Transaction>> Function(AdminTransactionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminTransactionsProvider._internal(
        (ref) => create(ref as AdminTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token: token,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Transaction>> createElement() {
    return _AdminTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminTransactionsProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AdminTransactionsRef on AutoDisposeFutureProviderRef<List<Transaction>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _AdminTransactionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Transaction>>
    with AdminTransactionsRef {
  _AdminTransactionsProviderElement(super.provider);

  @override
  String get token => (origin as AdminTransactionsProvider).token;
}

String _$productsHash() => r'cfadb485af8a8e8d170c21132633bf4fc474c7ec';

/// See also [Products].
@ProviderFor(Products)
final productsProvider =
    AutoDisposeAsyncNotifierProvider<Products, List<ElectronicItem>>.internal(
      Products.new,
      name: r'productsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$productsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Products = AutoDisposeAsyncNotifier<List<ElectronicItem>>;
String _$productDetailHash() => r'46841625fd4406eab6cd123550390b806868bfcc';

abstract class _$ProductDetail
    extends BuildlessAutoDisposeAsyncNotifier<ElectronicItem> {
  late final int id;

  FutureOr<ElectronicItem> build(int id);
}

/// See also [ProductDetail].
@ProviderFor(ProductDetail)
const productDetailProvider = ProductDetailFamily();

/// See also [ProductDetail].
class ProductDetailFamily extends Family<AsyncValue<ElectronicItem>> {
  /// See also [ProductDetail].
  const ProductDetailFamily();

  /// See also [ProductDetail].
  ProductDetailProvider call(int id) {
    return ProductDetailProvider(id);
  }

  @override
  ProductDetailProvider getProviderOverride(
    covariant ProductDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productDetailProvider';
}

/// See also [ProductDetail].
class ProductDetailProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<ProductDetail, ElectronicItem> {
  /// See also [ProductDetail].
  ProductDetailProvider(int id)
    : this._internal(
        () => ProductDetail()..id = id,
        from: productDetailProvider,
        name: r'productDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productDetailHash,
        dependencies: ProductDetailFamily._dependencies,
        allTransitiveDependencies:
            ProductDetailFamily._allTransitiveDependencies,
        id: id,
      );

  ProductDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  FutureOr<ElectronicItem> runNotifierBuild(covariant ProductDetail notifier) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(ProductDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductDetailProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ProductDetail, ElectronicItem>
  createElement() {
    return _ProductDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductDetailRef on AutoDisposeAsyncNotifierProviderRef<ElectronicItem> {
  /// The parameter `id` of this provider.
  int get id;
}

class _ProductDetailProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<ProductDetail, ElectronicItem>
    with ProductDetailRef {
  _ProductDetailProviderElement(super.provider);

  @override
  int get id => (origin as ProductDetailProvider).id;
}

String _$transactionHistoryHash() =>
    r'a13f1637efc11e79b58d41ce285937a7f052330a';

abstract class _$TransactionHistory
    extends BuildlessAutoDisposeAsyncNotifier<List<Transaction>> {
  late final String token;

  FutureOr<List<Transaction>> build(String token);
}

/// See also [TransactionHistory].
@ProviderFor(TransactionHistory)
const transactionHistoryProvider = TransactionHistoryFamily();

/// See also [TransactionHistory].
class TransactionHistoryFamily extends Family<AsyncValue<List<Transaction>>> {
  /// See also [TransactionHistory].
  const TransactionHistoryFamily();

  /// See also [TransactionHistory].
  TransactionHistoryProvider call(String token) {
    return TransactionHistoryProvider(token);
  }

  @override
  TransactionHistoryProvider getProviderOverride(
    covariant TransactionHistoryProvider provider,
  ) {
    return call(provider.token);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'transactionHistoryProvider';
}

/// See also [TransactionHistory].
class TransactionHistoryProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          TransactionHistory,
          List<Transaction>
        > {
  /// See also [TransactionHistory].
  TransactionHistoryProvider(String token)
    : this._internal(
        () => TransactionHistory()..token = token,
        from: transactionHistoryProvider,
        name: r'transactionHistoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$transactionHistoryHash,
        dependencies: TransactionHistoryFamily._dependencies,
        allTransitiveDependencies:
            TransactionHistoryFamily._allTransitiveDependencies,
        token: token,
      );

  TransactionHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token,
  }) : super.internal();

  final String token;

  @override
  FutureOr<List<Transaction>> runNotifierBuild(
    covariant TransactionHistory notifier,
  ) {
    return notifier.build(token);
  }

  @override
  Override overrideWith(TransactionHistory Function() create) {
    return ProviderOverride(
      origin: this,
      override: TransactionHistoryProvider._internal(
        () => create()..token = token,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token: token,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TransactionHistory, List<Transaction>>
  createElement() {
    return _TransactionHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionHistoryProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionHistoryRef
    on AutoDisposeAsyncNotifierProviderRef<List<Transaction>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _TransactionHistoryProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          TransactionHistory,
          List<Transaction>
        >
    with TransactionHistoryRef {
  _TransactionHistoryProviderElement(super.provider);

  @override
  String get token => (origin as TransactionHistoryProvider).token;
}

String _$transactionControllerHash() =>
    r'a226ace51d6aa3987c981e9a27a09e9a607b3388';

/// See also [TransactionController].
@ProviderFor(TransactionController)
final transactionControllerProvider =
    AutoDisposeAsyncNotifierProvider<TransactionController, void>.internal(
      TransactionController.new,
      name: r'transactionControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TransactionController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
