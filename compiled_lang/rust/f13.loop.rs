// testbox: title="Iterator::for_each() over a reversed Range"
fn main() {
    (1..=10).rev().for_each(|count| println!("Count is {}", count));
}
