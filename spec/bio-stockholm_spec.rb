require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "BioStockholm" do
  it "should parse a stockholm file 1" do
    stock = Bio::Stockholm::Reader.parse_from_file(File.expand_path "#{TEST_DATA_DIR}/test1.sto")
    stock.records.length.should == 1
    stock.records.values[0].sequence.should == '--------------------------------------LTMVWLRRCTHYLFIAVVAVNSTLLTINAGDYIFYTDWAWTS--F..TVFSISQTLML....'
  end

  it 'should parse a version correctly' do
    stock = Bio::Stockholm::Reader.parse_from_file(File.expand_path "#{TEST_DATA_DIR}/test1.sto")
    stock.version.should == '# STOCKHOLM 1.0'
  end
end
