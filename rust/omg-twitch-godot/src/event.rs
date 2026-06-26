use crate::message::Message;

#[derive(Debug)]
pub enum Event {
    Debug{ msg: String },
    Message( Message ),
    Noop,
}
