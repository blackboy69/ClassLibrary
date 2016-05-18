##
#   ____                      _      
#  / ___|___  _ __  ___  ___ | | ___ 
# | |   / _ \| '_ \/ __|/ _ \| |/ _ \
# | |__| (_) | | | \__ \ (_) | |  __/
#  \____\___/|_| |_|___/\___/|_|\___|
#
# Console.pm - Console (STDOUT) handler
# August 2015 by Harley H. Puthuff
# Copyright 2015, Your Showcase on the Internet
#

package Console;

use File::Basename;

##
# Constructor:
#
#	@param string $prefix		: (optional) prefix to output
#	@return object
#

sub new {
	my $class = shift;
	my $this = {};
	bless $this,$class;
	$this->{prefix} = shift;	# get any prefix
	$this->{prefix} ||= "=>";	# use default if none
	$this->{prefix} .= " ";		# append a space
	return $this;
	}

##
# write to STDOUT
#
#	@param mixed $param			# one or more output strings
#
sub write {
	my $this = shift;
	my $msg;
	print(STDOUT $this->{prefix},$msg,"\n") while ($msg = shift);
	}

##
# read from STDIN
#
#	@param string				: (optional) prompt text
#	@param string				: (optional) default value
#	@return string				: input string or undef
#
sub read {
	my ($this,$prompt,$default) = @_;
	print STDOUT $this->{prefix};
	print STDOUT $prompt if $prompt;
	print STDOUT " [$default]" if $default;
	print STDOUT ": " if $prompt;
	my $buffer = readline(STDIN);
	chomp $buffer;
	$buffer = $default if ($default and !$buffer);
	return $buffer;
	}

##
# confirm a decision or action
#
#	@param string				: prompt text
#	@return boolean				: 0=false, 1=true
#
sub confirm {
	my ($this,$prompt) = @_;
	print STDOUT $this->{prefix},$prompt," [N,y]? ";
	my $buffer = readline(STDIN);
	chomp $buffer;
	return (!$buffer or $buffer=~/n/i) ? 0 : 1;
	}

##
# display a header line followed by underscores
#
#	@param string $header		: (optional) text for header line
#
sub header {
	my ($this,$title) = @_;
	unless ($title) {
		my $fullname = $0;
		my $filename = basename($fullname);
		my $ltime = localtime;
		$title = sprintf("%s start: %s",$filename,$ltime);
		}
	print STDOUT "\n";
	$this->write($title,('-' x length($title)));
	}

##
# display a footer line preceeded by underscores
#
#	@param string $footer		: (optional) text for footer line
#
sub footer {
	my ($this,$title) = @_;
	unless ($title) {
		my $fullname = $0;
		my $filename = basename($fullname);
		my $ltime = localtime;
		$title = sprintf("%s ended: %s",$filename,$ltime);
		}
	$this->write(('-' x length($title)),$title);
	print STDOUT "\n";
	}

##
# display a name,value pair
#
#	@param string $name			: the name of the value
#	@param mixed $value			: the value to show
#
sub show {
	my ($this,$name,$value) = @_;
	$this->write("$name: $value");
	}

-1;
