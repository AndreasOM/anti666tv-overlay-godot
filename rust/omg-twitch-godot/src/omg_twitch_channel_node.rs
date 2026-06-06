use godot::prelude::*;
use godot::classes::Node;
use godot::classes::INode;

use tokio::runtime::Runtime;
use std::time::Duration;


#[derive(Debug)]
enum Event {
    Debug{ msg: String },
    Noop,
}

#[derive(GodotClass)]
#[class(base=Node)]
pub struct OmgTwitchChannelNode {
    base: Base<Node>,
    runtime: Runtime,
    event_rx: tokio::sync::mpsc::Receiver< Event >,
    event_tx: tokio::sync::mpsc::Sender< Event >,
}



#[godot_api]
impl INode for OmgTwitchChannelNode {
    fn init(base: Base<Node>) -> Self {
        godot_print!("Hello, world!"); // Prints to the Godot console
        
        let runtime = Runtime::new().expect("Failed to create runtime");
        let (event_tx, mut event_rx) = tokio::sync::mpsc::channel( 100 );
        Self {
            base,
            runtime,
            event_rx,
            event_tx,
        }
    }

    fn ready(&mut self) {
        godot_print!("Ready?!"); // Prints to the Godot console
        self.signals().message_received().emit(
            String::from(
                "Hello from OmgTwitchChannelNode.ready"
            )
        );

        let event_tx = self.event_tx.clone();

        self.runtime.spawn(async move {
            tokio::time::sleep(Duration::from_millis(5000)).await;
            let _ = event_tx.send(
                Event::Debug{
                    msg: "Late ready".to_string(),
                }
            ).await;
            // godot_print!("Late ready"); // Prints to the Godot console
        });

    }

}

#[godot_api]
impl OmgTwitchChannelNode {
    #[signal]
    fn message_received(msg: String);

    #[func]
    fn poll(&mut self) {
        loop {
            match self.event_rx.try_recv() {
                Ok( e ) => {
                    godot_print!("{:?}", e );
                }
                _ => break,
            }
        }
    }
}
