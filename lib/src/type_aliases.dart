import 'package:analyzer/analyzer.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';

class TypeAliasConverter {
  final FunctionTypeAlias _function;
  final GenericTypeAlias _generic;

  TypeAlias get base => _generic ?? _function;

  NodeList<Annotation> get metadata => base.metadata;

  Token get typedefKeyword => base.typedefKeyword;

  SimpleIdentifier get name => base.name;

  TypeParameterList get typeParameters =>
      _generic?.typeParameters ?? _function?.typeParameters;

  Token get equals => _generic?.equals;

  GenericFunctionType get functionType => _generic?.functionType;

  bool get hasEqualsToken => equals != null;

  bool get shouldIncludeTypeParameters {
    if (_function == null) return true;

    final types = typeParameters?.typeParameters?.map((type) => '$type') ?? [];
    final paramTypes = _function.parameters.parameters
        .whereType<SimpleFormalParameter>()
        .map((parameter) => '${parameter.type}');
    return types.any((type) => paramTypes.contains(type));
  }

  TypeAliasConverter(this._generic) : _function = null;

  TypeAliasConverter.fromFunctionTypeAlias(this._function) : _generic = null;
}

class GenericFunctionTypeConverter {
  final GenericFunctionType _functionType;
  final FunctionTypeAlias _typeAlias;
  final bool _shouldIncludeTypeParameters;

  TypeAnnotation get returnType =>
      _functionType?.returnType ?? _typeAlias?.returnType;

  get functionKeyword => _functionType?.functionKeyword;

  get typeParameters => _shouldIncludeTypeParameters
      ? _functionType?.typeParameters ?? _typeAlias?.typeParameters
      : null;

  get parameters => _functionType?.parameters ?? _typeAlias?.parameters;

  bool get hasFunctionKeyword => functionKeyword != null;

  GenericFunctionTypeConverter(this._functionType)
      : _typeAlias = null,
        _shouldIncludeTypeParameters = true;

  GenericFunctionTypeConverter.fromTypeAlias(TypeAliasConverter converter)
      : _functionType = converter.functionType,
        _typeAlias = converter._function,
        _shouldIncludeTypeParameters = converter.shouldIncludeTypeParameters;
}
