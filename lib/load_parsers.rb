# encoding: utf-8
# This file loads up the parsers for mail to use.  It also will attempt to compile parsers
# if they don't exist.
#
# It also only uses the compiler if we are running the SPEC suite
module Mail # :doc:
  require 'treetop/runtime'

  def self.compile_parser(parser)
    require 'treetop/compiler'
    STDOUT.puts "Compiling parser #{parser} from treetop source"
    Treetop.load(File.join(File.dirname(__FILE__)) + "/mail/parsers/#{parser}")
  end

  parsers = %w[ rfc2822_obsolete rfc2822 address_lists phrase_lists
                date_time received message_ids envelope_from rfc2045
                mime_version content_type content_disposition
                content_transfer_encoding content_location ]

  if defined?(MAIL_SPEC_SUITE_RUNNING)
    STDOUT.puts "Compiling all parsers from treetop source"

    parsers.each do |parser|
      compile_parser(parser)
    end

  else
    STDOUT.puts "Loading precompiled parsers from ruby source"

    parsers.each do |parser|
      begin
        require "mail/parsers/#{parser}"
      rescue LoadError
        STDOUT.puts "Couldn't load parser #{parser} from ruby source"
        compile_parser(parser)
      end
    end

  end

end