RSpec.describe FileParser do
  let(:file_contents) { File.open('webserver.log').readlines }
  let(:formated_file_contents) { FileParser.new.split_in_categories(file_contents) }
  let(:file_parser) { FileParser.new }

  it 'should be initialized' do
    expect(file_parser).to be
  end

  it 'should have file to read from' do
    expect(file_parser.file_loaded?).to be true
  end

  it 'should have default_file_name to parse' do
    output = {"/contact/"=>155, "/products/3"=>149, "/home"=>143, "products/1"=>142, "/about"=>141, "/index"=>141, "/products/2"=>129}
    expect(file_parser.process).to eq output
  end

  it 'should have file contents' do
    expect(formated_file_contents).to include(["/home", "225.183.113.22"])
    expect(formated_file_contents).to include(["/contact/", "245.141.61.189"])
  end

  it 'show array of ips for "/home" page' do
    output = file_parser.get_page_views(formated_file_contents)
    expect(output).to be_a(Hash)
    expect(output.keys).to include("/home")
    expect(output["/home"]).to be_a(Array)
    expect(output["/home"].size).to eq 143
    expect(output["/home"].first).to include("225.183.113.22")
  end

  it 'should be in descending order' do
    output = {"/contact/"=>155, "/products/3"=>149, "/home"=>143, "products/1"=>142, "/about"=>141, "/index"=>141, "/products/2"=>129}
    data = file_parser.get_page_views(formated_file_contents)
    expect(file_parser.descending_order(data)).to eq output
  end
  it 'should have no uniq views' do
    expect(file_parser.uniq_views.size).to eq 0
  end
end

