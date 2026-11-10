# Formal Specification of Floating-Point Reassociation Validation

## 1. Objective

Develop an extension to MLIR-TV capable of validating floating-point reassociation transformations while considering local `fastmath` permissions.

## 2. Validation Semantics

Let P be the original program (`src`) and Q be the optimized program (`tgt`).

We define `P =>_R Q` to mean that Q can be obtained from P through a sequence of transformations authorized by a set of rules R.

The validity of a reassociation does not necessarily require numerical equivalence between P and Q under IEEE-754 semantics.

However, all transformations must respect local permissions and preserve the semantic properties that are not allowed to change.

## 3. Initial Scope

- `arith.addf` operations of type `f32`.
- Reassociation transformations initially involving three operands.
- Analysis of the local `reassoc` flag.
- Preservation of operands and their original order.
- No FMA (fused multiply-add) contraction or arbitrary operand modifications.
- Unsupported cases will be classified as inconclusive.

## 4. Open Questions

- Which preconditions make a reassociation transformation valid?
- How should fast-math flags in the target program be handled?
- Which properties require SMT-based proofs?
- How can the rules be applied to `linalg.generic` reductions?
- How should special IEEE-754 values and behaviors be handled?

## 5. Rule R1 — Three-Operand Reassociation

**Transformation:**

`(a + b) + c -> a + (b + c)`

### C1 — Local Reassociation Permissions

Let `op1` and `op2` be the two `arith.addf` operations participating in the original expression.

We define:

`reassoc(op) = true` if `op` has the `reassoc` flag; `false` otherwise.

The first precondition of R1 is:

`C1 = reassoc(op1) AND reassoc(op2)`

If C1 is false, rule R1 cannot be applied.

This does not necessarily imply that the transformation is incorrect. It may still be validated through another rule or by proving semantic equivalence.

C1 alone is not sufficient to validate R1. Additional conditions will be formalized in subsequent sections.

### C2 — Operand Correspondence

Let `T_src` and `T_tgt` be the addition expression trees of the source and target programs, respectively.

We define `leaves(T)` as the ordered sequence of leaf operands obtained by traversing the leaves of tree T from left to right.

The second precondition of R1 is:

`C2 = leaves(T_src) == leaves(T_tgt)`

Equality is defined in terms of the correspondence between program arguments, rather than their SSA names.

Within the initial scope:

- Each leaf corresponds to a function argument of type `f32`.
- The original operand order must be preserved.
- No operands may be added, removed, or replaced.
- Only the parenthesization of addition operations may change.

**Example satisfying C2:**

`(a + b) + c -> a + (b + c)`

**Example violating C2:**

`(a + b) + c -> a + (b + d)`

Condition C2 can be checked structurally. In future extensions, SMT-based reasoning may be used to verify the semantic equivalence of nontrivial corresponding subexpressions.

C2 alone is not sufficient to validate R1.