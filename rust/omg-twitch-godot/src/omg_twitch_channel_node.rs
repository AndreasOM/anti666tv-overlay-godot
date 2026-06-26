use godot::prelude::*;
use godot::classes::Node;
use godot::classes::INode;

use tokio::runtime::Runtime;
use std::time::Duration;

use crate::twitch_irc::TwitchIrc;

use crate::event::Event;

#[derive(GodotClass)]
#[class(base=Node)]
pub struct OmgTwitchChannelNode {
    base: Base<Node>,
    runtime: Runtime,
    event_rx: tokio::sync::mpsc::Receiver< Event >,
    event_tx: tokio::sync::mpsc::Sender< Event >,
    //twitch_irc: TwitchIrc,
}



#[godot_api]
impl INode for OmgTwitchChannelNode {
    fn init(base: Base<Node>) -> Self {
        godot_print!("Hello, world!"); // Prints to the Godot console
        
        let runtime = Runtime::new().expect("Failed to create runtime");
        let (event_tx, event_rx) = tokio::sync::mpsc::channel( 100 );
        // let twitch_irc = TwitchIrc::new();
        Self {
            base,
            runtime,
            event_rx,
            event_tx,
            // twitch_irc,
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

        let event_tx = self.event_tx.clone();

        self.runtime.spawn(async move {
            let mut twitch_irc = TwitchIrc::new( event_tx );
            twitch_irc.join_channel("anti666");
            twitch_irc.run().await;
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
                    match e {
                        Event::Debug{ msg } => {
                            godot_print!("{:?}", msg );
                        },
                        Event::Message( msg ) => {
                            self.signals().message_received().emit( msg.text );
                        }
                        uh => {
                            godot_print_rich!("[color=orange] Unhandled Event: {uh:?}");
                        }
                    }
                }
                _ => break,
            }
        }
    }
}
