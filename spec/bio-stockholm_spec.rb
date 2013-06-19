require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "BioStockholm" do
  it "should parse a stockholm file 1" do
    stocks = Bio::Stockholm::Reader.parse_from_file(File.expand_path "#{TEST_DATA_DIR}/test1.sto")
    stocks.should be_kind_of(Array)
    stocks.length.should == 1
    stock = stocks[0]
    stock.records.length.should == 1
    stock.records.values[0].sequence.should == '--------------------------------------LTMVWLRRCTHYLFIAVVAVNSTLLTINAGDYIFYTDWAWTS--F..TVFSISQTLML....'
  end

  it 'should parse a version correctly' do
    stocks = Bio::Stockholm::Reader.parse_from_file(File.expand_path "#{TEST_DATA_DIR}/test1.sto")
    stock = stocks[0]
    stock.header.should == '# STOCKHOLM 1.0'
  end

  it 'should parse the wikipedia stockholm format entry' do
    #  # STOCKHOLM 1.0
    #  #=GF ID CBS
    #  #=GF AC PF00571
    #  #=GF DE CBS domain
    #  #=GF AU Bateman A
    #  #=GF CC CBS domains are small intracellular modules mostly found
    #  #=GF CC in 2 or four copies within a protein.
    #  #=GF SQ 5
    #  #=GS O31698/18-71 AC O31698
    #  #=GS O83071/192-246 AC O83071
    #  #=GS O83071/259-312 AC O83071
    #  #=GS O31698/88-139 AC O31698
    #  #=GS O31698/88-139 OS Bacillus subtilis
    #  O83071/192-246          MTCRAQLIAVPRASSLAEAIACAQKMRVSRVPVYERS
    #  #=GR O83071/192-246 SA  9998877564535242525515252536463774777
    #  O83071/259-312          MQHVSAPVFVFECTRLAYVQHKLRAHSRAVAIVLDEY
    #  #=GR O83071/259-312 SS  CCCCCHHHHHHHHHHHHHEEEEEEEEEEEEEEEEEEE
    #  O31698/18-71            MIEADKVAHVQVGNNLEHALLVLTKTGYTAIPVLDPS
    #  #=GR O31698/18-71 SS    CCCHHHHHHHHHHHHHHHEEEEEEEEEEEEEEEEHHH
    #  O31698/88-139           EVMLTDIPRLHINDPIMKGFGMVINN..GFVCVENDE
    #  #=GR O31698/88-139 SS   CCCCCCCHHHHHHHHHHHHEEEEEEEEEEEEEEEEEH
    #  #=GC SS_cons            CCCCCHHHHHHHHHHHHHEEEEEEEEEEEEEEEEEEH
    #  O31699/88-139           EVMLTDIPRLHINDPIMKGFGMVINN..GFVCVENDE
    #  #=GR O31699/88-139 AS   ________________*____________________
    #  #=GR O31699/88-139 IN   ____________1____________2______0____
    #  //
    stocks = Bio::Stockholm::Reader.parse_from_file(File.expand_path "#{TEST_DATA_DIR}/wikipedia_test.sto")
    stocks.should be_kind_of(Array)
    stocks.length.should == 1
    stock = stocks[0]

    stock.gf_features['ID'].should == 'CBS'
    stock.gf_features['DE'].should == 'CBS domain'
    stock.gf_features['SQ'].should == '5'
    stock.gf_features.length.should == 6
    stock.gf_features['CC'].should == 'CBS domains are small intracellular modules mostly found in 2 or four copies within a protein.'

    stock.records['O31698/18-71'].should be_kind_of(Bio::Stockholm::Record)
    stock.records['O31698/18-71'].gs_features.should be_kind_of(Hash)
    stock.records['O31698/18-71'].gs_features['AC'].should == 'O31698'
    stock.records['O31698/88-139'].gs_features['AC'].should == 'O31698'
    stock.records['O31698/88-139'].gs_features['OS'].should == 'Bacillus subtilis'
    stock.records['O31698/88-139'].gs_features.length.should == 2

    stock.records.length.should == 5
    stock.records['O83071/259-312'].sequence.should == 'MQHVSAPVFVFECTRLAYVQHKLRAHSRAVAIVLDEY'
    stock.records['O83071/259-312'].gr_features['SS'].should == 'CCCCCHHHHHHHHHHHHHEEEEEEEEEEEEEEEEEEE'
    stock.gc_features.should == {'SS_cons' => 'CCCCCHHHHHHHHHHHHHEEEEEEEEEEEEEEEEEEH'}
    stock.gc_features.should be_kind_of(Hash)
  end

  it 'should parse multiple ones' do
    stocks = Bio::Stockholm::Reader.parse_from_file(File.expand_path "#{TEST_DATA_DIR}/2wikipedias.sto")
    stocks.length.should == 2
    stocks[0].gf_features['ID'].should == 'CBS1'
    stocks[1].gf_features['ID'].should == 'CBS2'
  end
end
