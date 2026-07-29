// testbox: title="for-in over a reversed Range"
fn main() {
    for count in (1..=10).rev() {
        println!("Count is {}", count);
    }
}
