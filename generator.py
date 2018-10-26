from abc import ABC, abstractmethod, abstractproperty
from functools import reduce
from typing import Dict, List, Tuple

from model import (Add, And, Array, Attribute, Equal, Expr, Field, First, GreaterEqual, Last,
                   Length, LessEqual, LogExpr, MathExpr, ModularInteger, Mul, Number, Or, PDU,
                   RangeInteger, Sub, TRUE, Type, Value, Variant)


class SparkRepresentation(ABC):
    def __eq__(self, other: object) -> bool:
        if isinstance(other, self.__class__):
            return self.__dict__ == other.__dict__
        return NotImplemented

    def __repr__(self) -> str:
        args = '\n\t' + ',\n\t'.join(f"{k}={v!r}" for k, v in self.__dict__.items())
        return f'{self.__class__.__name__}({args})'.replace('\t', '\t    ')

    @abstractmethod
    def specification(self) -> str:
        raise NotImplementedError

    @abstractmethod
    def definition(self) -> str:
        raise NotImplementedError


class Unit(SparkRepresentation):
    def __init__(self, context: List['ContextItem'], package: 'Package') -> None:
        self.context = context
        self.package = package

    def specification(self) -> str:
        context_clause = ''
        if self.context:
            context_clause = '{}\n\n'.format('\n'.join([c.specification() for c in self.context]))
        return '{}{}\n'.format(context_clause, self.package.specification())

    def definition(self) -> str:
        return '{}\n'.format(self.package.definition())


class ContextItem(SparkRepresentation):
    def __init__(self, name: str, use: bool) -> None:
        self.name = name
        self.use = use

    def specification(self) -> str:
        return 'with {};{}'.format(self.name, ' use {};'.format(self.name) if self.use else '')

    def definition(self) -> str:
        return ''


class Package(SparkRepresentation):
    def __init__(self, name: str, types: List['TypeDeclaration'],
                 subprograms: List['Subprogram']) -> None:
        self.name = name
        self.types = types
        self.subprograms = subprograms

    def specification(self) -> str:
        types = '\n\n'.join([t.specification() for t in self.types if t.specification()])
        if types:
            types += '\n\n'
        subprograms = '\n\n'.join([f.specification()
                                   for f in self.subprograms if f.specification()])
        if subprograms:
            subprograms += '\n\n'
        return 'package {name}\n  with SPARK_Mode\nis\n\n{types}{subprograms}end {name};'.format(
            name=self.name,
            types=types,
            subprograms=subprograms)

    def definition(self) -> str:
        if not self.subprograms:
            return ''
        types = '\n\n'.join([t.definition() for t in self.types if t.definition()])
        if types:
            types += '\n\n'
        subprograms = '\n\n'.join([f.definition() for f in self.subprograms if f.definition()])
        if subprograms:
            subprograms += '\n\n'
        return 'package body {name} is\n\n{types}{subprograms}end {name};'.format(
            name=self.name,
            types=types,
            subprograms=subprograms)


class TypeDeclaration(SparkRepresentation):
    def __init__(self, name: str) -> None:
        self.name = name

    def specification(self) -> str:
        type_declaration = ''
        return '{type_declaration}   function Convert_To_{name} is new Convert_To ({name});'.format(
            name=self.name,
            type_declaration=type_declaration)

    def definition(self) -> str:
        return ''


class ModularType(TypeDeclaration):
    def __init__(self, name: str, modulus: MathExpr) -> None:
        super().__init__(name)
        self.modulus = modulus

    def specification(self) -> str:
        declaration = '   type {name} is mod {modulus};\n'.format(
            name=self.name,
            modulus=self.modulus)
        return '{declaration}   function Convert_To_{name} is new Convert_To_Mod ({name});'.format(
            name=self.name,
            declaration=declaration)

    def definition(self) -> str:
        return ''


class RangeType(TypeDeclaration):
    def __init__(self, name: str, first: MathExpr, last: MathExpr, size: MathExpr) -> None:
        super().__init__(name)
        self.first = first
        self.last = last
        self.size = size

    def specification(self) -> str:
        declaration = '   type {name} is range {first} .. {last} with Size => {size};\n'.format(
            name=self.name,
            first=self.first,
            last=self.last,
            size=self.size)
        return '{declaration}   function Convert_To_{name} is new Convert_To_Int ({name});'.format(
            name=self.name,
            declaration=declaration)

    def definition(self) -> str:
        return ''


