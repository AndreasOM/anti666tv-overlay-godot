
use crate::message::Message;
use twitch_irc::login::StaticLoginCredentials;
use twitch_irc::TwitchIRCClient;
use twitch_irc::{ClientConfig, SecureTCPTransport};
use twitch_irc::message::ServerMessage;
use tokio::task::JoinHandle;
use tokio::sync::mpsc::UnboundedReceiver;

use crate::event::Event;

pub struct TwitchIrc {
	join_handle: Option< JoinHandle<()> >,
	incoming_messages: Option<UnboundedReceiver<ServerMessage>>,
	client: TwitchIRCClient<SecureTCPTransport, StaticLoginCredentials>,

    event_tx: tokio::sync::mpsc::Sender< Event >,
}

impl TwitchIrc {
	pub fn new( event_tx: tokio::sync::mpsc::Sender< Event > ) -> Self {
	    let config = ClientConfig::default();
	    let (mut incoming_messages, client) =
	        TwitchIRCClient::<SecureTCPTransport, StaticLoginCredentials>::new(config);
		Self {
			join_handle: None,
			incoming_messages: Some(incoming_messages),
			client,
			event_tx,
		}
	}

	pub async fn run(&mut self) {
	    // default configuration is to join chat as anonymous.
//	    let config = ClientConfig::default();
//	    let (mut incoming_messages, client) =
//	        TwitchIRCClient::<SecureTCPTransport, StaticLoginCredentials>::new(config);

	    // first thing you should do: start consuming incoming messages,
	    // otherwise they will back up.
//	    let join_handle = tokio::spawn(async move {
		let mut incoming_messages = self.incoming_messages.take().expect("???");
	        while let Some(message) = incoming_messages.recv().await {
	            println!("Received message: {:?}", message);
	            match message {
	            	ServerMessage::Privmsg( pm ) => {
			            let msg = Message{
			            	// text: format!( "Received message: {:?}", message ),
			            	// text: format!( "Received message: {}", pm.message_text ),
			            	text: pm.message_text,
			            };

			            let _ = self.event_tx.send(
			                Event::Message( msg )
			            ).await;

	            	},
	            	uh => {
	            		// :TODO:
	            	}
	            }
	        }
//	    });
//	    self.join_handle = Some( join_handle );

	    // join a channel
	    // This function only returns an error if the passed channel login name is malformed,
	    // so in this simple case where the channel name is hardcoded we can ignore the potential
	    // error with `unwrap`.
//	    client.join("sodapoppin".to_owned()).unwrap();

	    // keep the tokio executor alive.
	    // If you return instead of waiting the background task will exit.
	    // self.join_handle.await.unwrap();		
	}

	pub fn join_channel<S>( &mut self, channel: S)
		where S: ToString,
	{
		self.client.join( channel.to_string() ).expect("!!!!");
	}
}