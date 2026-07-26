fn add_nums(numbers: &[i32]) -> i32 {
    let mut sum = 0;
    for num in numbers {
        sum += num;
    }
    sum
}

fn main() {
    println!("The numbers to be added are 5, 2, 4, 3, 6.");

    let result = add_nums(&[5, 2, 4, 3, 6]);
    println!("The result of their summation is: {result}.");
}
