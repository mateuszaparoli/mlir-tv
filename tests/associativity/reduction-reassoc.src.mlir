func.func @sum(%input: tensor<3xf32>) -> tensor<f32>
{
  %zero = arith.constant -0.0 : f32
  %i = tensor.empty () : tensor<f32>
  %outty = linalg.fill ins(%zero: f32) outs(%i: tensor<f32>) -> tensor<f32>
  %result = linalg.generic {
      indexing_maps = [affine_map<(d0) -> (d0)>,
                       affine_map<(d0) -> ()>],
      iterator_types = ["reduction"]}
     ins(%input : tensor<3xf32>) outs(%outty : tensor<f32>) {
     ^bb0(%arg0 : f32, %arg1 : f32):
        %0 = arith.addf %arg0, %arg1 {fastmath = #arith.fastmath<reassoc>} : f32
        linalg.yield %0 : f32
  } -> tensor<f32>
  return %result : tensor<f32>
}
