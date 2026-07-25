fn main() {
    let radius = 3;
    let area = std::f64::consts::PI * (radius as f64).powi(2);

    println!("The area of a circle (radius={}) is: {}.", radius, area);
}
