// run-pass
pub fn main() {
    if cfg!(target_cpu = "cortex-a8") {
        println!("Running on Cortex A8!");
    } else {
        println!("Running on an arbitrary cpu");
    }
}
