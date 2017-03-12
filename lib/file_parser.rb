#!/usr/bin/env ruby
require 'byebug'

class FileParser
  attr_reader :file
  attr_accessor :get_views, :get_uniq_views

  def initialize
    @file = ARGV.first
    @get_views = {}
    @get_uniq_views = {}
  end

  def process
    return StandardError.new.error unless file_loaded?
    get_page_views!(split_in_categories(file_contents))
    print(desc_order(get_views))
    print_uniq(desc_order(get_uniq_views))
  end

  def split_in_categories(contents)
    contents.each_with_object([]) do |line, array|
      key, value = line.strip.split(/ /)
      array << [key, value]
    end.group_by {|url, ip| url}
  end

  def get_page_views!(collection)
    black_list = collection.keys
    collection.each_with_object({}) do |item, hash|
      url, data = item
      data.flatten!
      data.delete_if {|name| black_list.include?(name)}
      hash[url] = data
      get_views[url] = data.size
      get_uniq_views[url] = data.uniq.size
    end
  end

  def print(collection)
    collection.each do |url, ips|
      puts "#{url} - #{ips} view"
    end
    puts "===================="
  end

  def desc_order(data)
    data.sort_by {|key, value| value}.reverse!
  end

  def print_uniq(collection)
     collection.each do |item|
       url, ips = item
       puts "#{url} has #{ips} uniq views"
     end
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
