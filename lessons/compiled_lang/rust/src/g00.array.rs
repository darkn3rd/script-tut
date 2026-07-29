fn main() {
    // populate array one item at a time
    let mut nicknames: [&str; 7] = Default::default();
    nicknames[0] = "bob";
    nicknames[1] = "ed";
    nicknames[2] = "steve";
    nicknames[3] = "ralph";
    nicknames[4] = "joe";
    nicknames[5] = "deb";
    nicknames[6] = "kate";

    println!("The total nicknames are: {}", nicknames.len());
    println!("The nicknames are: {}", nicknames.join(", "));
}