class Aspect(ABC):
    def __str__(self) -> str:
        if self.definition:
            return f'{self.mark} => {self.definition}'
        return f'{self.mark}'

    @abstractproperty
    def mark(self) -> str:
        raise NotImplementedError

    @abstractproperty
    def definition(self) -> str:
        raise NotImplementedError


class Precondition(Aspect):
    def __init__(self, expr: LogExpr) -> None:
        self.expr = expr

    @property
    def mark(self) -> str:
        return 'Pre'

    @property
    def definition(self) -> str:
        return str(self.expr)


class Postcondition(Aspect):
    def __init__(self, expr: LogExpr) -> None:
        self.expr = expr

    @property
    def mark(self) -> str:
        return 'Post'

    @property
    def definition(self) -> str:
        return str(self.expr)


class Ghost(Aspect):
    @property
    def mark(self) -> str:
        return 'Ghost'

    @property
    def definition(self) -> str:
        return ''


class Import(Aspect):
    @property
    def mark(self) -> str:
        return 'Import'

    @property
    def definition(self) -> str:
        return ''


class Subprogram(SparkRepresentation):
    def __init__(self, name: str, parameters: List[Tuple[str, str]] = None,
                 body: List['Statement'] = None, aspects: List[Aspect] = None) -> None:
        self.name = name
        self.parameters = parameters or []
        self.body = body or []
        self.aspects = aspects or []

    @abstractmethod
    def specification(self) -> str:
        raise NotImplementedError

    def _parameters(self) -> str:
        parameters = ''
        if self.parameters:
            parameters = '; '.join([f'{p_name} : {p_type}' for p_name, p_type in self.parameters])
            parameters = f' ({parameters})'
        return parameters

    def _body(self) -> str:
        return '\n'.join([s.definition() for s in self.body])

    def _with_clause(self) -> str:
        if not self.aspects:
            return ''
        with_clause = '\n     with\n       '
        for i, aspect in enumerate(self.aspects):
            with_clause += str(aspect)
            if i + 1 < len(self.aspects):
                with_clause += ',\n       '
        return with_clause


class Pragma(Subprogram):
    def __init__(self, name: str, parameters: List[str]) -> None:
        super().__init__(name)
        self.pragma_parameters = parameters

    def specification(self) -> str:
        parameters = ''
        if self.pragma_parameters:
            parameters = ', '.join(self.pragma_parameters)
            parameters = f' ({parameters})'
        return f'   pragma {self.name}{parameters};'

    def definition(self) -> str:
        return ''


class Function(Subprogram):
    # pylint: disable=too-many-arguments
    def __init__(self, name: str, return_type: str, parameters: List[Tuple[str, str]] = None,
                 body: List['Statement'] = None, aspects: List[Aspect] = None) -> None:
        super().__init__(name, parameters, body, aspects)
        self.return_type = return_type

    def specification(self) -> str:
        return (f'   function {self.name}{self._parameters()} return {self.return_type}'
                f'{self._with_clause()};')

    def definition(self) -> str:
        return (f'   function {self.name}{self._parameters()} return {self.return_type} is\n'
                f'   begin\n'
                f'{self._body()}\n'
                f'   end {self.name};')


class ExpressionFunction(Subprogram):
    # pylint: disable=too-many-arguments
    def __init__(self, name: str, return_type: str, parameters: List[Tuple[str, str]] = None,
                 expression: Expr = None, aspects: List[Aspect] = None) -> None:
        super().__init__(name, parameters, aspects=aspects)
        self.return_type = return_type
        self.expression = expression

    def specification(self) -> str:
        if self.expression:
            return (f'   function {self.name}{self._parameters()} return {self.return_type} is\n'
                    f'      ({self.expression!s}){self._with_clause()};')
        return (f'   function {self.name}{self._parameters()} return {self.return_type}'
                f'{self._with_clause()};')

    def definition(self) -> str:
        return ''


