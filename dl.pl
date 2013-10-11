#!/usr/bin/perl

# IMAGE AUTO DOWNLOADER
# for "俺妹の高坂桐乃ちゃんの画像ください！：ひまねっと"
#      ( "I want JPG-FILEs of 'Kirino Kousaka' from 'OREIMO' -- himanet ")
# 
# First release 2013.10.11 
#
# requires CPAN : LWP::UserAgent


# MAIN URL
$target_url = "http://himarin.net/archives/7355838.html" ;

# IMAGE URL 
$imgbase_url = "http://livedoor.blogimg.jp/himarin_net/imgs/" ;

# START TAG
$start_tag = "<div class=\"article-body\">" ;

# END TAG ... ToDo: to be able to use other site easily
$end_tag = "<a href=\"http://hayabusa.2ch.net/test/read.cgi/news4vip/1381334312/\" target=\"_blank\">元スレ</a></span>" ;


require LWP::UserAgent;

# image URL lists
@imgurl = () ;

my $ua = LWP::UserAgent->new ;
$ua->timeout(15) ;

# Attributes for LWP::UserAgent 
$OSNAME = $^O ;
$ua->agent( 'Mozilla/5.0 ( Compatible; ' . $OSNAME . ' LWP::UserAgent libwww-perl ; We Love Kirino Kousaka ; 20131011 ) ' ) ;
$ua->default_header( 'Accept-Language' => 'ja' ) ;


# OK , Let's GO!!
my $resp = $ua->get( $target_url ) ;

if ( $resp->is_success )
{
    @cline = split( "\n" , $resp->content ) ;

    $fg_run = 0 ;           # within START_TAG - END_TAG
    foreach $l ( @cline )
    {
        $fg_run = 1 if ( $l =~ /$start_tag/ ) ;
        $fg_run = 0 if ( $l =~ /$end_tag/ ) ;

        next if ( $fg_run == 0 ) ;

        if ( $l =~ /http:\/\// ) 
        {
            $l2 = $l ;
            while( $l2 =~ /(http:\/\/[a-zA-Z0-9\-\_\.\/]+)/ )
            {
                $imgurl = $1 ;
                # if ( $l2 =~ /a href=\"$imgurl\"/ )    # link only
                if ( 1 )                                # include thumbnail
                {
                    if ( substr( $imgurl , 0, length( $imgbase_url ) ) eq $imgbase_url )
                    {
                        # print $imgurl . "\n" ;
                        system ( "wget " . $imgurl ) ;
                    }
                }
                $l2 =~ s/$imgurl// ;
            }
        }
    }
}

            







