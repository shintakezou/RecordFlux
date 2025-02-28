# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- Display of message graphs in VS Code (AdaCore/RecordFlux#1307, eng/recordflux/RecordFlux#1838)

## [0.26.0] - 2024-12-18

### Added

- Style check for unsigned integer syntax (eng/recordflux/RecordFlux#1775)
- Support for SPARK Pro 25.0 (eng/recordflux/RecordFlux#1823)
- Support for GNAT Pro 25.0 (eng/recordflux/RecordFlux#1823)
- `rflx doc` subcommand to open packaged HTML documentation (eng/recordflux/RecordFlux#1822)

### Fixed

- Keyword highlighting in GNAT Studio and VS Code (eng/recordflux/RecordFlux#1815)

## [0.25.0] - 2024-11-05

### Added

- Support for Python 3.12 (eng/recordflux/RecordFlux#1806)

### Removed

- Support for Python 3.8 (eng/recordflux/RecordFlux#1359)

### Fixed

- Rejection of invalid parameter types and return types in function declarations (AdaCore/RecordFlux#977, eng/recordflux/RecordFlux#977)
- Consequential errors caused by undefined variables in binary expressions (eng/recordflux/RecordFlux#1672)
- Rejection of variable declarations with type `Opaque` (AdaCore/RecordFlux#633, eng/recordflux/RecordFlux#633)
- Fatal error caused by variable in case expression (eng/recordflux/RecordFlux#1800)
- Simplification of expressions with a unary minus operator (eng/recordflux/RecordFlux#1595, eng/recordflux/RecordFlux#1797)
- Evaluation of unary minus applied to binary expressions (eng/recordflux/RecordFlux#1797)
- Fatal errors caused by missing locations (eng/recordflux/RecordFlux#1785)

### Changed

- Remove unused `Buffer` arguments in generated code (eng/recordflux/RecordFlux#1802)
- Remove unnecessary part of `Valid_Context` predicate (eng/recordflux/RecordFlux#1802)

## [0.24.0] - 2024-09-12

### Added

- Vim and Neovim syntax highlighting support (eng/recordflux/RecordFlux#1749)
- Project file support in code optimizer (eng/recordflux/RecordFlux#1766)
- Shorthand syntax for unsigned integer types (eng/recordflux/RecordFlux#1398)

### Changed

- CLI subcommand `rflx optimize` expects project file instead of directory containing generated code (eng/recordflux/RecordFlux#1766)
- Improve generation of predicate for single-field messages (eng/recordflux/RecordFlux#1761)
- Rename Session to State Machine in documentation (eng/recordflux/RecordFlux#1772)
- Rename `session` keyword to `machine` in specifications (eng/recordflux/RecordFlux#1772)
- Rename `Session` keyword to `Machine` in integration files (eng/recordflux/RecordFlux#1772)
- Rename `*_Functions.Context` to `*_Environment.State` to prevent confusions (eng/recordflux/RecordFlux#1769)
- Exception transitions are required in more cases as result of fixing missing checks in state machine (eng/recordflux/RecordFlux#1704)

### Removed

- CLI flag `--optimize` of `rflx generate` subcommand (eng/recordflux/RecordFlux#1766)
- CLI option `--timeout` of `rflx generate` and `rflx optimize` subcommands (eng/recordflux/RecordFlux#1766)
- `Initialize` and `Finalize` functions for session functions context (eng/recordflux/RecordFlux#1768)

### Fixed

- Generation of uncompilable code for messages with variable as field condition (eng/recordflux/RecordFlux#1762)
- Missing checks in state machine to improve provability (eng/recordflux/RecordFlux#1704)
- Copying of sequence fields for external IO buffers (eng/recordflux/RecordFlux#1704)
- Syntax highlighting for identifiers with numbers or keywords (AdaCore/RecordFlux#1301, eng/recordflux/RecordFlux#1776)
- Fatal errors caused by missing locations after proof timeouts (eng/recordflux/RecordFlux#1782)
- Fatal errors when generating code for list comprehensions without condition or `True` condition (AdaCore/RecordFlux#1302, eng/recordflux/RecordFlux#1786)

## [0.23.0] - 2024-08-23

### Changed

- Enhance diagnostics when a message parameter is not a scalar (eng/recordflux/RecordFlux#1740)
- Improve diagnostics phrasing (eng/recordflux/RecordFlux#1714)
- Enhance diagnostics when a message field and its type have a size aspect (eng/recordflux/RecordFlux#1746)

### Fixed

- Generic setters for opaque fields
- Separation of externally defined functions from state machine (AdaCore/RecordFlux#1032, eng/recordflux/RecordFlux#1032)
- Missing checks in state machine to improve provability (eng/recordflux/RecordFlux#1704)

## [0.22.0] - 2024-07-17

### Added

- Support for FSF GNAT 14.1 (eng/recordflux/RecordFlux#1679)
- New error message format (eng/recordflux/RecordFlux#1582)
- CLI flag `--legacy-errors` to restore previous error message format (eng/recordflux/RecordFlux#1685)
- Info message for skipped verifications (eng/recordflux/RecordFlux#1723)
- Possibility to use externally defined IO buffers in state machines (eng/recordflux/RecordFlux#1496)

### Changed

- Display message fields involved in a cycle (AdaCore/RecordFlux#256, eng/recordflux/RecordFlux#256)
- Software license from AGPL-3.0 to Apache-2.0 (eng/recordflux/RecordFlux#1671)
- LLVM exception in addition to Apache-2.0 for generated code (eng/recordflux/RecordFlux#1671)
- Cache directory from `$HOME/.cache/RecordFlux` to `$PWD/.rflx_cache` (eng/recordflux/RecordFlux#1723)
- Severities of error messages (eng/recordflux/RecordFlux#1698, eng/recordflux/RecordFlux#1685, eng/recordflux/RecordFlux#1701)
- Improve suggestions when a package name is not correct (eng/recordflux/RecordFlux#1611)
- Improve several error messages (eng/recordflux/RecordFlux#1638, eng/recordflux/RecordFlux#1648, eng/recordflux/RecordFlux#1660, eng/recordflux/RecordFlux#1661, eng/recordflux/RecordFlux#1662, eng/recordflux/RecordFlux#1663, eng/recordflux/RecordFlux#1681, eng/recordflux/RecordFlux#1703, eng/recordflux/RecordFlux#1708, eng/recordflux/RecordFlux#1713, eng/recordflux/RecordFlux#1720, eng/recordflux/RecordFlux#1721)
- Improve implementation of `Field_First_Internal` function (eng/recordflux/RecordFlux#1707, eng/recordflux/RecordFlux#1706)

### Fixed

- Bug box for aspect without expression (eng/recordflux/RecordFlux#1555, eng/recordflux/RecordFlux#1559)
- Bug box for division and modulo by 0 in numeric expression (eng/recordflux/RecordFlux#1556)
- Bug box for unary - preceding unary + in expression (eng/recordflux/RecordFlux#1558)
- Bug box for missing operand (eng/recordflux/RecordFlux#1560)
- Bug box for negated expressions (eng/recordflux/RecordFlux#1561, eng/recordflux/RecordFlux#1569)
- Bug box for duplicated operator (eng/recordflux/RecordFlux#1562)
- Bug box for link to missing field (eng/recordflux/RecordFlux#1566)
- Show bug box on fatal errors in the language server (eng/recordflux/RecordFlux#1666)
- Infinite recursion for duplicate declaration (eng/recordflux/RecordFlux#1557)
- Corruption of verification cache (eng/recordflux/RecordFlux#1655, eng/recordflux/RecordFlux#1718)

## [0.21.0] - 2024-04-23

### Changed

- Improve error messages for type refinements of non-message types (AdaCore/RecordFlux#383, eng/recordflux/RecordFlux#383)

### Fixed

- Generation of uncompilable code in the presence of some Boolean conditions (eng/recordflux/RecordFlux#1365)
- Exception when checking specification in GNAT Studio (eng/recordflux/RecordFlux#1492)

## [0.20.0] - 2024-03-26

### Added

- Possibility to use multiple initial links in messages to allow the first message field to be defined by parameter values (AdaCore/RecordFlux#764, eng/recordflux/RecordFlux#764)

### Changed

- Improve performance of code optimizer (requires SPARK 25; eng/recordflux/RecordFlux#1533)
- Improve error message when package name matches source file name but the casing isn't correct (eng/recordflux/RecordFlux#1554)

### Fixed

- Parsing of messages that depend on fraction comparisons in PyRFLX (AdaCore/RecordFlux#981, eng/recordflux/RecordFlux#981)
- Installation of VS Code extension (eng/recordflux/RecordFlux#1544)

## [0.19.0] - 2024-02-29

### Added

- Prevent different casings for same entity (AdaCore/RecordFlux#563, eng/recordflux/RecordFlux#563)
- Code optimizer that removes unnecessary checks in generated state machine code (eng/recordflux/RecordFlux#1525)

### Fixed

- Unexpected errors when using different casings for same entity (AdaCore/RecordFlux#562, eng/recordflux/RecordFlux#1506)

## [0.18.0] - 2024-01-30

### Added

- Pragma marking all generated files as Ada 2012 (AdaCore/RecordFlux#1293, eng/recordflux/RecordFlux#1509)
- `--no-caching` option to `rflx` (eng/recordflux/RecordFlux#1488)
- Model verification caching to validator

### Changed

- Insert/Extract functions accept Byte array instead of access type (eng/recordflux/RecordFlux#1515)

### Fixed

- Various inaccuracies in Language Reference (AdaCore/RecordFlux#958, eng/recordflux/RecordFlux#958)
- Erroneous acceptance of consecutive / trailing underscores (eng/recordflux/RecordFlux#1468)
- Fatal error when digit in numeric literal exceeds base (eng/recordflux/RecordFlux#1469)
- Fatal error when unsupported base is used in numeric literal (eng/recordflux/RecordFlux#1470)
- Missing diagnostics provided by language server
- `--split-disjunctions` options of `rflx validate`
- Misleading CLI output about verification (AdaCore/RecordFlux#1295, eng/recordflux/RecordFlux#1522)

## [0.17.0] - 2024-01-03

### Fixed

- Fatal error when comparing opaque fields (AdaCore/RecordFlux#1294, eng/recordflux/RecordFlux#1497)
- Fatal error when GraphViz is missing (eng/recordflux/RecordFlux#1499)
- Missing rejection of sequences of parameterized messages (eng/recordflux/RecordFlux#1439)

### Removed

- Verification of message bit coverage (eng/recordflux/RecordFlux#1495)

## [0.16.0] - 2023-12-05

### Added

- Support for FSF GNAT 13.2 (eng/recordflux/RecordFlux#1458)
- `--reproducible` option to `rflx generate` and `rflx convert` (eng/recordflux/RecordFlux#1489)

### Changed

- Improve parallelization of message verification (AdaCore/RecordFlux#444, eng/recordflux/RecordFlux#444)
- Improve message verification (AdaCore/RecordFlux#420, AdaCore/RecordFlux#1090, eng/recordflux/RecordFlux#420, eng/recordflux/RecordFlux#1090, eng/recordflux/RecordFlux#1476)

### Fixed

- Proving of validity of message field after update with valid sequence (eng/recordflux/RecordFlux#1444)
- Style check warnings for license header (AdaCore/RecordFlux#1293, eng/recordflux/RecordFlux#1461)

## [0.15.0] - 2023-11-08

### Added

- Support for SPARK Pro 24.0 (eng/recordflux/RecordFlux#1409)
- Support for GNAT Pro 24.0 (eng/recordflux/RecordFlux#1443)

### Changed

- Syntax for passing repeated `-i` and `-v` options to `rflx validate` (eng/recordflux/RecordFlux#1441)
- Simplify setter code and remove internal `Successor` function (eng/recordflux/RecordFlux#1448)
- Improve names of enum literals generated from IANA registries (eng/recordflux/RecordFlux#1451)

### Fixed

- Fatal errors caused by condition on message type field (AdaCore/RecordFlux#1291, eng/recordflux/RecordFlux#1438)

### Removed

- Support for SPARK Pro Wavefront 20230905 (eng/recordflux/RecordFlux#1409)
- Short form field conditions (eng/recordflux/RecordFlux#617)

## [0.14.0] - 2023-09-26

### Added

- Functions `Valid_Next_Internal`, `Field_Size_Internal`, `Field_First_Internal` (eng/recordflux/RecordFlux#1382)
- `rflx validate` `-v` and `-i` options accept multiple directories (eng/recordflux/RecordFlux#1393)
- `rflx validate` `-v` and `-i` options accept also files (eng/recordflux/RecordFlux#1418)
- Caching of successful verification of derived messages and refinements (eng/recordflux/RecordFlux#1421)

### Changed

- Removed `Predecessor` field from `Field_Cursor` record (eng/recordflux/RecordFlux#1387)
- Improve stability and performance of language server (eng/recordflux/RecordFlux#1417)
- Improve performance of model verification

### Fixed

- Code generation for accesses to optional fields whose presence is ensured by a condition (eng/recordflux/RecordFlux#1420)
- Error when passing checksum module to validator on the command line

### Removed

- Functions `Valid_Predecessor` and `Path_Condition` (eng/recordflux/RecordFlux#1382)

## [0.13.0] - 2023-09-13

### Added

- Support for SPARK Pro Wavefront 20230905 (eng/recordflux/RecordFlux#1403, eng/recordflux/RecordFlux#1409)

### Changed

- Reject duplicate optional arguments in `rflx` CLI (eng/recordflux/RecordFlux#1342)
- Split the `Valid_Context` into multiple functions (eng/recordflux/RecordFlux#1385)
- IANA registries with unsupported content are skipped with a warning (eng/recordflux/RecordFlux#1406)

### Removed

- Support for GNAT Pro 20.2 and GNAT Community 2020 (eng/recordflux/RecordFlux#1403)
- Support for SPARK Pro 23.1 (eng/recordflux/RecordFlux#1403)

## [0.12.0] - 2023-08-22

### Added

- Language server (eng/recordflux/RecordFlux#1355)
- VS Code extension (eng/recordflux/RecordFlux#1355)
- Support for GNAT Pro 23.2
- Logging of required runtime checks during code generation (AdaCore/RecordFlux#1204, eng/recordflux/RecordFlux#1204)

### Changed

- Prevent unnecessary runtime checks in generated code (AdaCore/RecordFlux#1204, eng/recordflux/RecordFlux#1204)
- Removal of discriminant in `Field_Cursor` type (eng/recordflux/RecordFlux#1377)

### Fixed

- Missing quotes in error messages about invalid aspects (AdaCore/RecordFlux#1267, eng/recordflux/RecordFlux#1267)
- Subsequent errors caused by style errors (AdaCore/RecordFlux#1268, eng/recordflux/RecordFlux#1268)
- Missing type checking in refinement conditions (eng/recordflux/RecordFlux#1360)
- Exception caused by comparing integer field to aggregate (AdaCore/RecordFlux#1251, eng/recordflux/RecordFlux#1251)
- Unexpected errors when using `--max_errors=1` (AdaCore/RecordFlux#825, eng/recordflux/RecordFlux#825)
- Incorrect detection of conditions as always true for enumerations with `Always_Valid` aspect (AdaCore/RecordFlux#1276, eng/recordflux/RecordFlux#1276)
- Potential name conflicts with internally used identifiers that start with `RFLX_` (AdaCore/RecordFlux#638, eng/recordflux/RecordFlux#638)
- Deadlocks during verification caused by forked processes (eng/recordflux/RecordFlux#1366)

## [0.11.1] - 2023-07-14

### Fixed

- Caching of successful verification (eng/recordflux/RecordFlux#1345)
- Locations of message fields and field sizes in error messages (eng/recordflux/RecordFlux#1349)
- Invalid use of First aspect that led to overlay of multiple fields (eng/recordflux/RecordFlux#1332)
- Update of message field with invalid sequence (eng/recordflux/RecordFlux#1353)
- Detection of negative field size (eng/recordflux/RecordFlux#1357)

## [0.11.0] - 2023-06-16

### Removed

- Support for installing RecordFlux package with GNAT Pro 20, GNAT Pro 21 and GNAT Community 2020 (eng/recordflux/RecordFlux#1335)

## [0.10.0] - 2023-05-24

### Changed

- Allow update of generated files (AdaCore/RecordFlux#1275, eng/recordflux/RecordFlux#1275)
- Integrate parser into RecordFlux package (eng/recordflux/RecordFlux#1316)
- Simplify shape of the `Valid_Context` predicate (eng/recordflux/SparkFlux#11)
- Remove unneeded postcondition of setters (eng/recordflux/RecordFlux#1330)

### Fixed

- Installation of GNAT Studio plugin (eng/recordflux/RecordFlux#1293)
- Order of types and sessions after parsing (AdaCore/RecordFlux#1076, eng/recordflux/RecordFlux#1076)
- Strict dependency on specific versions of shared libraries (eng/recordflux/RecordFlux#1316)
- Displaying of graphs in GNAT Studio (AdaCore/RecordFlux#1169, eng/recordflux/RecordFlux#1169)

## [0.9.1] - 2023-03-28

### Fixed

- Missing with clause in session package for indirectly used enumeration types (eng/recordflux/RecordFlux#1298)
- Compilation error for message field access in state transition (eng/recordflux/RecordFlux#1299)
- Warning about that `with RFLX.RFLX_Types` is unreferenced or might be moved to body of session package

## [0.9.0] - 2023-01-06

### Added

- Support for Python 3.11

### Removed

- Bindings (AdaCore/RecordFlux#724)

## [0.8.0] - 2022-12-02

### Changed

- Rename `Structural_Valid` to `Well_Formed` (AdaCore/RecordFlux#986)
- Reject statically true conditions in messages (AdaCore/RecordFlux#662)
- Reject statically false and true refinement conditions (AdaCore/RecordFlux#662)

### Removed

- Modular integer types (AdaCore/RecordFlux#727)

### Fixed

- Exception transition rejected on message assignment (AdaCore/RecordFlux#1144)
- Document where type derivations and sequence types are valid (AdaCore/RecordFlux#1235)

## [0.7.1] - 2022-11-04

### Fixed

- Exception when using a boolean value as condition (AdaCore/RecordFlux#776)

## [0.7.0] - 2022-10-04

### Added

- CLI:
    - `rflx setup_ide` subcommand for installing IDE integration (AdaCore/RecordFlux#795)
    - `rflx` option `--unsafe` (AdaCore/RecordFlux#987)
    - `rflx convert` subcommand for converting foreign specifications
    - `rflx convert iana` subcommand for converting IANA "Service Name and Transport Protocol Port Number Registry" XML files (AdaCore/RecordFlux#708)
- Model:
    - Detection of unused parameters (AdaCore/RecordFlux#874)
    - Detection of invalid use of literals in expressions (AdaCore/RecordFlux#686, AdaCore/RecordFlux#1194)

### Changed

- Specification:
    - Syntax for defining initial and final states of session (AdaCore/RecordFlux#700)
- Model:
    - Change representation of null messages (AdaCore/RecordFlux#643)
- Generator:
    - Style of Ada comments (AdaCore/RecordFlux#816)
    - Detect when a generated file would overwrite an existing file (AdaCore/RecordFlux#993)
    - Move operators and operations on types into separate child packages (AdaCore/RecordFlux#1126)

### Removed

- Specification:
    - Private types (AdaCore/RecordFlux#1156)

### Fixed

- Non-null state accepted as final state (AdaCore/RecordFlux#1130)
- Spurious error if providing specifications in certain order (AdaCore/RecordFlux#759)
- Handling of specification dependencies when using multiple directories

## [0.6.0] - 2022-08-31

### Added

- Parameterized messages (AdaCore/RecordFlux#609, AdaCore/RecordFlux#743)
- Endianness (AdaCore/RecordFlux#104, AdaCore/RecordFlux#914)
- Validator (AdaCore/RecordFlux#560)
- Parallelization of Z3 proofs and code generation (AdaCore/RecordFlux#625, AdaCore/RecordFlux#976)
- Simple specification style checker (AdaCore/RecordFlux#799)
- Integration files for defining buffer sizes of messages and sequences in sessions (AdaCore/RecordFlux#713)
- Memory management in sessions to avoid use of heap (AdaCore/RecordFlux#629)
- Setting of single message fields (AdaCore/RecordFlux#1067)
- Case expressions (AdaCore/RecordFlux#907)
- Optimization and support for Head attributes on list comprehensions (AdaCore/RecordFlux#1115)
- Specification:
    - Enable deactivation of style checks for individual files (AdaCore/RecordFlux#1079)
- CLI:
    - `rflx` option `--max-errors NUM` (AdaCore/RecordFlux#748)
    - `rflx` option `--workers NUM` for setting the maximum number of parallel processes which are used for model verification (AdaCore/RecordFlux#755)
    - `rflx generate` option `--integration-files-dir` (AdaCore/RecordFlux#713)
    - `rflx generate` option `--debug {built-in,external}` (AdaCore/RecordFlux#1052)
- Generator:
    - Function for getting current state of session (AdaCore/RecordFlux#796)
    - Support for `No_Secondary_Stack` restriction (AdaCore/RecordFlux#911)
    - Possibility for externally defined debug output function in generated code (AdaCore/RecordFlux#1052)
    - Compatibility of generated code to FSF GNAT 11, 12 and GNAT Pro 23 (AdaCore/RecordFlux#674, AdaCore/RecordFlux#905, AdaCore/RecordFlux#1015, AdaCore/RecordFlux#1116)
    - Backward compatibility of generated code to GNAT Community 2020 and GNAT Pro 20 (AdaCore/RecordFlux#896)
- Python dependency `ruamel.yaml`
- Support for Python 3.10

### Changed

- CLI:
    - Make `rflx` option `--no-verification` global (AdaCore/RecordFlux#750)
- Specification / Model:
    - `Model.__init__` now considers all type dependencies (AdaCore/RecordFlux#1074)
    - Rename `then` to `goto` in session states (AdaCore/RecordFlux#738)
    - Allow omitting the size aspect for opaque and sequence fields which are the last field of the message (AdaCore/RecordFlux#736)
    - Allow use of `Message'Last` and `Message'Size` only in conditions of the last fields of the message (AdaCore/RecordFlux#736)
    - Enable use of `Opaque` attribute for arguments of function calls and on sequences (AdaCore/RecordFlux#984, AdaCore/RecordFlux#1021)
    - Keep multiple message versions in verification cache (AdaCore/RecordFlux#1028)
    - Improve generation of specification files for model (AdaCore/RecordFlux#1009, AdaCore/RecordFlux#1022)
    - Detect duplicate aspects (AdaCore/RecordFlux#714)
- Generator:
    - Improve binary size of generated code (AdaCore/RecordFlux#908)
    - Use tagged types instead of generic packages for sessions (AdaCore/RecordFlux#768)
    - Change channel interface in generated code (AdaCore/RecordFlux#766, AdaCore/RecordFlux#807)
    - Improve handling of bounds in message contexts (AdaCore/RecordFlux#844)
    - Optimize provability of generated code (AdaCore/RecordFlux#806, AdaCore/RecordFlux#840, AdaCore/RecordFlux#938, AdaCore/RecordFlux#975)
    - Relax length precondition of `To_Context` (AdaCore/RecordFlux#1054)
    - Enable comprehensions with message sequence as target (AdaCore/RecordFlux#891)
    - Add precondition `Uninitialized` to procedure `Initialize` (AdaCore/RecordFlux#788)
    - Add operators for `Length` and `Index` types (AdaCore/RecordFlux#1070)
    - Overwrite symlinks when creating files
    - Make `In_IO_State` session function public (AdaCore/RecordFlux#1155)
    - Generate improved code for messages with reduced feature usage (AdaCore/RecordFlux#1114)
- PyRFLX:
    - Remove `__getitem__` (AdaCore/RecordFlux#783)
- Graph:
    - Improve layout of session graphs (AdaCore/RecordFlux#400)

### Removed

- Support for Python 3.7

### Fixed

- Installation of parser when installing RecordFlux from PyPI (AdaCore/RecordFlux#745)
- Examples in README (AdaCore/RecordFlux#879)
- Model:
    - Handling of `Message` attributes in message types (AdaCore/RecordFlux#729)
    - Missing file location in error messages (AdaCore/RecordFlux#647)
    - Bug box due to dangling field when merging messages (AdaCore/RecordFlux#1033)
    - Missing type information in `Reset` statement (AdaCore/RecordFlux#1080)
    - Incorrect message size calculation if size depends on variables (AdaCore/RecordFlux#1064)
- Generator:
    - Error when using `Boolean` as return type of function (AdaCore/RecordFlux#752)
    - Error when using unqualified type as return type of function (AdaCore/RecordFlux#892)
    - Bugbox when using `Reset` attribute on a sequence while running without optimization (AdaCore/RecordFlux#946)
    - Generation of use clauses for sessions (AdaCore/RecordFlux#757)
    - Missing type conversions in generated code (AdaCore/RecordFlux#761, AdaCore/RecordFlux#902, AdaCore/RecordFlux#965)
    - Code generation for:
        - `Boolean` as function parameter (AdaCore/RecordFlux#882)
        - Message aggregates (AdaCore/RecordFlux#770)
        - Use of messages with single opaque field in sessions (AdaCore/RecordFlux#888)
        - Function calls in sessions (AdaCore/RecordFlux#763)
        - Mathematical expressions with intermediate values outside type range (AdaCore/RecordFlux#726)
        - Logical expressions in assignments (AdaCore/RecordFlux#1012)
        - Boolean relations containing global variables (AdaCore/RecordFlux#1059)
        - Minimal session (AdaCore/RecordFlux#883)
        - Message aggregates with variables as field values (AdaCore/RecordFlux#1064)
        - Message fields with a sequence type name equal to the package name
    - Code generation when using non-default prefix (AdaCore/RecordFlux#897)
    - Conversion between message `Structure` and `Context` (AdaCore/RecordFlux#961)
    - Missing reset in assignment to comprehension (AdaCore/RecordFlux#1050)
    - Message size calculation for message aggregates (AdaCore/RecordFlux#1042)
    - Initialization of session context (AdaCore/RecordFlux#954)
    - Unprovable VC with some user conditions on fields (AdaCore/RecordFlux#995)
- PyRFLX:
    - Error caused by relations between sequences, opaque fields or aggregates (AdaCore/RecordFlux#964)
    - Undefined attribute in `MessageValue.Field` (AdaCore/RecordFlux#1045)
    - Missing type check for arguments of parameterized message (AdaCore/RecordFlux#1104)

## [0.5.0] - 2021-08-11

### Added

- Preview Features:
    - Message checksums (AdaCore/RecordFlux#222, AdaCore/RecordFlux#240)
    - Protocol sessions (AdaCore/RecordFlux#47, AdaCore/RecordFlux#291, AdaCore/RecordFlux#292, AdaCore/RecordFlux#675)
- General:
    - Achieve "Passing" level of CII Best Practices Badge Program (AdaCore/RecordFlux#660)
    - Enforce 100% test coverage (AdaCore/RecordFlux#334)
    - Show bug box on fatal errors (AdaCore/RecordFlux#607, AdaCore/RecordFlux#655)
    - Add ping example app (AdaCore/RecordFlux#366)
    - Improve language reference (AdaCore/RecordFlux#703)
    - Support showing message graphs in GNAT Studio (AdaCore/RecordFlux#345)
- Specification / Model:
    - Improve specification parser (AdaCore/RecordFlux#547, AdaCore/RecordFlux#572)
    - Change syntax of message types (AdaCore/RecordFlux#380, AdaCore/RecordFlux#432, AdaCore/RecordFlux#421), sequence types (AdaCore/RecordFlux#528) and package separators (AdaCore/RecordFlux#441)
    - Enable specification of field conditions (AdaCore/RecordFlux#95, AdaCore/RecordFlux#617)
    - Add modulo operation (AdaCore/RecordFlux#476)
    - Enable use of size of static types in expressions (AdaCore/RecordFlux#384, AdaCore/RecordFlux#480)
    - Add static type checking of expressions (AdaCore/RecordFlux#87)
    - Fix message verification (AdaCore/RecordFlux#388, AdaCore/RecordFlux#389, AdaCore/RecordFlux#410, AdaCore/RecordFlux#413, AdaCore/RecordFlux#492, AdaCore/RecordFlux#497, AdaCore/RecordFlux#520, AdaCore/RecordFlux#522, AdaCore/RecordFlux#530, AdaCore/RecordFlux#579)
    - Add caching of verification result of message specifications (AdaCore/RecordFlux#442)
- SPARK Code Generation:
    - Switch from GNAT Community 2020 to GNAT Community 2021 (AdaCore/RecordFlux#494)
    - Fix code generation (AdaCore/RecordFlux#375, AdaCore/RecordFlux#479, AdaCore/RecordFlux#486, AdaCore/RecordFlux#356, AdaCore/RecordFlux#500, AdaCore/RecordFlux#536, AdaCore/RecordFlux#530, AdaCore/RecordFlux#593, AdaCore/RecordFlux#665)
    - Change API of generated code (AdaCore/RecordFlux#487, AdaCore/RecordFlux#514, AdaCore/RecordFlux#548, AdaCore/RecordFlux#557, AdaCore/RecordFlux#659)
- PyRFLX:
    - Enable type checking in external applications (AdaCore/RecordFlux#393)
    - Change API (AdaCore/RecordFlux#406, AdaCore/RecordFlux#423, AdaCore/RecordFlux#467, AdaCore/RecordFlux#529, AdaCore/RecordFlux#510)
    - Fix message parsing and serialization (AdaCore/RecordFlux#407, AdaCore/RecordFlux#503, AdaCore/RecordFlux#531, AdaCore/RecordFlux#533, AdaCore/RecordFlux#525, AdaCore/RecordFlux#606, AdaCore/RecordFlux#559, AdaCore/RecordFlux#624)
    - Improve performance (AdaCore/RecordFlux#344)
- New Dependencies:
    - Python >=3.7
    - attrs
    - GNAT Community 2021 (GNAT compiler and SPARK verification tools)

## [0.4.1] - 2020-07-23

### Added

- Specification / Model:
    - Improve error messages (AdaCore/RecordFlux#248)
    - Add GNAT Studio integration (AdaCore/RecordFlux#243)
    - Add more checks for invalid models (AdaCore/RecordFlux#282, AdaCore/RecordFlux#288, AdaCore/RecordFlux#298, AdaCore/RecordFlux#309, AdaCore/RecordFlux#310, AdaCore/RecordFlux#311, AdaCore/RecordFlux#313, AdaCore/RecordFlux#336, AdaCore/RecordFlux#338)
    - Fix erroneously rejected specifications (AdaCore/RecordFlux#277, AdaCore/RecordFlux#347, AdaCore/RecordFlux#351)
    - Improve parsing performance (AdaCore/RecordFlux#305)
- SPARK Code Generation:
    - Allow use of scalars up to 64 bit (AdaCore/RecordFlux#238)
    - Prevent potentially failing code compilation (AdaCore/RecordFlux#312, AdaCore/RecordFlux#314, AdaCore/RecordFlux#315, AdaCore/RecordFlux#316, AdaCore/RecordFlux#319, AdaCore/RecordFlux#320, AdaCore/RecordFlux#329, AdaCore/RecordFlux#349)
    - Allow setting empty sequence field (AdaCore/RecordFlux#353)
    - Fix comparison of field values with aggregate (AdaCore/RecordFlux#328)
    - Improve verifiability of accesses to opaque fields (AdaCore/RecordFlux#287)
    - Fix handling of empty prefixes (AdaCore/RecordFlux#266)
- PyRFLX:
    - Improve performance (AdaCore/RecordFlux#254)
    - Fix determining of predecessor field (AdaCore/RecordFlux#289)
    - Fix handling of prefixed literals (AdaCore/RecordFlux#346)

## [0.4.0] - 2020-06-02

### Added

- Introduce PyRFLX - a Python library for rapid-prototyping and validation
    - Based on RecordFlux message specifications
    - Allows parsing and generation of messages
    - Validates formal specification at runtime
- Introduce design-by-contract programming in Python code using icontract
- Specification / Model:
    - Allow import of types of other packages
    - Allow use of message types as field types
    - Add built-in Boolean type
    - Support aggregates and strings
    - Allow comparisons of arrays to aggregates in conditions
- SPARK Code Generation:
    - Allow use of custom buffer type
    - Support for GNAT Community 2020 (GNAT compiler and SPARK verification tools)
- Python dependency `icontract` (library for design by contract)

### Changed

- Specification / Model:
    - Simplify derived types by removing inheritance of refinements
    - Improve detection of error cases
    - Improve error messages
    - Fix incorrect parsing of mathematical expressions
    - Rename Payload to Opaque in specifications

### Removed

- Need for SPARK Pro for verification
- Support for GNAT Community 2019

## [0.3.0] - 2020-01-24

### Added

- Generation of message generator
- Verification of message specifications
- Generation of graph from message specification
- Python dependency PyDotPlus (used for generation of graphs)
- Python dependency Z3 (used for verification of message specifications)

### Changed

- Incorrect handling of absolute file paths
- Minimum required version of PyParsing increased to 2.4.0
- Minimum required version of SPARK verification tools changed to Pro 20.0 (known issues will be resolved in GNAT Community 2020)

## [0.2.0] - 2019-09-16

## [0.1.0] - 2019-05-14

[Unreleased]: https://github.com/AdaCore/RecordFlux/compare/v0.26.0...HEAD
[0.26.0]: https://github.com/AdaCore/RecordFlux/compare/v0.25.0...v0.26.0
[0.25.0]: https://github.com/AdaCore/RecordFlux/compare/v0.24.0...v0.25.0
[0.24.0]: https://github.com/AdaCore/RecordFlux/compare/v0.23.0...v0.24.0
[0.23.0]: https://github.com/AdaCore/RecordFlux/compare/v0.22.0...v0.23.0
[0.22.0]: https://github.com/AdaCore/RecordFlux/compare/v0.21.0...v0.22.0
[0.21.0]: https://github.com/AdaCore/RecordFlux/compare/v0.20.0...v0.21.0
[0.20.0]: https://github.com/AdaCore/RecordFlux/compare/v0.19.0...0.20.0
[0.19.0]: https://github.com/AdaCore/RecordFlux/compare/v0.18.0...v0.19.0
[0.18.0]: https://github.com/AdaCore/RecordFlux/compare/v0.17.0...v0.18.0
[0.17.0]: https://github.com/AdaCore/RecordFlux/compare/v0.16.0...v0.17.0
[0.16.0]: https://github.com/AdaCore/RecordFlux/compare/v0.15.0...v0.16.0
[0.15.0]: https://github.com/AdaCore/RecordFlux/compare/v0.14.0...v0.15.0
[0.14.0]: https://github.com/AdaCore/RecordFlux/compare/v0.13.0...v0.14.0
[0.13.0]: https://github.com/AdaCore/RecordFlux/compare/v0.12.0...v0.13.0
[0.12.0]: https://github.com/AdaCore/RecordFlux/compare/v0.11.1...v0.12.0
[0.11.1]: https://github.com/AdaCore/RecordFlux/compare/v0.11.0...v0.11.1
[0.11.0]: https://github.com/AdaCore/RecordFlux/compare/v0.10.0...v0.11.0
[0.10.0]: https://github.com/AdaCore/RecordFlux/compare/v0.9.1...v0.10.0
[0.9.1]: https://github.com/AdaCore/RecordFlux/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/AdaCore/RecordFlux/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/AdaCore/RecordFlux/compare/v0.7.1...v0.8.0
[0.7.1]: https://github.com/AdaCore/RecordFlux/compare/v0.7.0...v0.7.1
[0.7.0]: https://github.com/AdaCore/RecordFlux/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/AdaCore/RecordFlux/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/AdaCore/RecordFlux/compare/v0.4.1...v0.5.0
[0.4.1]: https://github.com/AdaCore/RecordFlux/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/AdaCore/RecordFlux/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/AdaCore/RecordFlux/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/AdaCore/RecordFlux/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/AdaCore/RecordFlux/compare/29a292a794af58d29ee0d499e74f3d86b73309fa...v0.1.0
