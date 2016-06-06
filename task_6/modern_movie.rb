require_relative 'movie_to_show'

class ModernMovie < MovieToShow
  def initialize(record, host = nil)
    super(record, host)
    if !@year.to_i.between?(1969,2000)
      raise ArgumentError, "year should be in range 1969..2000"
    end
  end

  def to_s
    "#{@title} - modern movie, starring: #{@actors.join(', ')}"
  end
end