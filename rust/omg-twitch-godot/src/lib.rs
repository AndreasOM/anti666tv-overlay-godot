use godot::prelude::*;

use godot::global::godot_str;

struct OmgTwitch;

#[gdextension]
unsafe impl ExtensionLibrary for OmgTwitch {
    fn on_stage_init(stage: InitStage) {
        godot::global::print_rich(
            &[
                godot_str!(
                    "[color=green] OmgTwitch: on_stage_init {:?}", stage
                ).to_variant()
            ]
        );
        // godot::global::print_rich("[color=green] OmgTwitch: on_stage_init");
    }
}

mod omg_twitch_channel_node;
pub use omg_twitch_channel_node::OmgTwitchChannelNode;

mod twitch_irc;
