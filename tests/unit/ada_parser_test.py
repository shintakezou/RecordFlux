import pytest

from rflx import ada, ada_parser


@pytest.mark.parametrize(
    ("unit"),
    [
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration("P"),
            body_context=[],
            body=ada.PackageBody("P"),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration("A.B.C"),
            body_context=[],
            body=ada.PackageBody("A.B.C"),
        ),
        ada.PackageUnit(
            declaration_context=[
                ada.Pragma("Style_Checks", [ada.String("N3aAbCdefhiIklnOprStux")]),
                ada.Pragma(
                    "Warnings",
                    [
                        ada.Variable("Off"),
                        ada.String('""Always_Terminates"" is not a valid aspect identifier'),
                    ],
                ),
            ],
            declaration=ada.PackageDeclaration("P"),
            body_context=[],
            body=ada.PackageBody("P"),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration(
                "P",
                aspects=[ada.SparkMode(), ada.AlwaysTerminates(ada.TRUE)],
            ),
            body_context=[],
            body=ada.PackageBody("P"),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration(
                "P",
                declarations=[
                    ada.ModularType("T1", ada.Number(8)),
                    ada.ModularType("T2", ada.Pow(ada.Number(2), ada.Number(8))),
                    ada.ModularType(
                        "T3",
                        ada.Sub(ada.Pow(ada.Number(2), ada.Number(8)), ada.Number(1)),
                    ),
                    ada.ModularType(
                        "T4",
                        ada.Add(ada.Number(1), ada.Number(2), ada.Number(3), ada.Number(4)),
                    ),
                    ada.ModularType(
                        "T5",
                        ada.Sub(
                            ada.Sub(
                                ada.Add(ada.Number(1), ada.Number(2), ada.Number(3), ada.Number(4)),
                                ada.Number(1),
                            ),
                            ada.Number(1),
                        ),
                    ),
                ],
            ),
            body_context=[],
            body=ada.PackageBody("P"),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration(
                "P",
                declarations=[
                    ada.ModularType(
                        "T",
                        ada.Number(8),
                        aspects=[ada.Annotate("GNATprove", "No_Wrap_Around")],
                    ),
                ],
            ),
            body_context=[],
            body=ada.PackageBody("P"),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration(
                "P",
                declarations=[ada.RangeType("T", first=ada.Number(0), last=ada.Number(255))],
            ),
            body_context=[],
            body=ada.PackageBody("P"),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration(
                "P",
                declarations=[
                    ada.ExpressionFunctionDeclaration(
                        specification=ada.FunctionSpecification(
                            identifier="Expr_Function",
                            return_type="T",
                            parameters=[
                                ada.Parameter(["A"], "T1"),
                                ada.Parameter(["B"], "T2"),
                            ],
                        ),
                        expression=ada.IfExpr(
                            condition_expressions=[
                                (
                                    ada.AndThen(
                                        ada.Less(
                                            ada.Variable("Bits"),
                                            ada.Size(ada.Variable("U64")),
                                        ),
                                        ada.Greater(ada.Variable("Bits"), ada.Number(1)),
                                    ),
                                    ada.Less(
                                        ada.Variable("V"),
                                        ada.Pow(ada.Number(2), ada.Variable("Bits")),
                                    ),
                                ),
                            ],
                        ),
                        aspects=[ada.Postcondition(ada.TRUE)],
                    ),
                ],
            ),
            body_context=[],
            body=ada.PackageBody("P"),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration(
                "P",
                declarations=[
                    ada.SubprogramDeclaration(
                        specification=ada.FunctionSpecification(
                            identifier="F",
                            return_type="T",
                        ),
                        aspects=[ada.Precondition(ada.TRUE)],
                    ),
                ],
            ),
            body_context=[],
            body=ada.PackageBody("P"),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration(
                "P",
                declarations=[
                    ada.SubprogramDeclaration(
                        specification=ada.FunctionSpecification(
                            identifier="F",
                            return_type="T",
                            parameters=[
                                ada.Parameter(["P1"], "Boolean"),
                                ada.Parameter(["P2"], "Natural"),
                            ],
                        ),
                        aspects=[
                            ada.Precondition(
                                ada.AndThen(
                                    ada.Call(identifier="Is_Valid", arguments=[ada.Variable("P")]),
                                    ada.Greater(ada.Variable("P2"), ada.Number(42)),
                                ),
                            ),
                        ],
                    ),
                ],
            ),
            body_context=[],
            body=ada.PackageBody("P"),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration(
                "P",
                declarations=[
                    ada.SubprogramDeclaration(
                        specification=ada.FunctionSpecification(
                            identifier="F",
                            return_type="T",
                            parameters=[
                                ada.Parameter(["P1"], "Boolean"),
                                ada.Parameter(["P2"], "Natural"),
                            ],
                        ),
                        aspects=[
                            ada.Precondition(
                                ada.AndThen(
                                    ada.Less(
                                        ada.Variable("Bits"),
                                        ada.Size(ada.Variable("U64")),
                                    ),
                                    ada.Less(
                                        ada.Variable("Amount"),
                                        ada.Size(ada.Variable("U64")),
                                    ),
                                    ada.Call(
                                        "Fits_Into",
                                        [ada.Variable("V"), ada.Variable("Bits")],
                                    ),
                                ),
                            ),
                        ],
                    ),
                ],
            ),
            body_context=[],
            body=ada.PackageBody("P"),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration(
                "P",
                declarations=[
                    ada.SubprogramDeclaration(
                        specification=ada.ProcedureSpecification(
                            identifier="P",
                            parameters=[
                                ada.Parameter(["A_Param"], "T1"),
                                ada.InOutParameter(["B_Param"], "T2"),
                            ],
                        ),
                        aspects=[
                            ada.Postcondition(ada.Equal(ada.Variable("B_Param"), ada.Number(42))),
                        ],
                    ),
                ],
            ),
            body_context=[],
            body=ada.PackageBody("P"),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration(
                "P",
                declarations=[
                    ada.SubprogramDeclaration(
                        specification=ada.FunctionSpecification(
                            identifier="F",
                            parameters=[
                                ada.Parameter(["P"], "T"),
                            ],
                            return_type="T",
                        ),
                        aspects=[
                            ada.Precondition(
                                ada.In(
                                    ada.Variable("T"),
                                    ada.ValueRange(ada.Number(0), ada.Number(42)),
                                ),
                            ),
                        ],
                    ),
                ],
            ),
            body_context=[],
            body=ada.PackageBody("P"),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration(
                "P",
                declarations=[
                    ada.SubprogramDeclaration(
                        specification=ada.FunctionSpecification(
                            identifier="F",
                            parameters=[
                                ada.Parameter(["P"], "T"),
                            ],
                            return_type="T",
                        ),
                        aspects=[
                            ada.Precondition(
                                ada.In(
                                    ada.Variable("T"),
                                    ada.ValueRange(ada.Number(0), ada.Number(42)),
                                ),
                            ),
                        ],
                    ),
                ],
            ),
            body_context=[],
            body=ada.PackageBody(
                "P",
                declarations=[ada.RangeType("T", first=ada.Number(0), last=ada.Number(255))],
            ),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration(
                "P",
                declarations=[
                    ada.SubprogramDeclaration(
                        specification=ada.FunctionSpecification(
                            identifier="F",
                            parameters=[
                                ada.Parameter(["P"], "T"),
                            ],
                            return_type="T",
                        ),
                        aspects=[
                            ada.Precondition(
                                ada.In(
                                    ada.Variable("T"),
                                    ada.ValueRange(ada.Number(0), ada.Number(42)),
                                ),
                            ),
                        ],
                    ),
                ],
            ),
            body_context=[],
            body=ada.PackageBody(
                "P",
                declarations=[
                    ada.SubprogramBody(
                        specification=ada.FunctionSpecification("F", "T"),
                        declarations=[ada.Pragma("Unreferenced", [ada.Variable("X")])],
                        statements=[ada.ReturnStatement(ada.Variable("Y"))],
                    ),
                    ada.ObjectDeclaration(
                        identifiers=["X"],
                        type_identifier="T",
                        expression=ada.Call("F", [ada.Number(32)]),
                        constant=True,
                    ),
                ],
            ),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration("P", declarations=[]),
            body_context=[],
            body=ada.PackageBody(
                "P",
                declarations=[
                    ada.SubprogramBody(
                        specification=ada.ProcedureSpecification("F", [ada.Parameter(["P"], "T")]),
                        declarations=[],
                        statements=[ada.PragmaStatement("Unreferenced", [ada.Variable("P")])],
                    ),
                ],
            ),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration("P", declarations=[]),
            body_context=[],
            body=ada.PackageBody(
                "P",
                declarations=[
                    ada.SubprogramBody(
                        specification=ada.FunctionSpecification(
                            "F",
                            "Boolean",
                            [ada.Parameter(["P"], "T")],
                        ),
                        declarations=[],
                        statements=[
                            ada.IfStatement(
                                condition_statements=[
                                    (
                                        ada.Equal(ada.Variable("P"), ada.Number(42)),
                                        [ada.ReturnStatement(ada.TRUE)],
                                    ),
                                ],
                                else_statements=[ada.ReturnStatement(ada.FALSE)],
                            ),
                        ],
                    ),
                ],
            ),
        ),
        ada.PackageUnit(
            declaration_context=[],
            declaration=ada.PackageDeclaration(
                "P",
                declarations=[
                    ada.SubprogramDeclaration(
                        specification=ada.FunctionSpecification(
                            identifier="F",
                            return_type="T",
                        ),
                        aspects=[
                            ada.Ghost(),
                            ada.Global(),
                            ada.Convention(ada.ConventionKind.Intrinsic),
                            ada.Import(),
                        ],
                    ),
                ],
            ),
            body_context=[],
            body=ada.PackageBody("P"),
        ),
    ],
)
def test_roundtrip(unit: ada.Unit) -> None:
    result = ada_parser.parse(unit.ads + unit.adb)
    assert result.ads == unit.ads
    assert result.adb == unit.adb
