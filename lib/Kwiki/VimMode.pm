package Kwiki::VimMode;
use strict;
use warnings;
use Kwiki::Plugin '-Base';
use Kwiki::Installer '-base';

our $VERSION = 0.02;

const class_title => 'color hiliting using Vim';
const class_id => 'vim_mode';
const css_file => 'vim_mode.css';

sub register {
    my $registry = shift;
    $registry->add(wafl => vim => 'Kwiki::VimMode::Wafl');
}

package Kwiki::VimMode::Wafl;
use base 'Spoon::Formatter::WaflBlock';

sub to_html {
    require Text::VimColor;
    my $string = $self->block_text;
    $string =~ s/^ filetype: \s* (\w+) \s* \n+//smx;
    chomp $string;
    my $vim = Text::VimColor->new(
        string => $string,
        ( $1 ? ( filetype => $1 ) : () ),
        vim_options => [ qw( -RXZ -i NONE -u NONE -N ), "+set nomodeline" ],
    );
    return '<pre class="vim">' . $vim->html . '</pre>';
}

package Kwiki::VimMode;
1;

__DATA__

=head1 NAME 

Kwiki::VimMode - syntax highlight preformatted forms of text

=head1 SYNOPSIS

 $ cpan Kwiki::VimMode
 $ cd /path/to/kwiki
 $ kwiki -add Kwiki::VimMode

=head1 DESCRIPTION

This module allows you to hilight the syntax of any text mode that the Vim editor recognizes:

    Here's some *HTML* and *Perl* for you to grok:
    
    .vim
    <html>
        <head>
            <title>Highlighted stuff!</title>
        </head>
        <body>
            <em>Check</em> <strong>this</strong>
            <code>out!</code>
        </body>
    </html>
    .vim
    
    .vim
    #!/usr/bin/perl
    # sample perl
    $name = 'Kwiki';
    print "Check out $name!\n";
    .vim

L<Text::VimColor>/Vim should hopefully pick up the correct syntax automatically. If it doesn't, precede your text in the C<.vim> block with C<filetype: name>, where C<name> is a valid Vim syntax name. For example:

    .vim
    filetype: apache
    
    <VirtualHost>
        ServerName www.me.org
        # ...
    </VirtualHost>
    .vim

=head1 NOTES

Modelines are explicitly ignored.

=head1 AUTHORS

Ian Langworth <langworth.com>

=head1 SEE ALSO

L<Kwiki>, L<Text::VimColor>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Ian Langworth

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__css/vim_mode.css__
pre.vim { margin-left: 1em }
.synComment    { color: #0000FF }
.synConstant   { color: #FF00FF }
.synIdentifier { color: #008B8B }
.synStatement  { color: #A52A2A ; font-weight: bold }
.synPreProc    { color: #A020F0 }
.synType       { color: #2E8B57 ; font-weight: bold }
.synSpecial    { color: #6A5ACD }
.synUnderlined { color: #000000 ; text-decoration: underline }
.synError      { color: #FFFFFF ; background: #FF0000 none }
.synTodo       { color: #0000FF ; background: #FFFF00 none }
