fn celsius(fahrenheit: f64) {
    let temperature = (fahrenheit - 32.0) * 5.0 / 9.0;
    println!("The Celsius temperature is {temperature:.1} degrees.");
}

fn main() {
    let temperature = 73.0;
    celsius(temperature);
}
