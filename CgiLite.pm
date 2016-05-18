##
#   ____      _ _     _ _                         
#  / ___|__ _(_) |   (_) |_ ___   _ __  _ __ ___  
# | |   / _` | | |   | | __/ _ \ | '_ \| '_ ` _ \ 
# | |__| (_| | | |___| | ||  __/_| |_) | | | | | |
#  \____\__, |_|_____|_|\__\___(_) .__/|_| |_| |_|
#       |___/                    |_|              
#	CgiLite - Lightweight CGI Interface
#	April 2003 by Harley Puthuff
#	Copyright 2003-15, Your Showcase
#
package Cgi;

sub new {			# object constructor
    my ($class) = shift;
    my ($this) = {};
    my ($buffer,$key,$data);
    bless $this,$class;
    read(STDIN,$buffer,$ENV{CONTENT_LENGTH}) if ($ENV{CONTENT_LENGTH} > 0);
    if ($ENV{QUERY_STRING} ne '') {
	$buffer .= '&' unless ($buffer eq '');
	$buffer .= $ENV{QUERY_STRING};
	}
    if ($ENV{QUERY_STRING_UNESCAPED} ne '') {
        $buffer .= '&' unless ($buffer eq '');
        $buffer .= $ENV{QUERY_STRING_UNESCAPED};
        }
    foreach (split /\\*&/,$buffer) {
	tr/\+/ /;
	($key,$data) = split /=/;
	foreach ($key,$data) {s/%(..)/chr(hex($1))/ge}
	if ($this->{"$key"} eq '') {$this->{"$key"} = $data}
	elsif ($data ne '') {$this->{"$key"} .= ",$data"}
	}
    return $this;
    }

sub headers {			# output HTTP headers
    my $this = shift;
    print STDOUT qq|Expires: Sat, 01 Jan 2000 00:00:00 GMT\n|;
    print STDOUT qq|Cache-Control: NO-CACHE\n|;
    print STDOUT qq|Pragma: NO-CACHE\n|;
    print STDOUT qq|Content-type: text/html\n\n|;
    }

sub redirect {			# output HTTP redirect
    my $this = shift;
    my $url = (shift or return);
    print STDOUT qq|Location: $url\n\n|;
    exit 0;
    }

-1;