class Procedure(Subprogram):
    def specification(self) -> str:
        return f'   procedure {self.name}{self._parameters()}{self._with_clause()};'

    def definition(self) -> str:
        return (f'   procedure {self.name}{self._parameters()} is\n'
                f'   begin\n'
                f'{self._body()}\n'
                f'   end {self.name};')


class IfExpression(SparkRepresentation, LogExpr):
    def __init__(self, condition_expressions: List[Tuple[LogExpr, Expr]],
                 else_expression: str) -> None:
        self.condition_expressions = condition_expressions
        self.else_expression = else_expression

    def __str__(self) -> str:
        result = ''
        for c, e in self.condition_expressions:
            if not result:
                result = '(if {} then {}'.format(c, e)
            else:
                result += ' elsif {} then {}'.format(c, e)
        result += ' else {})'.format(self.else_expression)
        return result

    def specification(self) -> str:
        return str(self)

    def definition(self) -> str:
        return self.specification()

    def simplified(self, facts: Dict[Attribute, MathExpr] = None) -> LogExpr:
        return self

    def symbol(self) -> str:
        raise NotImplementedError


class Statement(SparkRepresentation):
    def specification(self) -> str:
        raise RuntimeError('statement in specification')

    @abstractmethod
    def definition(self) -> str:
        raise NotImplementedError


class Assignment(Statement):
    def __init__(self, name: str, expression: MathExpr) -> None:
        self.name = name
        self.expression = expression

    def definition(self) -> str:
        return f'      {self.name} := {self.expression};'


class PragmaStatement(Statement):
    def __init__(self, name: str, parameters: List[str]) -> None:
        self.name = name
        self.pragma_parameters = parameters

    def definition(self) -> str:
        parameters = ''
        if self.pragma_parameters:
            parameters = ', '.join(self.pragma_parameters)
            parameters = f' ({parameters})'
        return f'      pragma {self.name}{parameters};'


class IfStatement(Statement):
    def __init__(self, condition_statements: List[Tuple[LogExpr, List[Statement]]],
                 else_statements: List[Statement]) -> None:
        self.condition_statements = condition_statements
        self.else_statements = else_statements

    def specification(self) -> str:
        raise RuntimeError('if statement in specification')

    def definition(self) -> str:
        result = ''
        for condition, statements in self.condition_statements:
            if not result:
                result = '      if {} then\n'.format(condition)
            else:
                result += '      elsif {} then\n'.format(condition)
            for statement in statements:
                result += '   {};\n'.format(statement.definition())
        result += '      else\n'
        for statement in self.else_statements:
            result += '   {};\n'.format(statement.definition())
        result += '      end if;'
        return result


class Call(ABC):
    def __init__(self, call: str) -> None:
        self.call = call

    def __repr__(self) -> str:
        return '{}({})'.format(self.__class__.__name__, self.call)

    def __str__(self) -> str:
        return self.call


class MathCall(Call, MathExpr):
    def __init__(self, call: str, negative: bool = False) -> None:
        super().__init__(call)
        self.negative = negative

    def __repr__(self) -> str:
        result = '{}({})'.format(self.__class__.__name__, self.call)
        if self.negative:
            return '(-{})'.format(result)
        return result

    def __neg__(self) -> MathExpr:
        return self.__class__(self.call, not self.negative)

    def __contains__(self, item: MathExpr) -> bool:
        return item == self

    def to_bytes(self) -> MathExpr:
        return self

    def simplified(self, facts: Dict[Attribute, MathExpr] = None) -> MathExpr:
        return self


class LogCall(Call, LogExpr):
    def simplified(self, facts: Dict[Attribute, MathExpr] = None) -> LogExpr:
        return self

    def symbol(self) -> str:
        raise NotImplementedError


