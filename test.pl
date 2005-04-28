#!/usr/bin/perl -w

use strict;
use warnings;

use lib "./lib";

use Net::YIM;

print "YahooID> ";
chomp (our $user = <STDIN>);
print "Password> ";
chomp (our $pass = <STDIN>);
print "Contact> ";
chomp (our $contact = <STDIN>);

# Create a new Yahoo.
my $yahoo = new Net::YIM (
	username => $user,
	password => $pass,
	debug    => 1,
);

# Set handlers.
$yahoo->setHandler (Connected => \&on_connect);
$yahoo->setHandler (Message   => \&on_im);

# Connect to YIM.
$yahoo->connect();

# Start.
$yahoo->start();

sub on_connect {
	my $self = shift;

	print "Connected to YIM!\n";

	return unless $contact;

	# Say hi to our contact!
	$self->sendMessage ($contact,"<ding>");
	$self->sendMessage ($contact,"\x1B[#ff0000m<font face=\"Verdana\">I am <b>connected</b>!");
}

sub on_im {
	my ($self,$from,$msg) = @_;

	# Fix the message.
	if ($msg =~ /</i) {
		$msg =~ s/^<(.|\n)+?>//ig;
		$msg =~ s/^(.*?)</</i;
	}

	# Remove HTML from the message.
	$msg =~ s/<(.|\n)+?>//ig;

	print "[$from] $msg\n";
	$self->sendMessage ("$from","You said: $msg",
		font  => 'Comic Sans MS',
		color => '#FF00FF',
		style => 'BI',
	);
}