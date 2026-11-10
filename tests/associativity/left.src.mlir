func.func @main(%a: f32, %b: f32, %c: f32) -> f32 {
    %0 = arith.addf %a, %b : f32
    %1 = arith.addf %0, %c : f32
    return %1: f32
}