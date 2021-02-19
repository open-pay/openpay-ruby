require 'ostruct'
require 'cgi'
module OpenpayUtils

  class SearchParams < OpenStruct

    #"?creation[gte]=2013-11-01&limit=2&amount[lte]=100"
    def to_str
      filter = '?'
      self.marshal_dump.each do |attribute, value|
        if attribute =~ /(\w+)_(gte|lte)/
          square_bracket_open_encode = CGI.escape('[')
          square_bracket_close_encode = CGI.escape(']')
          attribute = "#{$1}#{square_bracket_open_encode}#{$2}#{square_bracket_close_encode}"
        end
        filter << "#{attribute}=#{value}&"
      end
      filter.sub(/\&$/, '')
    end

    alias :to_s :to_str

  end
end
