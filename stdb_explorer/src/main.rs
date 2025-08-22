mod module_bindings { pub mod region; }

use module_bindings::region::DbConnection as RegionDb;
use spacetimedb_sdk::{Event, DbContext};

const HOST_WSS: &str = "wss://bitcraft-early-access.spacetimedb.com";
const REGION_DB: &str = "bitcraft-1";

fn connect_region(jwt: &str) -> RegionDb {
    RegionDb::builder()
        .with_uri(HOST_WSS)
        .with_module_name(REGION_DB)
        .with_token(Some(jwt.to_string()))
        .build()
        .expect("region connect failed")
}

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();
    let jwt = std::env::var("BITCRAFT_PLAYER_TOKEN").expect("set BITCRAFT_PLAYER_TOKEN in .env");

    let r = connect_region(&jwt);

    // adjust accessor/table name per your generated bindings if needed
    r.db.claim_state.on_insert(|ctx, row| {
        if matches!(ctx.event, Event::SubscribeApplied | Event::Reducer(_)) {
            println!("claim_state row: {:?}", row);
        }
    });

    r.subscription_builder()
        .on_applied(|_| println!("region claim_state subscription applied"))
        .on_error(|_, e| { eprintln!("subscription error: {e}"); std::process::exit(1); })
        .subscribe(["SELECT * FROM claim_state"]);

    r.run_threaded();
    println!("connected to region; waiting for claims…");
    std::thread::park();
}