require 'hosts'
require 'anemone'
require 'uri'
require 'ece_prewarmer/version'

module EcePrewarmer

  def self.add_host_alias(ip, host_alias, file = nil)
    file ||= '/etc/hosts'
    FileUtils.cp('/etc/hosts', '/tmp/hosts') if file == '/etc/hosts'
    hosts = Hosts::File.read(file)
    hosts.elements << Hosts::Entry.new(ip, host_alias)
    hosts.invalidate_cache!
    hosts.write
  end

  def self.remove_host_alias(hostname, file = nil)
    file ||= '/etc/hosts'
    hosts = Hosts::File.read(file)
    to_delete = hosts.elements.each_with_index.map do |e,i|
      return nil unless e.is_a? Aef::Hosts::Entry
      i if e.name == hostname
    end
    to_delete.compact.each { |i| hosts.elements[i] = nil }
    hosts.elements.compact!
    hosts.invalidate_cache!
    hosts.write
  end

  def self.prewarm(host, website, opts = {})
    opts = parse_opts opts
    url = "http://#{website}:#{opts[:port]}/"
    add_host_alias(host, website, opts[:hostfile])
    url = opts[:params].nil? ? url : url + opts[:params].nil?
    results = crawl(url, opts[:port], opts[:verbose], opts[:threads], opts[:depth_limit], opts[:user_agent])
    remove_host_alias(website, opts[:hostfile])
    results
  end

  def self.crawl(url, port, verbose, threads, depth, user_agent)
    result = []
    Anemone.crawl(url, verbose: verbose, threads: threads, depth_limit: depth, user_agent: user_agent) do |anemone|
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
    # Chrome by default
    opts[:user_agent] ||= "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.155 Safari/537.36"
    opts
  end

end
