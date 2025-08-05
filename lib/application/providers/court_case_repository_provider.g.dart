// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'court_case_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredCasesHash() => r'01b92529e8456c0a77153eadca0d8601949dde35';

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

/// See also [filteredCases].
@ProviderFor(filteredCases)
const filteredCasesProvider = FilteredCasesFamily();

/// See also [filteredCases].
class FilteredCasesFamily extends Family<List<CourtCase>> {
  /// See also [filteredCases].
  const FilteredCasesFamily();

  /// See also [filteredCases].
  FilteredCasesProvider call({
    String? query,
    String? caseType,
    String? status,
    String? year,
  }) {
    return FilteredCasesProvider(
      query: query,
      caseType: caseType,
      status: status,
      year: year,
    );
  }

  @override
  FilteredCasesProvider getProviderOverride(
    covariant FilteredCasesProvider provider,
  ) {
    return call(
      query: provider.query,
      caseType: provider.caseType,
      status: provider.status,
      year: provider.year,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredCasesProvider';
}

/// See also [filteredCases].
class FilteredCasesProvider extends AutoDisposeProvider<List<CourtCase>> {
  /// See also [filteredCases].
  FilteredCasesProvider({
    String? query,
    String? caseType,
    String? status,
    String? year,
  }) : this._internal(
         (ref) => filteredCases(
           ref as FilteredCasesRef,
           query: query,
           caseType: caseType,
           status: status,
           year: year,
         ),
         from: filteredCasesProvider,
         name: r'filteredCasesProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$filteredCasesHash,
         dependencies: FilteredCasesFamily._dependencies,
         allTransitiveDependencies:
             FilteredCasesFamily._allTransitiveDependencies,
         query: query,
         caseType: caseType,
         status: status,
         year: year,
       );

  FilteredCasesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
    required this.caseType,
    required this.status,
    required this.year,
  }) : super.internal();

  final String? query;
  final String? caseType;
  final String? status;
  final String? year;

  @override
  Override overrideWith(
    List<CourtCase> Function(FilteredCasesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredCasesProvider._internal(
        (ref) => create(ref as FilteredCasesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
        caseType: caseType,
        status: status,
        year: year,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<CourtCase>> createElement() {
    return _FilteredCasesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredCasesProvider &&
        other.query == query &&
        other.caseType == caseType &&
        other.status == status &&
        other.year == year;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, caseType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredCasesRef on AutoDisposeProviderRef<List<CourtCase>> {
  /// The parameter `query` of this provider.
  String? get query;

  /// The parameter `caseType` of this provider.
  String? get caseType;

  /// The parameter `status` of this provider.
  String? get status;

  /// The parameter `year` of this provider.
  String? get year;
}

class _FilteredCasesProviderElement
    extends AutoDisposeProviderElement<List<CourtCase>>
    with FilteredCasesRef {
  _FilteredCasesProviderElement(super.provider);

  @override
  String? get query => (origin as FilteredCasesProvider).query;
  @override
  String? get caseType => (origin as FilteredCasesProvider).caseType;
  @override
  String? get status => (origin as FilteredCasesProvider).status;
  @override
  String? get year => (origin as FilteredCasesProvider).year;
}

String _$followedCasesHash() => r'e1f76ac98cb2514a43a009cb40f1f349af2cbb14';

/// See also [followedCases].
@ProviderFor(followedCases)
final followedCasesProvider =
    AutoDisposeFutureProvider<List<CourtCase>>.internal(
      followedCases,
      name: r'followedCasesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$followedCasesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FollowedCasesRef = AutoDisposeFutureProviderRef<List<CourtCase>>;
String _$courtCaseRepositoryNotifierHash() =>
    r'f4d27ca8907c85644066858a5c8dc4bfe5b24c9f';

/// See also [CourtCaseRepositoryNotifier].
@ProviderFor(CourtCaseRepositoryNotifier)
final courtCaseRepositoryNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      CourtCaseRepositoryNotifier,
      List<CourtCase>
    >.internal(
      CourtCaseRepositoryNotifier.new,
      name: r'courtCaseRepositoryNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$courtCaseRepositoryNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CourtCaseRepositoryNotifier =
    AutoDisposeAsyncNotifier<List<CourtCase>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
