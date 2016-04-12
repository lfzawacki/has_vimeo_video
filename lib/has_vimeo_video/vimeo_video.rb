module HasVimeoVideo
  class VimeoVideo

    def self.youtube_regex
      /^(https?\:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+$/
    end

    def self.regex
      /https?:\/\/(www\.)?vimeo.com\/(\d+)|^(https?\:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+$/
    end

    def initialize url
      @url = url
    end

    def id
      return @id if @id
      return unless @url
      if result = @url.match(self.class.regex)
        @id = result[2]
      end
    end

    def info
      return @info if @info
      return unless id
      @info = Vimeo::Simple::Video.info(id)
      if @info.parsed_response and @info.parsed_response[0]
        @info = @info.parsed_response[0]
      else
        @info = nil
      end
    rescue
      @info = nil
    end

    def embed_url
      "//player.vimeo.com/video/#{id}"
    end

    def thumbnail
      return unless info
      info["thumbnail_large"]
    end

    def youtube_video?
      @url.match(VimeoVideo.youtube_regex)
    end

  end
  
end
