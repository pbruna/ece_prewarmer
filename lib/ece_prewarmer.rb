require 'hosts'
require 'anemone'
require 'uri'
require 'ece_prewarmer/version'

module EcePrewarmer

  def self.add_host_alias(ip, host_alias, file = nil)
    file ||= '/etc/hosts'
    hosts = Hosts::File.read(file)
    hosts.elements << Hosts::Entry.new(ip, host_alias)
    hosts.invalidate_cache!
    hosts.write
  end

  def self.remove_host_alias(hostname, file = nil)
    file ||= '/etc/hosts'
    hosts = Hosts::File.read(file)
    to_delete = hosts.elements.each_with_index.map {|e,i| i if e.name == hostname }.compact
    to_delete.each { |i| hosts.elements[i] = nil }
    hosts.elements.compact!
    hosts.write
  end

  def self.prewarm(host, website, opts = {})
    opts = parse_opts opts
    url = "http://#{website}:#{opts[:port]}/"
    add_host_alias(host, website, opts[:hostfile])
    results = crawl(url, opts[:port], opts[:verbose], opts[:threads], opts[:depth_limit])
    remove_host_alias(website, opts[:hostfile])
    results
  end

  def self.crawl(url, port, verbose, threads, depth)
    result = []
    Anemone.crawl(url, verbose: verbose, threads: threads, depth_limit: 2) do |anemone|
      links = []
      anemone.on_every_page do |page|
        links.push page.url
        new_links = page.links.each do |l|
          uri = URI l
          uri.port = port
          uri.to_s
        end
        anemone.focus_crawl { new_links }
      end
      anemone.after_crawl { result = links }
    end
    result
  end

  def self.parse_opts(opts)
    opts[:threads] ||= 4
    opts[:hostfile] ||= nil
    opts[:verbose] ||= false
    opts[:port] ||= 80
    opts[:depth_limit] ||= false
    opts
  end

end
