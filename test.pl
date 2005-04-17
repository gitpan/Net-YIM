#!/usr/bin/perl -w

use strict;
use warnings;

use lib "./lib";

use Net::YIM;

# Create a new Yahoo.
my $yahoo = new Net::YIM (
	username => 'PerlYIM',
	password => 'bigsecret',
	debug    => 0,
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

	# Say hi to Kirsle!
	$self->sendMessage ("YahooID","<ding>");
	$self->sendMessage ("YahooID","I am <b>connected</b>!");
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
	$self->sendMessage ("$from","You said: $msg");
}