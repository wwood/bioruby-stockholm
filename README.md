# bio-stockholm

[![Build Status](https://secure.travis-ci.org/wwood/bioruby-stockholm.png)](http://travis-ci.org/wwood/bioruby-stockholm)

Stockholm format file parser for ruby.

## Installation

```sh
gem install bio-stockholm
```

## Usage

An example stockholm format file, from https://en.wikipedia.org/wiki/Stockholm_format
```
# STOCKHOLM 1.0
#=GF ID CBS1
#=GF AC PF00571
#=GF DE CBS domain
#=GF AU Bateman A
#=GF CC CBS domains are small intracellular modules mostly found
#=GF CC in 2 or four copies within a protein.
#=GF SQ 5
#=GS O31698/18-71 AC O31698
#=GS O83071/192-246 AC O83071
#=GS O83071/259-312 AC O83071
#=GS O31698/88-139 AC O31698
#=GS O31698/88-139 OS Bacillus subtilis
O83071/192-246          MTCRAQLIAVPRASSLAEAIACAQKMRVSRVPVYERS
#=GR O83071/192-246 SA  9998877564535242525515252536463774777
O83071/259-312          MQHVSAPVFVFECTRLAYVQHKLRAHSRAVAIVLDEY
#=GR O83071/259-312 SS  CCCCCHHHHHHHHHHHHHEEEEEEEEEEEEEEEEEEE
O31698/18-71            MIEADKVAHVQVGNNLEHALLVLTKTGYTAIPVLDPS
#=GR O31698/18-71 SS    CCCHHHHHHHHHHHHHHHEEEEEEEEEEEEEEEEHHH
O31698/88-139           EVMLTDIPRLHINDPIMKGFGMVINN..GFVCVENDE
#=GR O31698/88-139 SS   CCCCCCCHHHHHHHHHHHHEEEEEEEEEEEEEEEEEH
#=GC SS_cons            CCCCCHHHHHHHHHHHHHEEEEEEEEEEEEEEEEEEH
O31699/88-139           EVMLTDIPRLHINDPIMKGFGMVINN..GFVCVENDE
#=GR O31699/88-139 AS   ________________*____________________
#=GR O31699/88-139 IN   ____________1____________2______0____
//
```

```ruby
require 'bio-stockholm'

entries = Bio::Stockholm::Reader.parse_from_file('spec/data/wikipedia.sto') #=> Array of 1

cbs = entries[0] #=> Bio::Stockholm::Store object

cbs.gf_features['ID'] #=> 'CBS'
cbs.gf_features['AC'] #=> 'PF00571'

# #=GS O31698/88-139 OS Bacillus subtilis
cbs.records['O31698/88-139'].gs_features['OS'] #=> 'Bacillus subtilis'

# O83071/192-246          MTCRAQLIAVPRASSLAEAIACAQKMRVSRVPVYERS
cbs.records['O83071/192-246'].sequence #=> 'MTCRAQLIAVPRASSLAEAIACAQKMRVSRVPVYERS'
```

The API doc is online. For more code examples see the test files in
the source tree.

## Project home page

Information on the source tree, documentation, examples, issues and
how to contribute, see

  http://github.com/wwood/bioruby-stockholm

The BioRuby community is on IRC server: irc.freenode.org, channel: #bioruby.

## Cite

This software is currently unpublished.

## Biogems.info

This Biogem is published at (http://biogems.info/index.html#bio-stockholm)

## Copyright

Copyright (c) 2013 Ben J. Woodcroft. See LICENSE.txt for further details.

