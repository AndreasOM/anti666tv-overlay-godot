use godot::prelude::*;
use godot::classes::Node;

#[derive(GodotClass)]
#[class(base=Node)]
pub struct OmgTwitchChannelNode {

    base: Base<Node>
}

use godot::classes::INode;

#[godot_api]
impl INode for OmgTwitchChannelNode {
    fn init(base: Base<Node>) -> Self {
        godot_print!("Hello, world!"); // Prints to the Godot console
        
        Self {
            base,
        }
    }

    fn ready(&mut self) {
        godot_print!("Ready?!"); // Prints to the Godot console
        self.signals().message_received().emit(
            String::from(
                "Hello from OmgTwitchChannelNode.ready"
            )
        );
    }

}

#[godot_api]
impl OmgTwitchChannelNode {
    #[signal]
    fn message_received(msg: String);    
}
