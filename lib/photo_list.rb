class PhotoList
  attr_reader :photos

  def initialize(directory)
    @photos = Dir.glob("#{directory}/**").map do |filepath|
      Photo.new(filepath)
    end
  end
end
