class Movie < ActiveRecord::Base
    
    def self.all_ratings
        # self.all(:select => 'rating')
		['G', 'PG', 'PG-13', 'R']
    end
	
	def self.with_ratings(ratings)
	    self.where(["rating IN (?)", ratings])
	    
	end
    
end