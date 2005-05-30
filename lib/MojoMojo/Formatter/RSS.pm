package MojoMojo::Formatter::RSS;

use LWP::Simple;
use XML::Feed;
sub format_content_order { 5 }
sub format_content {
    my ($self,$content,$base)=@_;

    my @lines=split /\n/,$$content;
    my $pod;$$content="";
    foreach my $line (@lines) {
	if ($line =~ m/^=(feed\:\/\/\S+)(\s+\d+)?$/) { 
         		$$content.=MojoMojo::Formatter::RSS->include_rss($1,$2);
	} else {
	    $$content .=$line."\n";	
	}
    }
}

sub include_rss {
    my ($self,$url,$entries)=@_;
    $entries ||= 1;
    $url =~ s/^feed/http/;
    my $feed=XML::Feed->parse(URI->new($url)) or
        return "Could not retrieve $url .\n";
    my $count=0;
    my $content='';
    foreach my $entry ($feed->entries){
        $count++;
        $content.='<div class="feed">'
        .'<h3><a href="'.$entry->link.'">'.
        $entry->title.'</a></h3>'
        .$entry->content->body.'</div>';
        return $content if $count==$entries;
    }
    return $content;
}



1;