fn add_nums(numbers: &[i32]) {
    let mut sum = 0;
    for num in numbers {
        sum += num;
    }
    println!("The summation is: {sum}.");
}

fn main() {
    println!("Sending: 5, 2, 4, 3, 6");
    add_nums(&[5, 2, 4, 3, 6]);
}
