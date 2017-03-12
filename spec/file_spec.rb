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

  it 'should have file contents' do
    expect(formated_file_contents["/home"]).to include(["/home", "225.183.113.22"])
    expect(formated_file_contents["/contact/"]).to include(["/contact/", "245.141.61.189"])
  end

  it 'show array of ips for "/home" page' do
    output = file_parser.get_page_views!(formated_file_contents)
    expect(output).to be_a(Hash)
    expect(output.keys).to include("/home")
    expect(output["/home"]).to be_a(Array)
    expect(output["/home"].size).to eq 143
    expect(output["/home"].first).to include("225.183.113.22")
  end

  it 'should be in descending order' do
    output = {"/contact/"=>155, "/products/3"=>149, "/home"=>143, "products/1"=>142, "/about"=>141, "/index"=>141, "/products/2"=>129}
    file_parser.process
    expect(file_parser.get_views).to eq output
  end

  it 'should have uniq views for /home page' do
    output = {"/contact/"=>20, "/products/2"=>20, "/home"=>20, "/products/3"=>20, "/about"=>20, "/index"=>20, "products/1"=>20}
    file_parser.process
    expect(file_parser.get_uniq_views).to eq output
  end
end

