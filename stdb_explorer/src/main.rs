mod module_bindings { pub mod region; }

use module_bindings::region::DbConnection as RegionDb;
use module_bindings::region::*;
use spacetimedb_sdk::{Event, DbContext};
use std::any::type_name_of_val;

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();

}