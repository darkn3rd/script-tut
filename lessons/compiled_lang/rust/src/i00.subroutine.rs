use std::time::{SystemTime, UNIX_EPOCH};

// Civil calendar date from a day count since the Unix epoch (Howard
//  Hinnant's well-known public-domain algorithm) - std has no calendar
//  math of its own, and this project has no external date crate
//  dependency (see ../README.md - it's built with plain rustc, not
//  cargo).
fn civil_from_days(z: i64) -> (i64, u32, u32) {
    let z = z + 719468;
    let era = if z >= 0 { z } else { z - 146096 } / 146097;
    let doe = (z - era * 146097) as u64;
    let yoe = (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365;
    let y = yoe as i64 + era * 400;
    let doy = doe - (365 * yoe + yoe / 4 - yoe / 100);
    let mp = (5 * doy + 2) / 153;
    let d = (doy - (153 * mp + 2) / 5 + 1) as u32;
    let m = if mp < 10 { mp + 3 } else { mp - 9 } as u32;
    (if m <= 2 { y + 1 } else { y }, m, d)
}

fn show_date() {
    const MONTHS: [&str; 12] = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December",
    ];

    let now = SystemTime::now().duration_since(UNIX_EPOCH).unwrap();
    let days = (now.as_secs() / 86400) as i64;
    let (year, month, day) = civil_from_days(days);

    println!("Today is {} {day}, {year}.", MONTHS[(month - 1) as usize]);
}

fn main() {
    show_date();
}
