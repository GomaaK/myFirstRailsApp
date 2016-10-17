class Product < ActiveRecord::Base
	has_many :line_items
	has_many :orders, :through => :line_items
	has_many :comments, dependent: :destroy
	validates :name, presence: true

	def highest_rating_comment
  	comments.rating_desc.first
	end

	def worst_rating_comment
  	comments.rating_asc.first
	end

	def comments_count
		comments.count
	end	

	def average_rating
  	comments.average(:rating).to_f
	end

	def self.search(search_term)
		where(" lower(name) LIKE lower(?) ", "%#{search_term}%")
	end
end