class Convert(MathExpr):
    # pylint: disable=too-many-arguments
    def __init__(self, type_name: str, array_name: str, first: MathExpr, last: MathExpr,
                 offset: int = 0, negative: bool = False) -> None:
        self.type_name = type_name
        self.array_name = array_name
        self.first = first
        self.last = last
        self.offset = offset
        self.negative = negative

    def __str__(self) -> str:
        return '{}Convert_To_{} ({} ({} .. {}){})'.format(
            '-1 * ' if self.negative else '',
            self.type_name,
            self.array_name,
            self.first,
            self.last,
            ', {}'.format(self.offset) if self.offset else '')

    def __neg__(self) -> MathExpr:
        return Convert(self.type_name,
                       self.array_name,
                       self.first,
                       self.last,
                       self.offset,
                       not self.negative)

    def __contains__(self, item: MathExpr) -> bool:
        return item == self

    def simplified(self, facts: Dict[Attribute, MathExpr] = None) -> MathExpr:
        return Convert(self.type_name,
                       self.array_name,
                       self.first.simplified(facts),
                       self.last.simplified(facts),
                       self.offset,
                       self.negative)

    def to_bytes(self) -> MathExpr:
        return Convert(self.type_name,
                       self.array_name,
                       self.first.to_bytes(),
                       self.last.to_bytes(),
                       self.offset,
                       self.negative)


class Cast(MathExpr):
    def __init__(self, name: str, expression: MathExpr) -> None:
        self.name = name
        self.expression = expression

    def __repr__(self) -> str:
        return '{} ({})'.format(self.name, self.expression)

    def __neg__(self) -> MathExpr:
        return Cast(self.name, -self.expression)

    def __contains__(self, item: MathExpr) -> bool:
        return item == self

    def simplified(self, facts: Dict[Attribute, MathExpr] = None) -> MathExpr:
        return Cast(self.name, self.expression.simplified(facts))

    def to_bytes(self) -> MathExpr:
        return Cast(self.name, self.expression.to_bytes())


class FalseExpr(LogExpr):
    def __repr__(self) -> str:
        return 'FALSE'

    def __str__(self) -> str:
        return 'False'

    def simplified(self, facts: Dict['Attribute', 'MathExpr'] = None) -> LogExpr:
        return self

    def symbol(self) -> str:
        raise NotImplementedError


FALSE = FalseExpr()


class Generator:
    def __init__(self) -> None:
        self.__units: Dict[str, Unit] = {}

    def generate_dissector(self, pdus: List[PDU]) -> None:
        for pdu in pdus:
            if pdu.package in self.__units:
                top_level_package = self.__units[pdu.package].package
            else:
                top_level_package = Package(pdu.package, [], [])
                self.__units[pdu.package] = Unit([ContextItem('Types', True)],
                                                 top_level_package)

            package = Package(pdu.full_name, [], [])
            self.__units[pdu.full_name] = Unit([], package)

            package.subprograms.extend(
                create_contain_functions())

            seen_types: List[Type] = []
            unreachable_functions: Dict[str, Subprogram] = {}

            facts = {
                First('Message'): First('Buffer'),
                Last('Message'): Mul(Last('Buffer'), Number(8)),
                Length('Message'): Sub(Mul(Last('Buffer'), Number(8)), First('Buffer'))
            }

            fields = pdu.fields(facts, First('Buffer'))
            for field in fields.values():
                if field.type not in seen_types:
                    seen_types.append(field.type)
                    if isinstance(field.type, ModularInteger):
                        top_level_package.types += [ModularType(field.type.name,
                                                                field.type.modulus)]
                    elif isinstance(field.type, RangeInteger):
                        top_level_package.types += [RangeType(field.type.name,
                                                              field.type.first,
                                                              field.type.last,
                                                              field.type.size)]
                    elif isinstance(field.type, Array):
                        if 'Payload' not in field.type.name:
                            raise NotImplementedError('custom arrays are not supported yet')

                valid_variants: List[LogExpr] = []

                for variant_id, variant in field.variants.items():
                    package.subprograms.append(
                        create_variant_validation_function(
                            field,
                            variant_id,
                            variant))

                    package.subprograms.extend(
                        create_variant_accessor_functions(
                            field,
                            variant_id,
                            variant))

                    extend_valid_variants(valid_variants, field, variant_id, variant)

                package.subprograms.append(
                    create_field_validation_function(
                        field.name,
                        valid_variants))

                package.subprograms.extend(
                    create_field_accessor_functions(
                        field))

                extend_unreachable_functions(unreachable_functions, field.type)

            package.subprograms.insert(0, Pragma('Warnings',
                                                 ['On', '"precondition is statically false"']))
            package.subprograms[0:0] = list(unreachable_functions.values())
            package.subprograms.insert(0, Pragma('Warnings',
                                                 ['Off', '"precondition is statically false"']))

            package.subprograms.append(
                create_packet_validation_function(
                    list(fields.values())[-1].name))

    def units(self) -> List[Unit]:
        return list(self.__units.values())


