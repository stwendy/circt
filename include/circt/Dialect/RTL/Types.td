//===- Types.td - RTL data type definitions ----------------*- tablegen -*-===//
//
// Basic data types for the RTL dialect.
//
//===----------------------------------------------------------------------===//

// Base class for other typedefs. Provides dialact-specific defaults.
class RTLType<string name> : TypeDef<RTLDialect, name> { }

// A simple fixed size array.
def ArrayType : RTLType<"Array"> {
  let summary = "A fixed-sized array";
  let description = [{
    Fixed sized RTL arrays are roughly similar to C arrays. On the wire (vs.
    in a memory), arrays are always packed. Memory layout is not defined as
    it does not need to be since in silicon there is not implicit memory
    sharing.
  }];

  let mnemonic = "array";
  let parameters = (ins "::mlir::Type":$innerType, "size_t":$size);
  let genVerifyInvariantsDecl = 1;
}

def InOutType : RTLType<"InOut"> {
  let summary = "bidirectional type for ports and wires";
  let description = [{
    InOut type is used for model operations and values that have "connection"
    semantics, instead of typical dataflow behavior.  This is used for wires
    and inout ports in Verilog.
  }];

  let mnemonic = "inout";
  let parameters = (ins "::mlir::Type":$elementType);
  let genVerifyInvariantsDecl = 1;
}
