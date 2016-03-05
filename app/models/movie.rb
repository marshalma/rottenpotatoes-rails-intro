class Movie < ActiveRecord::Base
  def self.unique_values(column)
    Movie.select(column).map(&column).uniq
  end
end