def create_contain_functions() -> List[Subprogram]:
    return [ExpressionFunction('Is_Contained',
                               'Boolean',
                               [('Buffer', 'Bytes')],
                               aspects=[Ghost(), Import()]),
            Procedure('Initialize',
                      [('Buffer', 'Bytes')],
                      [PragmaStatement('Assume', ['Is_Contained (Buffer)'])],
                      aspects=[Postcondition(LogCall('Is_Contained (Buffer)'))])]


def unique(input_list: List) -> List:
    return reduce(lambda l, x: l + [x] if x not in l else l, input_list, [])


def calculate_offset(last: MathExpr) -> int:
    last = last.simplified({First('Buffer'): Number(0)})
    if isinstance(last, Number):
        return (8 - (last.value + 1) % 8) % 8
    # TODO: determine offset for complicated cases
    return 0


def length_constraint(last: MathExpr) -> LogExpr:
    return GreaterEqual(Length('Buffer'),
                        Add(last, -First('Buffer'), Number(1)))


def create_value_to_call(
        field: Field,
        variant_id: str,
        variant: Variant) -> Dict[Attribute, MathExpr]:

    return {Value(field_name): MathCall('{}_{} (Buffer)'.format(field_name, vid))
            for field_name, vid in [(field.name, variant_id)] + variant.previous}


def create_value_to_natural_call(
        field: Field,
        variant_id: str,
        variant: Variant) -> Dict[Attribute, MathExpr]:

    return {Value(field_name): Cast('Natural', MathCall('{}_{} (Buffer)'.format(field_name, vid)))
            for field_name, vid in [(field.name, variant_id)] + variant.previous}


def create_variant_validation_function(
        field: Field,
        variant_id: str,
        variant: Variant) -> Subprogram:

    return ExpressionFunction(
        'Valid_{}_{}'.format(field.name, variant_id),
        'Boolean',
        [('Buffer', 'Bytes')],
        And(LogCall('Valid_{}_{} (Buffer)'.format(variant.previous[-1][0],
                                                  variant.previous[-1][1]))
            if variant.previous else TRUE,
            And(
                length_constraint(
                    variant.facts[Last(field.name)].to_bytes()).simplified(
                        create_value_to_natural_call(
                            field, variant_id, variant)),
                variant.condition.simplified(
                    create_value_to_call(
                        field, variant_id, variant)))
            ).simplified(),
        [Precondition(LogCall('Is_Contained (Buffer)'))])


def create_variant_accessor_functions(
        field: Field,
        variant_id: str,
        variant: Variant) -> List[Subprogram]:

    value_to_natural_call = create_value_to_natural_call(field, variant_id, variant)
    first_byte = variant.facts[First(field.name)].to_bytes().simplified(value_to_natural_call)
    last_byte = variant.facts[Last(field.name)].to_bytes().simplified(value_to_natural_call)
    offset = calculate_offset(variant.facts[Last(field.name)])

    functions: List[Subprogram] = []
    if 'Payload' in field.type.name:
        functions.append(
            ExpressionFunction(
                '{}_{}_First'.format(field.name, variant_id),
                'Natural',
                [('Buffer', 'Bytes')],
                first_byte,
                [Precondition(
                    And(LogCall('Is_Contained (Buffer)'),
                        And(LogCall('Valid_{}_{} (Buffer)'.format(field.name, variant_id)),
                            LessEqual(First('Buffer'),
                                      Sub(Last('Natural'), first_byte).simplified(
                                          {First('Buffer'): Number(0)})))))]))
        functions.append(
            ExpressionFunction(
                '{}_{}_Last'.format(field.name, variant_id),
                'Natural',
                [('Buffer', 'Bytes')],
                last_byte,
                [Precondition(And(LogCall('Is_Contained (Buffer)'),
                                  LogCall('Valid_{}_{} (Buffer)'.format(
                                      field.name, variant_id))))]))
    else:
        functions.append(
            ExpressionFunction(
                '{}_{}'.format(field.name, variant_id),
                field.type.name,
                [('Buffer', 'Bytes')],
                Convert(
                    field.type.name,
                    'Buffer',
                    first_byte,
                    last_byte,
                    offset),
                [Precondition(And(LogCall('Is_Contained (Buffer)'),
                                  LogCall('Valid_{}_{} (Buffer)'.format(
                                      field.name, variant_id))))]))
    return functions


