mod module_bindings { pub mod region; }

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();

}