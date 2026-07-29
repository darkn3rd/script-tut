// testbox: title="loop {} with break"
fn main() {
    let mut count = 10;
    loop {
        if count == 0 {
            break;
        }
        println!("Count is {}", count);
        count -= 1;
    }
}