def extend_valid_variants(
        valid_variants: List[LogExpr],
        field: Field,
        variant_id: str,
        variant: Variant) -> None:

    expression: LogExpr = LogCall('Valid_{}_{} (Buffer)'.format(field.name, variant_id))
    if field.condition is not TRUE:
        expression = And(expression, field.condition)
    valid_variants.append(
        expression.simplified({**variant.facts,
                               **create_value_to_call(field, variant_id, variant)}))


def create_field_validation_function(
        field_name: str,
        valid_variants: List[LogExpr]) -> Subprogram:

    expr = valid_variants.pop()
    for e in valid_variants:
        if e is not TRUE:
            expr = Or(expr, e)

    return ExpressionFunction(
        'Valid_{}'.format(field_name),
        'Boolean',
        [('Buffer', 'Bytes')],
        expr,
        [Precondition(LogCall('Is_Contained (Buffer)'))])


def extend_unreachable_functions(
        unreachable_functions: Dict[str, Subprogram],
        field_type: Type) -> None:

    if field_type.name not in unreachable_functions:
        if isinstance(field_type, Array):
            if 'Unreachable_Natural' not in unreachable_functions:
                unreachable_functions['Unreachable_Natural'] = ExpressionFunction(
                    'Unreachable_Natural',
                    'Natural',
                    [],
                    First('Natural'),
                    [Precondition(FALSE)])
        else:
            unreachable_functions[field_type.name] = ExpressionFunction(
                'Unreachable_{}'.format(field_type.name),
                field_type.name,
                [],
                First(field_type.name),
                [Precondition(FALSE)])


def create_field_accessor_functions(field: Field) -> List[Subprogram]:
    functions: List[Subprogram] = []
    if 'Payload' in field.type.name:
        for attribute in ['First', 'Last']:
            functions.append(
                ExpressionFunction(
                    f'{field.name}_{attribute}',
                    'Natural',
                    [('Buffer', 'Bytes')],
                    IfExpression([(LogCall(f'Valid_{field.name}_{variant_id} (Buffer)'),
                                   LogCall(f'{field.name}_{variant_id}_{attribute} (Buffer)'))
                                  for variant_id in field.variants],
                                 'Unreachable_Natural'),
                    [Precondition(And(LogCall('Is_Contained (Buffer)'),
                                      LogCall(f'Valid_{field.name} (Buffer)')))]))

        functions.append(
            Procedure(
                field.name,
                [('Buffer', 'Bytes'),
                 ('First', 'out Natural'),
                 ('Last', 'out Natural')],
                [Assignment('First', MathCall(f'{field.name}_First (Buffer)')),
                 Assignment('Last', MathCall(f'{field.name}_Last (Buffer)'))],
                [Precondition(And(LogCall('Is_Contained (Buffer)'),
                                  LogCall(f'Valid_{field.name} (Buffer)'))),
                 Postcondition(And(Equal(Value('First'),
                                         MathCall(f'{field.name}_First (Buffer)')),
                                   Equal(Value('Last'),
                                         MathCall(f'{field.name}_Last (Buffer)'))))]))

    else:
        functions.append(
            ExpressionFunction(
                field.name,
                field.type.name,
                [('Buffer', 'Bytes')],
                IfExpression([(LogCall(f'Valid_{field.name}_{variant_id} (Buffer)'),
                               MathCall(f'{field.name}_{variant_id} (Buffer)'))
                              for variant_id in field.variants],
                             f'Unreachable_{field.type.name}'),
                [Precondition(And(LogCall('Is_Contained (Buffer)'),
                                  LogCall(f'Valid_{field.name} (Buffer)')))]))

    return functions


def create_packet_validation_function(field_name: str) -> Subprogram:
    return ExpressionFunction(
        'Is_Valid',
        'Boolean',
        [('Buffer', 'Bytes')],
        LogCall('Valid_{} (Buffer)'.format(field_name)),
        [Precondition(LogCall('Is_Contained (Buffer)'))])
