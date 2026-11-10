func.func @main(%a: f32, %b: f32, %c: f32) -> f32 {
    %0 = arith.addf %b, %c {fastmath = #arith.fastmath<reassoc>} : f32
    %1 = arith.addf %a, %0 {fastmath = #arith.fastmath<reassoc>} : f32
    return %1 : f32
}
