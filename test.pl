
use Mojolicious::Lite;

# WebSocket echo service
websocket '/echo' => sub {
          my $self = shift;
              $self->on_message(sub {
                my ($self, $message) = @_;
                $self->send_message("echo: $message");
            });
};

get '/' => 'index';

app->start;

