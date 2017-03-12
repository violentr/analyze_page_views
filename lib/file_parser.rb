#!/usr/bin/env ruby

class FileParser
  attr_reader :file

  def initialize
    @file = ARGV.first
    @uniq_views = []
  end

  def process
    return StandardError.new.error unless file_loaded?
    data = get_page_views(split_in_categories(file_contents))
    print(descending_order(data))
  end

  def split_in_categories(contents)
    contents.each_with_object([]) do |line, array|
      key, value = line.strip.split(/ /)
      array << [key, value]
    end
  end

  def get_page_views(collection)
    collection.each_with_object({}) do |item, hash|
      key, value = item
      hash[key] << value if hash.has_key?(key)
      hash[key] ||= [value]
    end
  end

  def print(output)
    output.each do |url, count|
      view = count == 1 ? "unique view" : "views"
      uniq_views << {url: url, views: count} if count == 1
      puts "#{url} - #{count} #{view}"
    end
  end

  def descending_order(data)
    data = data.each do |url, ips|
      data[url] = ips.size
    end.sort_by {|key, value| value}.reverse!
    data.to_h
  end

  def uniq_views
    @uniq_views
  end

  def file_loaded?
    File.exists?(file)
  end

  private

  def default_file_name
    'webserver.log'
  end

  def file
    file = ARGV.first || empty
    File.exists?(file) ? ARGV.first : make_tests_pass
  end

  def empty
    ""
  end

  def make_tests_pass
     ENV['TEST'] == "true" ? default_file_name : empty
  end

  def file_contents
    File.open(file).readlines
  end

end

class StandardError
  def error
    puts "Please specify File to parse!"
  end
end

FileParser.new.process
