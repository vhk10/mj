#!/usr/bin/perl

# Calculates how much each player should play the others at the end of a
# Mah Jongg hand, based on their scores

# For variants of the game where there is mutual scoring up among losing hands

# Generates a page mjcalc.pl 


use CGI qw(:standard);
#use LWP::Simple qw(!head);

# set number of points added to winning hand
my $forgoingmj=20;
# set number of points for limit hand
my $limit=500;



print header(), start_html("MJ score calculator");

print "<h1>Score calculator for Mah Jongg</h1>";


 
my $doscore=0;
my ($east,$south,$west,$north);

if (param("mjcalc")) {

if (param("mj")) {
    $doscore=1;    
 $mj=param("mj");
 
   ($checkede,$checkeds,$checkedw,$checkedn);

    
} else {
    print "<strong>Please say who went Mah Jongg</strong><br/>";

}    


unless (param("escore") ne "" and param("sscore") ne "" and param("wscore") ne "" and param("nscore") ne "" ) {

 print "<strong>Please complete scores for all winds</strong><br/>"; 
    $doscore=0;
}

 $east=param("escore"); $east =~ s/\s//;
 $south=param("sscore");  $south =~ s/\s//; 
 $west=param("wscore"); $west =~ s/\s//;
 $north=param("nscore"); $north =~ s/\s//;


my %winds = ("East",$east,"South",$south,"West",$west,"North",$north);

for my $wind(keys %winds) {
# test for non-numeric, odd number as score or winning hand too small

    if ($winds{$wind} =~ /\D/ 
	or (int($winds{$wind}/2) != $winds{$wind}/2)
	or ($wind eq $mj and ($winds{$wind} < ($forgoingmj+2))) 
) {
    print "<strong>".$wind."'s score is invalid</strong><br/>";
    $doscore=0;
	    }
	    if ($winds{$wind} == $limit) {
		print "Well done, $wind! A limit!<br/><br/>";
	    }
}

   if ($doscore ==0) {
if ($mj eq "East") {
    $checkede="checked=\"yes\"";
} elsif ($mj eq "South") {
    $checkeds="checked=\"yes\"";
} elsif ($mj eq "West") {
    $checkedw="checked=\"yes\"";
} elsif ($mj eq "North") {
    $checkedn="checked=\"yes\"";
}
}
   elsif ($doscore ==1) {

$epts=0;
$spts=0;
$wpts=0;
$npts=0;



if ($mj eq "East") {
    $epts=$east*6;
    my $sw=($south-$west);
    my $sn=($south-$north);
    my $wn=($west-$north);
    $spts = $sw + $sn - ($east*2);
    $wpts = 0 - $sw + $wn - ($east*2);
    $npts = 0 - $sn - $wn - ($east*2);

} elsif ($mj eq "South") {
    my $ew=($east-$west);
    my $en=($east-$north);
    my $wn=($west-$north);
    $epts = ($ew + $en - $south)*2; 
    $spts = $south*4;
    $wpts = 0 - ($ew*2) + $wn - $south;
    $npts = 0 - ($en*2) - $wn - $south;

} elsif ($mj eq "West") {
    my $es=($east-$south);
    my $en=($east-$north);
    my $sn=($south-$north);
    $epts = ($es + $en - $west)*2; 
    $spts = 0 - ($es*2) + $sn - $west;
    $wpts = $west*4;
    $npts = 0 - ($en*2) - $sn - $west;

} elsif ($mj eq "North") {
    my $es=($east-$south);
    my $ew=($east-$west);
    my $sw=($south-$west);
    $epts = ($es + $ew - $north)*2; 
    $spts = 0 - ($es*2) + $sw - $north;
    $wpts = 0 - ($ew*2) - $sw - $north;
    $npts = $north*4;

}

print "East $epts<br/>";
print "South $spts<br/>";
print "West $wpts<br/>";
print "North $npts<br/>";

undef($east);undef($south);undef($west); undef($north);
}
}


print<<EOF;
    <form action="mjcalc.pl" method="post">
<hr>
    Enter scores/part scores.  If East has gone Mah-Jongg, do not include the 'double for East': <br/>
  East: <input name="escore" size="4" value="$east"/>
  South: <input name="sscore" size="4" value="$south"/>
  West: <input name="wscore" size="4" value="$west" />
  North: <input name="nscore" size="4" value="$north"/>
    <br/><br/>
    Who went Mah-Jongg? East<input type="radio" name="mj" value="East" $checkede/>&nbsp;&nbsp;&nbsp;&nbsp;
South<input type="radio" name="mj" value="South" $checkeds/>&nbsp;&nbsp;&nbsp;&nbsp;
West<input type="radio" name="mj" value="West" $checkedw/>&nbsp;&nbsp;&nbsp;&nbsp;
North<input type="radio" name="mj" value="North" $checkedn/>&nbsp;&nbsp;&nbsp;&nbsp;
<input type="hidden" name="mjcalc" value="Y"/>
<input type="submit" value="Submit scores" name="mj_calc.pl">     </form>
    </body>
    </html>
    
EOF
exit;
