# ExperimentalDesign

```@example
using FullFactorialDesign
design_space = [DiscreteNumericFactor(:T, 3), DiscreteNumericFactor(:P, [1, 3]), CategoricalFactor(:Level, ["A", "B"])]
design = solve(FullFactorial(), design_space)
```
