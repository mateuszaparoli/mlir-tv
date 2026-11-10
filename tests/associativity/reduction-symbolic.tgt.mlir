
func.func @sum(%input: tensor<3xf32>) -> tensor<f32> {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %zero = arith.constant -0.0 : f32

  %a = tensor.extract %input[%c0] : tensor<3xf32>
  %b = tensor.extract %input[%c1] : tensor<3xf32>
  %c = tensor.extract %input[%c2] : tensor<3xf32>

  %s0 = arith.addf %zero, %a : f32
  %s1 = arith.addf %b, %c : f32
  %s2 = arith.addf %s0, %s1 : f32

  %out = tensor.empty() : tensor<f32>
  %result = tensor.insert %s2 into %out[] : tensor<f32>

  return %result : tensor<f32>
}
